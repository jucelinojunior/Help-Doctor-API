const hapiJWT = require('hapi-auth-jwt')

async function register (server) {
  await server.register({
    plugin: require('good'),
    options: {
      ops: {
        interval: 1000
      },
      reporters: {
        console: [{
          module: 'good-squeeze',
          name: 'Squeeze',
          args: [{ log: '*', response: '*', error: '*' }]
        }, {
          module: 'good-console',
          args: [{
            format: 'YYYY/MM/DD HH:mm:ss'
          }]
        }, 'stdout']
      }
    }
  })
  await server.register([require('hapi-auth-jwt2')])
}

module.exports = register
