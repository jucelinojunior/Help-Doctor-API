const Sequelize = require('sequelize')
const Roles = require('./roles')
const Actions = require('./actions')
const Address = require('./address')
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
    type: Sequelize.INTEGER
  },
  password: {
    type: Sequelize.STRING
  },
  birthday: {
    type: Sequelize.DATEONLY
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
User.hasOne(Address, {
  as: 'address',
  foreignKey: 'id',
  targetKey: 'addressId'
})
User.belongsToMany(Roles, {
  as: 'roles',
  through: 'users_has_roles',
  foreignKey: 'user_id',
  targetKey: 'id',
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
