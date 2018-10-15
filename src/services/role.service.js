const User = require('../models/users')
const Role = require('../models/roles')
const Actions = require('../models/actions')
const Address = require('../models/address')

const getActionsByRoles = async (roles = []) => {
  roles = !Array.isArray(roles) ? [roles] : roles

  return Actions.findAll({
    include: [
      {
        model: Actions,
        as: 'actions',
        required: false,
        attributes: ['id', 'name']
      }
    ]
  })
}

module.exports = {
  getActionsByRoles
}
