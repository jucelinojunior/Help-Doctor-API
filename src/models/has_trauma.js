const Sequelize = require('sequelize')
const Trauma = require('./trauma')

const HasTrauma = global.sequelize.define('has_trauma', {
  id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    trauma_id: {
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
    tableName: 'appointment_has_traumas'
  }
);

HasTrauma.hasMany(Trauma, {
  as: 'trauma',
  foreignKey: 'id',
  sourceKey: 'trauma_id'
});


module.exports = HasTrauma
