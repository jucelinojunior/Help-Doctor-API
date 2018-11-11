const Sequelize = require('sequelize')
const Hospitals = require('./hospital')

const HospitalHasUsers = global.sequelize.define('hospital_has_user', {
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
  paranoid: false,
  // freezeTableName: true,
  tableName: 'hospital_has_user'
})

HospitalHasUsers.belongsTo(Hospitals, {
  as: 'hospital',
  foreignKey: 'hospital_id'
})

module.exports = HospitalHasUsers
