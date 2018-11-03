/**
 * Especificação de uma autorização - https://www.oauth.com/oauth2-servers/access-tokens/password-grant/
 * Response de uma token - https://www.oauth.com/oauth2-servers/access-tokens/access-token-response/
 * GERAR TOKEN - https://tools.ietf.org/html/rfc6750
 */

const userService = require('../services/user.service')
const bcrypt = require('bcrypt-nodejs')
const crypto = require('crypto')
const base64url = require('base64url')
const Boom = require('boom')
const Joi = require('joi')
const FailedToAuthenticateError = require('../errors/FailedToAuthenticateError')
const {
  APP_DOMAIN,
  APP_SECRET
} = process.env

const schema = Joi.object({
  username: Joi.string().email().required(),
  password: Joi.string().required()
})

module.exports = {
  method: 'POST',
  path: '/oauth/authorize',
  handler: async (request, reply) => {
    const validGrandTypes = ['password']
    const {grant_type: grantType} = request.query
    const { username, password } = request.payload
    if (!grantType) throw Boom.badRequest('grant_type is required')
    if (!validGrandTypes.includes(grantType)) throw Boom.badRequest('grant_type must be password value.')
    try {
      if (grantType === 'password') {
        const user = await userService.getUserByEmail(username)
        const passwordOfUser = user.password
        const criptedPassword = bcrypt.hashSync(password, user.salt)
        if (passwordOfUser === criptedPassword) {
          //  Gera a token
          const header64 = base64url(JSON.stringify({
            'typ': 'JWT',
            'alg': 'HS256'
          }))
          const permissions = user.roles.reduce((prev, role, index, currentArray) => {
            prev.push(role.actions.map(it => it.name))
            return prev
          }, [])
          console.log(permissions.join(' '))
          const expirationTime = new Date().getTime() + 1000 * 60 * 60 * 24
          const payload = {
            iss: APP_DOMAIN,
            exp: expirationTime,
            sub: user.id,
            scope: permissions[0],
            user: user
          }
          const payload64 = base64url(JSON.stringify(payload))
          const encodedSignature = `${header64}.${payload64}`
          const hmac = crypto.createHmac('sha256', Buffer.from(APP_SECRET).toString('base64'))
          const signature = hmac.update(encodedSignature).digest('base64')
          const token = `${header64}.${payload64}.${base64url.fromBase64(signature)}`
          return {
            token: token,
            type: 'Bearer',
            idTokenPayload: payload,
            exp: expirationTime
          }
        } else {
          throw new FailedToAuthenticateError()
        }
      }
    } catch (err) {
      console.error(err)
      switch (err.name) {
        case 'FailedToAuthenticateError' :
          throw Boom.unauthorized('Failed to authenticate')
        default:
          throw Boom.badImplementation('Erro descubra! Veja o log do servidor.')
      }
    }
    //  Recupera o usuario pelo username

    //  Criptografa o password passado com o salt do usuario

    //  Se o password passado e criptografado for igual ao password do documento (que ja esta criptografado) então é sucesso
    return request.params
  },
  config: {
    validate: {
      payload: schema
    },
    cors: {
      origin: ['*']
    }
  }
}
