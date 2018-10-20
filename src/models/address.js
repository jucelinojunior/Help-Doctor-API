
const Sequelize = require('sequelize')
const Address = global.sequelize.define('address', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  address: {
    type: Sequelize.STRING
  },
  neighborhood: {
    type: Sequelize.STRING
  },
  state: {
    type: Sequelize.STRING
  },
  zipcode: {
    type: Sequelize.STRING
  },
  formatedAddress: {
    type: Sequelize.STRING
  },
  number: {
    type: Sequelize.STRING
  },
  complement: {
    type: Sequelize.STRING
  }
},
{
  paranoid: true,
  freezeTableName: true,
  // tableName: 'TB_ADDRESS'
})
module.exports = Address
