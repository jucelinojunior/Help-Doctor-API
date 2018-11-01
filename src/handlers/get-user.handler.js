/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const Joi = require('joi')
const userService = require('../services/user.service')
const addressService = require('../services/address.service')
const Boom = require('boom')
const bcrypt = require('bcrypt-nodejs')

module.exports = {
  method: 'GET',
  path: '/user/{id}',
  handler: async (request, reply) => {
    try {
      const {id} = request.params
      const user = await userService.find(id)
      return user
    } catch (err) {
      console.error(err)
      throw Boom.badImplementation('Bad Implementation')
    }
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['user.find']
    }
  }
}
