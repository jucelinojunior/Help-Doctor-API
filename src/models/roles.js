
const Sequelize = require('sequelize')
const Actions = require('./actions')
const RolesHasActions = require('./roles_has_actions')
// const User = require('./users')
// const UsersHasRoles = require('./users_has_roles')

const Roles = global.sequelize.define('roles', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: Sequelize.STRING
  },
  label: {
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
},
{
  paranoid: true
})

Roles.belongsToMany(Actions, {
  as: 'actions',
  through: 'roles_has_actions',
  foreignKey: 'role_id'
})

Actions.belongsToMany(Roles, {
  as: 'roles',
  through: 'roles_has_actions',
  foreignKey: 'action_id',
  contraints: false
})

// Roles.hasMany(Actions, {
//   as: 'actions',
//   // through: 'roles_has_actions',
//   foreignKey: 'role_id'
//   // contraints: false
// })

// Roles.belongsToMany(Actions, {
//   as: 'actions',
//   through: 'roles_has_actions',
//   foreignKey: 'role_id',
//   contraints: false
// })


module.exports = Roles
