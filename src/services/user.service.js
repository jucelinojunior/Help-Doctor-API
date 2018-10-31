const User = require('../models/users')
const Role = require('../models/roles')
const Action = require('../models/actions')
const Address = require('../models/address')
const Hospital = require('../models/hospital')
const FailedToAuthenticateError = require('../errors/FailedToAuthenticateError')
const add = async (user) => {
  return User.build(user).save()
}
const getUserByEmail = async (email) => {
  const users = await User.findAll({
    where: {
      email: email
    },
    include: [
      {
        model: Role,
        as: 'roles',
        required: false,
        attributes: ['id', 'name'],
        through: { attributes: [ /* 'user_id' */ ] },
        include: {
          as: 'actions',
          model: Action,
          attributes: ['id', 'name'],
          through: { attributes: [ /* 'user_id' */ ] }
        }
      },
      {
        model: Address,
        as: 'address',
        required: false,
        attributes: ['id', 'address']
      }
    ]
  })
  if (users.length === 0) throw new FailedToAuthenticateError()
  const user = users.map(it => {
    return it.dataValues
  })[0]
  return user
}
const getAll = async () => {
  return User.findAll({
    include: [
      {
        model: Role,
        as: 'roles',
        required: false,
        attributes: ['id', 'name'],
        through: { attributes: [ /* 'user_id' */ ] },
        include: {
          model: Action,
          as: 'actions',
          required: false,
          attributes: ['id', 'name'],
          through: { attributes: [ ] }
        }
      },
      {
        model: Address,
        as: 'address',
        required: false,
        attributes: ['id', 'address', 'formatedaddress']
      },
      {
        model: Hospital,
        as: 'hospitals',
        through: { attributes: [ /* 'user_id' */ ] },
        required: false,
        attributes: [
          'name',
          'address'
        ]
      }
    ]
  }).map(it => {
    return it
  })
}

module.exports = {
  add,
  getAll,
  getUserByEmail
}
