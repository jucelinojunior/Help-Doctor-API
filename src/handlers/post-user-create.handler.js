/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const Joi = require('joi')
const userService = require('../services/user.service')
const hospitalService = require('../services/hospital.service')
const addressService = require('../services/address.service')
const Boom = require('boom')
const bcrypt = require('bcrypt-nodejs')

const schema = Joi.object({
  name: Joi.string().min(3).required(),
  email: Joi.string().email({ minDomainAtoms: 2 }),
  password: Joi.string().required(),
  personal_document: Joi.string().regex(/\d{11}/).required(),
  responsable_hospital: Joi.number(),
  birthday: Joi.date().required(),
  roles_id: Joi.array().min(1).required(),
  genre: Joi.string().required(),
  hospitals: Joi.array().allow(null).allow([]).optional(),
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
  path: '/user',
  handler: async (request, reply) => {
    try {
        const {payload} = request
        //  Faz validação de CPF
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
        //  Acompla no usuario
        delete user.address
        user.addressId = addressAdded.id
        const userResult = await userService.add(user)

        //  Verifica se na request esta passando um array de id de hospitais
        if (user.hospitals) {
          await hospitalService.deleteAllUsersInHospital(user.id)
          for (let hospitalId of user.hospitals) {
            await hospitalService.addUserHospital(userResult.id, hospitalId)
          }
        }

        return userResult
    } catch (err) {
      console.log(err.name)
    }
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['user.create']
    },
    validate: {
      payload: schema
    },
    cors: {
      origin: ['*']
    }
  }
}
