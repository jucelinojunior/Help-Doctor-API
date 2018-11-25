const queue = require('../services/queue.service')
const userService = require('../services/user.service')
const Appointment = require('../models/appointment')
const medicalRecords = require('../models/pronouncer')
const Hospital = require('../models/hospital');
const Patient = require('../models/patient');
const User = require('../models/users');
const Categories = require('../models/medical_category');
const Types = require('../models/type_appointment');

const update = {
  method: 'PUT',
  path: '/appointment/{id}',
  handler: async (request, h) => {

    if (request.query.remove) {
      queue.removeInQueue(request.query.remove)
    }

    const appointment = await Appointment.findOne({
      where: {
        id: request.params.id
      }
    })

    return appointment.update(request.payload).then(() => {
      if (request.query.queue) {
        queue.insertQueue(request.params.id)
      }
      return {errors: false, data: appointment}
    });

  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['appointment.update']
    },
    cors: {
      origin: ['*']
    }
  }
}

const list = {
  method: 'GET',
  path: '/appointment/{id?}',
  handler: async (request, h) => {

    var method = request.params.id ? 'findOne' : 'findAll';
    var obj = {};
    const {scope, user} = request.auth.credentials;
    //var scope = ['appointment.list','appointment.view']
    if (request.params.id) {

      obj.id = request.params.id;

      //Se não for um usuário de listar qualquer prontuário, listo apenas o dono (medico)
      if (!scope.includes('appointment.view')) {
        obj.user_id = user.id;
      }

    } else {

      //Se não puder lista todos os usários, listo apenas os meus (medicos)
      if (!scope.includes('appointment.list')) {
        obj.user_id = user.id;
      }

    }

    const appointment = await Appointment[method]({
      where: obj,
      include: [
        {
            model: Categories,
            as: 'category',
            require: true,
            attributes: [
              'id',
              'name'
            ]
        },
        {
          model: Types,
          as: 'type',
          require: true,
          attributes: [
            'id',
            'name'
          ]
        },
        {
            model: User,
            as: 'user',
            require: true,
            attributes: userService.FIELDS,
            include: userService.DEFAULT_INCLUDES
        },
        {
          model: medicalRecords,
          as: 'pronouncer',
          required: false,
          attributes: [
            'id',
            'patient_id',
            'hospital_id',
            'type_pronouncer',
            'description'
          ],
          include: [
          {
            model: Patient,
            as: 'patient',
            required: true,
            attributes: [
              'id',
              'name',
              'email',
              'personal_document',
              'birthday',
              'genre'
            ]
          },
          {
            model: Hospital,
            as: 'hospital',
            required: true,
            attributes: [
              'id',
              'name',
            ]
          }
          ]
        }
      ]
    });

    return {errors: false, data: appointment};

  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['appointment.basic']
    },
    cors: {
      origin: ['*']
    }
  }
}

const create = {
  method: 'POST',
  path: '/appointment',
  handler: async (request, h) => {

    const keys = ["pronouncer_id", "type_id", "description", "skin_burn", "fever", "convulsion", "asthma", "vomit", "medical_category_id", "diarrhea", "heart_attack", "hypovolemic_shock", "apnea", "is_pregnant", "medical_return", "status"];
    const {scope, user} = request.auth.credentials;

    for (key in keys) {
      if(!request.payload.hasOwnProperty(keys[key])) {
        return {errors: true, data: 'Faltando atributo '+keys[key]}
      }
    }

    const appointment = new Appointment();

    request.payload.schedule = new Date();
    request.payload.user_id = user.id;

    return appointment.update(request.payload).then(() => {
      return {errors: false, data: appointment}
    });

  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['appointment.create']
    },
    cors: {
      origin: ['*']
    }
  }
}

const destroy = {
  method: 'DELETE',
  path: '/appointment/{id}',
  handler: async (request, h) => {
    return userService.destroy(request.params.id);
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['appointment.delete']
    },
    cors: {
      origin: ['*']
    }
  }
}

module.exports = {
  update,
  list,
  create,
  destroy
}
