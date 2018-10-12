const Hapi = require('hapi')
const Boom = require('Boom')
console.log(process.env.PORT)
const server = Hapi.server({
  port: process.env.PORT || 6789,
  routes: {
    validate: {
      failAction: async (request, h, err) => {
        if (process.env.NODE_ENV === 'production') {
          throw Boom.badRequest(err.message)
        } else {
          console.error(err)
          throw err
        }
      }
    }
  }
})

module.exports = {
  server
}
