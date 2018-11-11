const patientService = require('../services/patient.service')

module.exports = {
  method: 'DELETE',
  path: '/patient/{id}',
  handler: async (request, reply) => {
    await patientService.destroy(request.params.id, true)
    return {
      deleted: true
    }
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['patient.delete']
    },
    cors: {
      origin: ['*']
    }
  }
}
