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
  id: Joi.number().optional(),
  name: Joi.string().min(3),
  email: Joi.string().email({ minDomainAtoms: 2 }),
  password: Joi.string(),
  personal_document: Joi.string(),
  responsable_hospital: Joi.string().allow('').allow(null),
  birthday: Joi.date(),
  roles_id: Joi.array(),
  roles: Joi.array(),
  genre: Joi.string(),
  deletedAt: Joi.allow(null).optional(),
  hospitals: Joi.array().allow(null).allow([]).optional(),
  address: Joi.object({
    id: Joi.number().optional(),
    address: Joi.string(),
    neighborhood: Joi.string(),
    state: Joi.string(),
    zipcode: Joi.string(),
    state: Joi.string(),
    formatedaddress: Joi.string(),
    city: Joi.string(),
    number: Joi.number(),
    complement: Joi.string().allow('').allow(null).optional()
  })
})
module.exports = {
  method: 'PUT',
  path: '/user/{id}',
  handler: async (request, reply) => {
    // try{
      //Pega o user do JWT
      const {scope, user:userJWT} = request.auth.credentials

      const {payload} = request

      //  Recupera o usuario
      const user = await userService.find(request.params.id, true)

      // Verifica se o usuario que ele deseja editar é o mesmo da JWT
      const isSelfUpdate = user.id === userJWT.id

      if (!isSelfUpdate && !scope.includes('user.update_all')) throw Boom.unauthorized('Você esta tentando editar um usuario que não é seu.')

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

      //  Verifica se na request esta passando um array de id de hospitais
      if (payload.hospitals) {
        //  Deleta todos os vinculos
        await hospitalService.deleteAllUsersInHospital(user.id)
        for (let hospitalId of payload.hospitals) {
          await hospitalService.addUserHospital(user.id, hospitalId)
        }
      }

      userResult.address = addressResult
      return userResult
    // }catch (err) {
    //   console.log(err.name)
    //   return Boom.badImplementation(err.message)
    // }
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['user.update']
    },
    validate: {
      payload: schema
    },
    cors: {
      origin: ['*']
    }
  }
}
