const {server} = require('./server')
const registerRoutes = require('./routes')
const registerPlugins = require('./plugins')
const registerDatabase = require('./database')
const {APP_SECRET} = process.env

module.exports = async function createServer () {
  try {
    await registerPlugins(server)
    await registerDatabase()
    registerRoutes(server)

    // server.auth.strategy('helpdoctor-auth', 'jwt', {
    //   key: new Buffer(APP_SECRET, 'base64'),
    //   verifyOptions: {
    //     algorithms: ['HS256']
    //   }
    // })
    await server.start()
    console.log(`API is running at ${server.info.uri}`)
  } catch (error) {
    console.error(error)
    process.exit(1)
  }
}
