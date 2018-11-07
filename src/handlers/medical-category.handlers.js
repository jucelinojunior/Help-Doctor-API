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
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['medical_category.list']
    },
    cors: {
      origin: ['*']
    }
  }
}

const register = {
  method: 'POST',
  path: '/medical/category',
  handler: async (request) => {
    return userService.registerCategories(request.payload.name)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['medical_category.create']
    },
    cors: {
      origin: ['*']
    }
  }
}

module.exports = {
  list,
  register
}
