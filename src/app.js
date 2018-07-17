const {server} = require('./server')
const registerRoutes = require('./routes')
const registerPlugins = require('./plugins')

module.exports = async function createServer () {
  try {
    await registerPlugins(server)
    registerRoutes(server)

    await server.start()
    console.log(`API is running at ${server.info.uri}`)
  } catch (error) {
    console.error(error)
    process.exit(1)
  }
}
