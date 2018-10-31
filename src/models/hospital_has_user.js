const Sequelize = require('sequelize')
const Address = require('./hospital')
const User = require('./users')

const Hospital = global.sequelize.define('hospital_has_user', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  hospital_id: {
    type: Sequelize.INTEGER,
    primaryKey: true
  },
  user_id: {
    type: Sequelize.INTEGER,
    primaryKey: true
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
  tableName: 'hospital_has_user'
})

// Hospital.hasMany(Address, {
//   as: 'hospital',
//   foreignKey: 'id',
//   sourceKey: 'hospital_id'
// })

// Hospital.hasMany(User, {
//   as: 'user',
//   foreignKey: 'id',
//   sourceKey: 'hospital_id'
// })

module.exports = Hospital
