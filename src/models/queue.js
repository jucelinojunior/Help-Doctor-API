const Sequelize = require('sequelize')
const Address = require('./address')

const Hospital = global.sequelize.define('queue', {
  id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    hospital_id: {
      type: Sequelize.INTEGER
    },
    appointment_id: {
      type: Sequelize.INTEGER
    },
    severity: {
      type: Sequelize.INTEGER
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
  },
  {
    paranoid: true,
    tableName: 'queue'
  }
);

module.exports = Hospital
