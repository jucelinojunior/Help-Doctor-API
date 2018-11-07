const userService = require('../services/user.service')

module.exports = {
  method: 'DELETE',
  path: '/user/{id}',
  handler: async (request, reply) => {
    await userService.destroy(request.params.id, true)
    return {
      deleted: true
    }
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['user.delete']
    },
    cors: {
      origin: ['*']
    }
  }
}
