/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const userService = require('../services/hospital.service')

const list = {
  method: 'GET',
  path: '/medical/category',
  handler: async (request) => {
    return userService.getAllCategories()
  }
}

const register = {
  method: 'POST',
  path: '/medical/category',
  handler: async (request) => {
    return userService.registerCategories(request.payload.name);
  },
  options: {
    cors: {
      origin: ['*']
    }
  }
}

module.exports = {
  list,
  register
}
