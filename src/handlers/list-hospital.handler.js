/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const hospitalService = require('../services/hospital.service')

module.exports = {
  method: 'GET',
  path: '/hospital',
  handler: async (request) => {
  	if(request.query.name){
  		return hospitalService.getAll(request.query.name);
  	}
  	if(request.query.address) {
  		return hospitalService.getAll("",request.query.address);
  	}
    return hospitalService.getAll()
  },
  options: {
    cors: {
      origin: ['*']
    }
  }
}
