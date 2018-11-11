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
  name: Joi.string().min(3),
  email: Joi.string().email({ minDomainAtoms: 2 }),
  password: Joi.string(),
  personal_document: Joi.string(),
  birthday: Joi.date(),
  genre: Joi.string(),
  phoneNumber: Joi.string().optional(),
  deletedAt: Joi.allow(null).optional(),
  address: Joi.object({
    address: Joi.string(),
    neighborhood: Joi.string(),
    state: Joi.string(),
    zipcode: Joi.string(),
    state: Joi.string(),
    city: Joi.string(),
    number: Joi.number(),
    complement: Joi.string().allow('').allow(null).optional()
  })
})
module.exports = {
  method: 'PUT',
  path: '/patient/{id}',
  handler: async (request, reply) => {
    //Pega o user do JWT

    const {payload} = request

    //  Recupera o paciente
    const patient = await patientService.findById(request.params.id, true)

    console.log(patient)

    //  Atualiza o endereço
    let addressResult = null
    if (payload.address) {
      addressResult = await addressService.update(payload.address.id, payload.address)
    }

    //  Atualiza o usuario
    const patientResult = await patientService.update(request.params.id, payload)

    patientResult.address = addressResult
    return patientResult
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['patient.update']
    },
    validate: {
      payload: schema
    },
    cors: {
      origin: ['*']
    }
  }
}
