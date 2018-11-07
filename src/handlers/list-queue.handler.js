const queue = require('../services/queue.service')

module.exports = {
  method: 'GET',
  path: '/queue/hospital/{id}',
  handler: async (request, h) => {
    return queue.viewQueue(request.params.id)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['queue.list']
    },
    cors: {
      origin: ['*']
    }
  }
}