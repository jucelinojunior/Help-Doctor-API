const glob = require('glob')
const path = require('path')

function register (server) {
  const handlers = glob.sync(path.join(__dirname, './handlers/*.js'))
  handlers.forEach(handler => server.route(require(handler)))
}

module.exports = register
