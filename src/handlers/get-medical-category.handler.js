/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const userService = require('../services/hospital.service')

module.exports = {
  method: 'GET',
  path: '/medical/category',
  handler: async (request) => {
    return userService.getAllCategories()
  }
}
