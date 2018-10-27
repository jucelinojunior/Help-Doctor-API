const userService = require('../services/hospital.service');

module.exports = {
  method: 'POST',
  path: '/hospital/user',
  handler: async (request, reply) => {
    return userService.users(request.payload.user,request.payload.hospital);
  } 
}