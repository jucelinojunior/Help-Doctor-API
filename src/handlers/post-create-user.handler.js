/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const Joi = require('joi')
const userService = require('../services/user.service')
const crypto = require('crypto')
const bcrypt = require('bcrypt-nodejs')
const {APP_SECRET} = process.env

const schema  = Joi.object({
  name: Joi.string().min(3).required(),
  email: Joi.string().email({ minDomainAtoms: 2 }),
  password: Joi.string().required(),
  personal_document: Joi.string().regex(/\d{11}/).required(),
  responsable_hospital: Joi.number(),
  addressId: Joi.number().required(),
  birthday: Joi.string().required(),
  roles_id: Joi.array().min(1).required()
})
module.exports = {
  method: 'POST',
  path: '/create/user',
  handler: async (request, reply) => {
    //  Faz validação de CPF
    const {payload} = request
    const salt = bcrypt.genSaltSync(10)
    const user = {
      ...payload,
      salt: salt,
      birthday: new Date(payload.birthday),
      password: bcrypt.hashSync(payload.password, salt)
    }
    return userService.getAll()
    // await userService.add(user)
    // return user
  },
  config: {
    validate: {
      payload: schema
    }
  }
}