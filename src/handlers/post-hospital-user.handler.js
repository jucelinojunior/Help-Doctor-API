const userService = require('../services/hospital.service');

module.exports = {
  method: 'POST',
  path: '/hospital/user',
  handler: async (request, reply) => {
    return userService.addUserHospital(request.payload.user, request.payload.hospital)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['hospital_user.add']
    },
    cors: {
      origin: ['*']
    }
  }
}
