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
  }
},
{
  paranoid: true,
  // freezeTableName: true,
  // tableName: 'TB_HOSPITAL'
})
// Hospital.belongsTo(Address, {
//   foreignKey: 'address_id'
// })
module.exports = Hospital
