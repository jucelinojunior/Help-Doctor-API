const User = require('../models/users')
const Role = require('../models/roles')
const Action = require('../models/actions')
const Address = require('../models/address')
const Hospital = require('../models/hospital')
const FailedToAuthenticateError = require('../errors/FailedToAuthenticateError')
const UserHasRoles = require('../models/users_has_roles')

const FIELDS = [
  'id',
  'name',
  'email',
  'password',
  'birthday',
  'genre',
  'medical_document',
  'personal_document',
  'responsable_hospital'
]
const DEFAULT_INCLUDES = [
  {
    model: Role,
    as: 'roles',
    required: false,
    attributes: ['id', 'name', 'label'],
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
    attributes: [
      'id',
      'address',
      'neighborhood',
      'number',
      'complement',
      'city',
      'zipcode',
      'state',
      'formatedaddress'
    ]
  },
  {
    model: Hospital,
    as: 'hospitals',
    through: { attributes: [ /* 'user_id' */ ] },
    required: false,
    attributes: [
      'id',
      'name'
    ]
  }
]

/**
 * @desc Adiciona um usuário
 * @param {object} user
 */
const add = async (user) => {
  return User.build(user).save()
}

/**
 * @desc Procura um usuario por ID
 */
const find = async (id, showDeleteds = false) => {
  return User.findOne({
    attributes: FIELDS,
    where: {
      id: id
    },
    include: DEFAULT_INCLUDES,
    paranoid: !showDeleteds
  })
}

/**
 * @desc procura um usuário que possua um email igual ao informado
 * @param {string} email
 */
const getUserByEmail = async (email) => {
  const users = await User.findAll({
    where: {
      email: email
    },
    include: DEFAULT_INCLUDES
  })
  if (users.length === 0) throw new FailedToAuthenticateError()
  const user = users.map(it => {
    return it.dataValues
  })[0]
  return user
}

/**
 * @desc Procura todos os usuários
 */
const getAll = async () => {
  return User.findAll({
    attributes: FIELDS,
    include: DEFAULT_INCLUDES
  }).map(it => {
    return it
  })
}

/**
 * @desc Valida o CPF passado
 * @param {string} CPF
 */
const validateCPF = (strCPF) => {
  if (strCPF === '00000000000') return false

  let Soma
  let Resto
  Soma = 0
  if (/^(.)\1+$/.test(strCPF)) return false // Valida como falso CPFs com números todos iguais

  for (let i = 1; i <= 9; i++) Soma = Soma + parseInt(strCPF.substring(i - 1, i), 10) * (11 - i)
  Resto = (Soma * 10) % 11

  if ((Resto === 10) || (Resto === 11)) Resto = 0
  if (Resto !== parseInt(strCPF.substring(9, 10), 10)) return false

  Soma = 0
  for (let i = 1; i <= 10; i++) Soma = Soma + parseInt(strCPF.substring(i - 1, i), 10) * (12 - i)
  /* istanbul ignore next */
  Resto = (Soma * 10) % 11

  /* istanbul ignore next */
  if ((Resto === 10) || (Resto === 11)) Resto = 0
  if (Resto !== parseInt(strCPF.substring(10, 11), 10)) return false
  return true
}

const update = async (id, user) => {
  return User.update(user, {
    where: {
      id: id
    },
    paranoid: false
  })
}

/**
 * @param {{string|integer}} id
 * @desc Deleta um usuario da base
 */
const destroy = async (id) => {
  return User.destroy({
    where: {
      id: id
    }
  })
}

const addRole = async (userId, roleId) => {
  return UserHasRoles.build({
    user_id: userId,
    role_id: roleId
  }).save()
}

module.exports = {
  add,
  getAll,
  getUserByEmail,
  validateCPF,
  find,
  update,
  destroy,
  addRole,
  DEFAULT_INCLUDES,
  FIELDS
}
