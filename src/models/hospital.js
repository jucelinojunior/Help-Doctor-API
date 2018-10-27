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
  }
},
{
  paranoid: true,
  // freezeTableName: true,
   tableName: 'hospital'
})

Hospital.hasMany(Address, {
    as: 'address_info',
    foreignKey: 'id',
    sourceKey: 'address'
});

module.exports = Hospital
