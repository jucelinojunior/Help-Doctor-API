const Sequelize = require('sequelize')
const Roles = require('./roles')
const Address = require('./address')
const Hospital = require('./hospital')
// const UsersHasRoles = require('./users_has_roles')
const User = global.sequelize.define('users', {
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
  salt: {
    type: Sequelize.STRING
  },
  addressId: {
    type: Sequelize.INTEGER,
    underscored: true
  },
  password: {
    type: Sequelize.STRING
  },
  birthday: {
    type: Sequelize.DATEONLY
  },
  genre: {
    type: Sequelize.STRING
  },
  responsable_hospital: {
    type: Sequelize.INTEGER,
    allowNull: true
  },
  medical_document: {
    type: Sequelize.INTEGER,
    allowNull: true
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
  paranoid: true
})

User.belongsTo(Address)

User.belongsToMany(Roles, {
  as: 'roles',
  through: 'users_has_roles',
  foreignKey: 'user_id',
  targetKey: 'id',
  contraints: false
})

User.belongsToMany(Hospital, {
  as: 'hospitals',
  through: 'hospital_has_user',
  foreignKey: 'user_id',
  contraints: false

})

Hospital.belongsToMany(User, {
  as: 'users',
  through: 'hospital_has_user',
  foreignKey: 'hospital_id',
  contraints: false
})

Roles.belongsToMany(User, {
  as: 'users',
  through: 'users_has_roles',
  foreignKey: 'user_id',
  contraints: false
})

// Actions.belongsToMany(Roles, {
//   as: 'roles',
//   through: 'roles_has_actions',
//   foreignKey: 'action_id',
//   contraints: false
// })

module.exports = User
