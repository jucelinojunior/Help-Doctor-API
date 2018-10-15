const User = require('../models/users')
const Role = require('../models/roles')
const Address = require('../models/address')
const add = async (user) => {
  return User.build(user).save()
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
    ]
  })
  console.log(users[0])
  return users.map(it => {
    return it.dataValues
  })[0]
}
const getAll = async () => {
  return User.findAll({
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
    ]
  })
}

module.exports = {
  add,
  getAll,
  getUserByDocument
}
