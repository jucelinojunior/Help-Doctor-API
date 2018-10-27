/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const hospitalService = require('../services/hospital.service')

module.exports = {
  method: 'GET',
  path: '/hospital',
  handler: async (request) => {
    return hospitalService.getAll()
  }
  // config: {
    
  // }
}
