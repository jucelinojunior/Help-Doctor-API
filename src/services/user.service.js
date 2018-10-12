const User = require('../models/users')
const Role = require('../models/roles')
const Address = require('../models/address')
const add = async (user) => {
  return User.build(user).save()
}
const getAll = async () => {
  return User.findAll({
    include: [{
      model: Role,
      as: 'roles',
      required: false,
      attributes: ['id', 'name'],
      through: { attributes: ['user_id'] }
    }]
  })
}

module.exports = {
  add,
  getAll
}
