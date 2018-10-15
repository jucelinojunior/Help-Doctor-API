const userService = require('../services/user.service')
const bcrypt = require('bcrypt-nodejs')
const Boom = require('Boom')
/**
 * Especificação de uma autorização - https://www.oauth.com/oauth2-servers/access-tokens/password-grant/
 * Response de uma token - https://www.oauth.com/oauth2-servers/access-tokens/access-token-response/
 * GERAR TOKEN - https://tools.ietf.org/html/rfc6750
 */
module.exports = {
  method: 'POST',
  path: '/oauth/authorize',
  handler: async (request, reply) => {
    console.log(request.payload)
    const {username, password} = request.payload
    const {grant_type} = request.query
    console.log(grant_type)
    if (grant_type === 'password') {
      const user = await userService.getUserByDocument(username)
      console.log(user)
      const passwordOfUser = user.password
      const criptedPassword = bcrypt.hashSync(password, user.salt) 
      console.log({passwordOfUser})
      console.log({criptedPassword})
      if (passwordOfUser === criptedPassword) {
        return true
      } else {
        return Boom.badRequest('Bad authentication')
      }
      return user
    }
    //  Recupera o usuario pelo username

    //  Criptografa o password passado com o salt do usuario

    //  Se o password passado e criptografado for igual ao password do documento (que ja esta criptografado) então é sucesso
    return request.params
  }
}
