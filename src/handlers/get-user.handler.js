/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const userService = require('../services/user.service')
const Boom = require('boom')

module.exports = {
  method: 'GET',
  path: '/user/{id}',
  handler: async (request, reply) => {
    try {
      const {id} = request.params
      const showDeleteds = request.query.deleteds === undefined ? false : true
      const user = await userService.find(id, showDeleteds)
      if (!user) return {}
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
