/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const hospitalService = require('../services/hospital.service')

module.exports = {
  method: 'GET',
  path: '/hospital/{id}',
  handler: async (request) => {
    return hospitalService.findById(request.params.id);
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['hospital.find']
    },
    cors: {
      origin: ['*']
    }
  }
}
