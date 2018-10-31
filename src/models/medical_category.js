const Sequelize = require('sequelize')

const Hospital = global.sequelize.define('medical_category', {
  id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
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
    tableName: 'medical_category'
  }
);

module.exports = Hospital
