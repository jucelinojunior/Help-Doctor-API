/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const Joi = require('joi')
const userService = require('../services/user.service')
const addressService = require('../services/address.service')
const Boom = require('boom')
const bcrypt = require('bcrypt-nodejs')

const schema  = Joi.object({
  name: Joi.string().min(3).required(),
  email: Joi.string().email({ minDomainAtoms: 2 }),
  password: Joi.string().required(),
  personal_document: Joi.string().regex(/\d{11}/).required(),
  responsable_hospital: Joi.number(),
  birthday: Joi.string().required(),
  roles_id: Joi.array().min(1).required(),
  genre: Joi.string().required(),
  address: Joi.object({
    address: Joi.string().required(),
    neighborhood: Joi.string().required(),
    state: Joi.string().required(),
    zipcode: Joi.string().required(),
    number: Joi.number().required(),
    complement: Joi.string().allow('').optional()
  })
})
module.exports = {
  method: 'POST',
  path: '/user',
  handler: async (request, reply) => {
    const {payload} = request
    //  Faz validação de CPF
    if (userService.validateCPF(payload.personal_document)) {
      const salt = bcrypt.genSaltSync(10)
      const user = {
        ...payload,
        salt: salt,
        birthday: new Date(payload.birthday),
        password: bcrypt.hashSync(payload.password, salt)
      }
      //  Tenta encontrar ou recuperar um endereço
      const {address} = user
      const addressAdded = await addressService.register(address)
      console.log(addressAdded, addressAdded.id)
      //  Acompla no usuario
      delete user.address
      user.addressId = addressAdded.id
      // user.addressId = 1
      console.log('==>', user)
      await userService.add(user)
      return user
    } else {
      throw Boom.badRequest('CPF Invalido')
    }
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['user.create']
    },
    validate: {
      payload: schema
    }
  }
}
