const Sequelize = require('sequelize')
const User = require('./users')
const Pronouncer = require('./pronouncer');
const HasPain = require('./has_pain');
const HasTrauma = require('./has_trauma');
const Appointment = global.sequelize.define('appointment', {
  id: {
    type: Sequelize.STRING,
    primaryKey: true,
    autoIncrement: true
  },
  pronouncer_id: {
    type: Sequelize.INTEGER
  },
  schedule: {
    type: Sequelize.DATE
  },
  type_id: {
    type: Sequelize.INTEGER
  },
  medical_category_id: {
    type: Sequelize.INTEGER
  },
  description: {
    type: Sequelize.STRING
  },
  user_id: {
    type: Sequelize.INTEGER
  },
  skin_burn: {
    type: Sequelize.INTEGER
  },
  fever: {
    type: Sequelize.FLOAT
  },
  convulsion: {
    type: Sequelize.INTEGER
  },
  asthma: {
    type: Sequelize.BOOLEAN
  },
  vomit: {
    type: Sequelize.BOOLEAN
  },
  diarrhea: {
    type: Sequelize.BOOLEAN
  },
  heart_attack: {
    type: Sequelize.BOOLEAN
  },
  hypovolemic_shock: {
    type: Sequelize.BOOLEAN
  },
  apnea: {
    type: Sequelize.BOOLEAN
  },
  is_pregnant: {
    type: Sequelize.BOOLEAN
  },
  medical_return: {
    type: Sequelize.BOOLEAN
  },
  status: {
    type: Sequelize.INTEGER
  },
  createdAt: {
    type: Sequelize.DATE
  },
  updatedAt: {
    type: Sequelize.DATE
  },
  deletedAt: {
    type: Sequelize.DATE
  }
  }, {
  paranoid: true,
  tableName: 'appointment'
})

Appointment.hasMany(User, {
  as: 'user',
  foreignKey: 'id',
  sourceKey: 'user_id'
})

Appointment.hasMany(HasPain, {
  as: 'has_pain',
  foreignKey: 'appointment_id',
  sourceKey: 'id'
})

Appointment.hasMany(HasTrauma, {
  as: 'has_trauma',
  foreignKey: 'appointment_id',
  sourceKey: 'id'
});

Appointment.hasMany(Pronouncer, {
  as: 'pronouncer',
  foreignKey: 'id',
  sourceKey: 'pronouncer_id'
})

module.exports = Appointment
