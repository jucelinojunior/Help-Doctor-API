const Sequelize = require('sequelize')

const Hospital = global.sequelize.define('pain', {
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
    tableName: 'pain'
  }
);

module.exports = Hospital
