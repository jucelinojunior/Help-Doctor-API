/**
 * Rota repsonsável por listar os pacientes
 */
const patientService = require('../services/patient.service')

module.exports = {
  method: 'GET',
  path: '/patient/{id}',
  handler: async (request) => {
    return patientService.findById(request.params.id)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['patient.find']
    },
    cors: {
      origin: ['*']
    }
  }
}
