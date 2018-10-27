const Sequelize = require('sequelize')

const Patient = require('./patient');

const Hospital = global.sequelize.define('pronouncer', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  patient_id: {
    type: Sequelize.INTEGER
  },
  hospital_id: {
    type: Sequelize.INTEGER
  },
  type_pronouncer: {
    type: Sequelize.INTEGER
  },
  description: {
    type: Sequelize.STRING
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
},
{
  paranoid: true,
  // freezeTableName: true,
  tableName: 'pronouncer'
})

Hospital.hasMany(Patient, {
  as: 'patient',
  foreignKey: 'id',
  sourceKey: 'patient_id'
});

module.exports = Hospital
