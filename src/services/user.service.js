const User = require('../models/users')
const Role = require('../models/roles')
const Action = require('../models/actions')
const Address = require('../models/address')
const add = async (user) => {
  return User
  
}
const getUserByDocument = async (personalDocument) => {
  const users = await User.findAll({
    where: {
      personal_document: personalDocument
    },
    include: [
      {
        model: Role,
        as: 'roles',
        required: false,
        attributes: ['id', 'name'],
        through: { attributes: [ /* 'user_id' */ ] }
      },
      {
        model: Address,
        as: 'address',
        required: false,
        attributes: ['id', 'address']
        // through: { attributes: [] }
      }
      // {
      //   model: Action,
      //   as: 'actions',
      //   required: false,
      //   attributes: ['id', 'name']
      // }
    ]
  })
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
        attributes: ['id', 'address','formatedaddress']
      }
    ]
  }).map(it => {
    console.log(it.roles)
    return it
  })
}

module.exports = {
  add,
  getAll,
  getUserByDocument
}
