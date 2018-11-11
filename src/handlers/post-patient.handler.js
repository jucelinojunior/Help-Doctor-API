/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const Joi = require('joi')
const patientService = require('../services/patient.service')
const addressService = require('../services/address.service')
const Boom = require('boom')
const bcrypt = require('bcrypt-nodejs')

const schema = Joi.object({
  name: Joi.string().min(3).required(),
  email: Joi.string().email({ minDomainAtoms: 2 }),
  personal_document: Joi.string().regex(/\d{15}/).required(),
  birthday: Joi.date().required(),
  genre: Joi.string().required(),
  phoneNumber: Joi.string().required(),
  address: Joi.object({
    address: Joi.string().required(),
    neighborhood: Joi.string().required(),
    city: Joi.string().required(),
    state: Joi.string().required(),
    zipcode: Joi.string().required(),
    number: Joi.number().required(),
    complement: Joi.string().allow('').allow(null).optional()
  }).required()
})
module.exports = {
  method: 'POST',
  path: '/patient',
  handler: async (request, reply) => {
    const {payload} = request

      //  Tenta encontrar ou recuperar um endereço
      const {address} = payload
      const addressAdded = await addressService.register(address)
      console.log(addressAdded, addressAdded.id)
      //  Acompla no usuario
      payload.addressId = addressAdded.id

      return patientService.add(payload)

  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['patient.create']
    },
    validate: {
      payload: schema
    },
    cors: {
      origin: ['*']
    }
  }
}
