const Sequelize = require('sequelize')
const Address = require('./address')

const Hospital = global.sequelize.define('hospital', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: Sequelize.STRING
  },
  address: {
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
  // freezeTableName: true,
  tableName: 'hospital'
})

module.exports = Hospital
