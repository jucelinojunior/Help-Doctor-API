const Sequelize = require('sequelize')

const Hospital = global.sequelize.define('trauma', {
  id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    pain_name: {
      type: Sequelize.STRING
    },
    severity: {
      type: Sequelize.INTEGER
    },
    trauma_type: {
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
    tableName: 'trauma'
  }
);

module.exports = Hospital
