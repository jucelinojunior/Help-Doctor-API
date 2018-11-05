/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const Joi = require('joi')
const userService = require('../services/user.service')
const addressService = require('../services/address.service')
const Boom = require('boom')
const bcrypt = require('bcrypt-nodejs')

const schema = Joi.object({
  name: Joi.string().min(3),
  email: Joi.string().email({ minDomainAtoms: 2 }),
  password: Joi.string(),
  personal_document: Joi.string().regex(/\d{11}/),
  responsable_hospital: Joi.number(),
  birthday: Joi.date(),
  roles_id: Joi.array().min(1),
  genre: Joi.string(),
  deletedAt: Joi.allow(null).optional(),
  address: Joi.object({
    address: Joi.string(),
    neighborhood: Joi.string(),
    state: Joi.string(),
    zipcode: Joi.string(),
    number: Joi.number(),
    complement: Joi.string().allow('').optional()
  })
})
module.exports = {
  method: 'PUT',
  path: '/user/{id}',
  handler: async (request, reply) => {
    const {payload} = request
    if (payload.personal_document) {
      //  Faz validação de CPF
      const isValid = userService.validateCPF(payload.personal_document)
      if (!isValid) throw Boom.badRequest('CPF Invalido')
    }

    //  Recupera o usuario
    const user = await userService.find(request.params.id, true)

    //  Atualiza o endereço
    let addressResult = null
    if (payload.address) {
      addressResult = await addressService.update(user.address.id, payload.address)
    }
    //  Verifica se no payload tem senha
    if (payload.password) {
      payload.password = bcrypt.hashSync(payload.password, payload.salt)
    }
    //  Atualiza o usuario
    const userResult = await userService.update(user.id, payload)

    userResult.address = addressResult
    return userResult
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['user.update']
    },
    validate: {
      payload: schema
    }
  }
}
