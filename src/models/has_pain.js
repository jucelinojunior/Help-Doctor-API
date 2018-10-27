const Sequelize = require('sequelize')
const Pain = require('./pain')

const Hospital = global.sequelize.define('has_pain', {
  id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    pain_id: {
      type: Sequelize.INTEGER
    },
    appointment_id: {
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
    tableName: 'appointment_has_pain'
  }
);

Hospital.hasMany(Pain, {
  as: 'pain',
  foreignKey: 'id',
  sourceKey: 'pain_id'
});


module.exports = Hospital
