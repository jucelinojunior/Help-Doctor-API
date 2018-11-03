/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const userService = require('../services/user.service')

module.exports = {
  method: 'GET',
  path: '/user/all',
  handler: async (request) => {
    return userService.getAll()
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['user.all']
    },
    cors: {
      origin: ['*']
    }
  }
}
