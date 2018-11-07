/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const hospitalService = require('../services/hospital.service')

module.exports = {
  method: 'GET',
  path: '/hospital',
  handler: async (request) => {
    const {scope, user} = request.auth.credentials
    if (scope.includes('hospital.all')) {
      if (request.query.name) {
        return hospitalService.getAll(request.query.name)
      }
  
      if (request.query.address) {
        return hospitalService.getAll('', request.query.address)
      }
      return hospitalService.getAll()
    } else { // Não possui a action list
      //  Pega todos os hospitais em que ele esta participando
      //  Retorna apenas hospitais que o usuario esteja participando
      if (request.query.name) {
        return hospitalService.hospitalsByUser(user.id, request.query.name)
      }

      if (request.query.address) {
        return hospitalService.hospitalsByUser(user.id, '', request.query.address)
      }
      return hospitalService.hospitalsByUser(user.id)
    }
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['hospital.list']
    },
    cors: {
      origin: ['*']
    }
  }
}
