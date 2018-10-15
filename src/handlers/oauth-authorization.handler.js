const userService = require('../services/user.service')
const bcrypt = require('bcrypt-nodejs')
const crypto = require('crypto')
const base64url = require('base64url')
const {
  APP_DOMAIN,
  APP_SECRET
} = process.env
// const Boom = require('boom')
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
    const grantType = request.query.grant_type

    if (grantType === 'password') {
      const user = await userService.getUserByDocument(username)
      console.log(user)
      const passwordOfUser = user.password
      const criptedPassword = bcrypt.hashSync(password, user.salt)

      if (passwordOfUser === criptedPassword) {
        //  Gera a token
        const header64 = base64url(JSON.stringify({
          'typ': 'JWT',
          'alg': 'HS256'
        }))
        const payload = {
          iss: APP_DOMAIN,
          exp: 0,
          sub: user.id,
          roles: user.roles,
          user: user
        }
        const payload64 = base64url(JSON.stringify(payload))

        const encodedSignature = `${header64}.${payload}`
        const hmac = crypto.createHmac('sha256', Buffer.from(APP_SECRET).toString('base64'))
        const signature = hmac.update(encodedSignature).digest('base64')
        const token = `${header64}.${payload64}.${base64url.fromBase64(signature)}`
        return {
          token: token,
          type: 'Bearer',
          user: user
        }
      } else {
        throw Boom.badRequest('Bad authentication')
      }
      return user
    }
    //  Recupera o usuario pelo username

    //  Criptografa o password passado com o salt do usuario

    //  Se o password passado e criptografado for igual ao password do documento (que ja esta criptografado) então é sucesso
    return request.params
  }
}
