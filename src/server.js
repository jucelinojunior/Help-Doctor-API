const Hapi = require('hapi')
console.log(process.env.PORT)
const server = Hapi.server({
  port: process.env.PORT || 6789
})

module.exports = {
  server
}
