
const Sequelize = require('sequelize')
const RolesHasActions = global.sequelize.define('roles_has_actions', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  action_id: {
    type: Sequelize.INTEGER
  },
  role_id: {
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
  tableName: 'roles_has_actions'
})

module.exports = RolesHasActions
