/**
 * Rota repsonsável pela criação de usuários
 * https://imasters.com.br/devsecops/encriptando-senhas-com-o-bcrypt
 */
const medicalRecords = require('../services/medical-records.service')

const create = {
  method: 'POST',
  path: '/medical-records',
  handler: async (request) => {
    return medicalRecords.create(request.payload);
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['prontuario.create']
    },
    cors: {
      origin: ['*']
    }
  }
}

const update = {
  method: 'PUT',
  path: '/medical-records/{id}',
  handler: async (request) => {
    return medicalRecords.update(request.params.id,request.payload);
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['prontuario.put']
    },
    cors: {
      origin: ['*']
    }
  }
}

const listByHospital = {
  method: 'GET',
  path: '/medical-records/hospital/{id}',
  handler: async (request) => {
    return medicalRecords.getAll(false,request.params.id,'hospital_id');
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['prontuario.basic']
    },
    cors: {
      origin: ['*']
    }
  }
}

const listByPatient = {
  method: 'GET',
  path: '/medical-records/patient/{id}',
  handler: async (request) => {
    return medicalRecords.getAll(false,request.params.id,'patient_id');
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['prontuario.basic']
    },
    cors: {
      origin: ['*']
    }
  }
}

const listByPatientInHospital = {
  method: 'GET',
  path: '/medical-records/patient/{id}/hospital/{hospital}',
  handler: async (request) => {
    return medicalRecords.getAll(false,request.params.id,'patient_id',request.params.hospital,'hospital_id');
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['prontuario.basic']
    },
    cors: {
      origin: ['*']
    }
  }
}

const getMedicalRecords = {
  method: 'GET',
  path: '/medical-records/{id}',
  handler: async (request) => {

    const {scope, user} = request.auth.credentials;
    
    if(scope.includes('prontuario.full')) {
      return medicalRecords.getAll(true,request.params.id,'id');
    } else {
      return medicalRecords.getAll(false,request.params.id,'id');
    }
  },
  
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['prontuario.basic']
    },
    cors: {
      origin: ['*']
    }
  }

}

module.exports = {
  create,
  update,
  listByHospital,
  listByPatient,
  listByPatientInHospital,
  getMedicalRecords
}