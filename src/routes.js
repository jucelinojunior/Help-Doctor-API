const glob = require('glob')
const path = require('path')

function register (server) {
  const handlers = glob.sync(path.join(__dirname, './handlers/*.handler.js'))
  handlers.forEach(handler => server.route(require(handler)))
  const mHandlers = glob.sync(path.join(__dirname, './handlers/*.handlers.js'))

  for (var i in mHandlers) {
  	var hs = require(mHandlers[i]);
  	for (var j in hs) {
      if(!hs[j].config) {
        hs[j].config = {
          cors: {
            origin: ['*']
          }
        }
      }
  		server.route(hs[j]);
  	}
  }

}

module.exports = register
