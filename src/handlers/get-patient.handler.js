/**
 * Rota repsonsável por listar os pacientes
 */
const patientService = require('../services/patient.service')

module.exports = {
  method: 'GET',
  path: '/patient',
  handler: async (request) => {
    return patientService.getAll()
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['patient.list']
    },
    cors: {
      origin: ['*']
    }
  }
}
