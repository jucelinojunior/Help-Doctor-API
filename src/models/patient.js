const Sequelize = require('sequelize')

const Address = require('./address')

const Patient = global.sequelize.define('patient', {
  id: {
    type: Sequelize.STRING,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: Sequelize.STRING
  },
  email: {
    type: Sequelize.STRING
  },
  personal_document: {
    type: Sequelize.STRING
  },
  addressId: {
    type: Sequelize.INTEGER,
    underscored: true
  },
  phoneNumber: {
    type: Sequelize.STRING
  },
  birthday: {
    type: Sequelize.DATEONLY
  },
  genre: {
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
}, {
  paranoid: true,
  tableName: 'patient'
})

Patient.belongsTo(Address)


module.exports = Patient
