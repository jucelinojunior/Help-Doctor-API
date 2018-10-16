const {server} = require('./server')
const registerRoutes = require('./routes')
const registerPlugins = require('./plugins')
const registerDatabase = require('./database')
const {APP_SECRET} = process.env

module.exports = async function createServer () {
  try {
    await registerPlugins(server)
    await registerDatabase()

    server.auth.strategy('helpdoctor', 'jwt', {
      key: Buffer.from(APP_SECRET).toString('base64'),
      validate: async function (decoded, request, h) {
        return { isValid: true }
      },
      verifyOptions: {
        algorithms: ['HS256']
      }
    })
    registerRoutes(server)

    await server.start()
    console.log(`API is running at ${server.info.uri}`)
  } catch (error) {
    console.error(error)
    process.exit(1)
  }
}
