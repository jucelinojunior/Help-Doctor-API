const User = require('../models/users')
const Hospital = require('../models/hospital')
const Address = require('../models/address')
const Users = require('../models/hospital_has_user')
const Categories = require('../models/medical_category')

const DEFAULT_INCLUDE = [
  {
    model: Address,
    as: 'addressHospital',
    required: false,
    attributes: ['id', 'formatedaddress', 'address', 'neighborhood', 'state', 'zipcode', 'number', 'complement', 'createdAt', 'updatedAt']
  }
]

const getAll = async (names = '', address = '') => {
  const obj = {
    include: DEFAULT_INCLUDE
  }

  if (names !== '') {
    obj.where = global.sequelize.where(global.sequelize.col('name'), {
      ilike: `%${names}%`
    })
  }

  if (address !== '') {
    obj.include[0].required = true
    obj.include[0].where = global.sequelize.where(global.sequelize.col('formatedaddress'), {
      ilike: `%${address}%`
    })
  }

  return Hospital.findAll(obj)
}

const register = async (h) => {
  const hospital = new Hospital()
  return hospital.update(h).then(() => {
    return hospital
  })
}

const destroy = async (id) => {
  return Hospital.destroy({
    where: {id: id}
  })
}

const users = async (id, hospital) => {
  var user = new Users()
  return user.update({user_id: id, hospital_id: hospital}).then(() => {
    return user
  })
}
const update = async (id, h) => {
  const hospital = await Hospital.findOne({
    where: {id: id}
  })

  return hospital.update(h).then(() => {
    return hospital
  })
}

const getAllCategories = async () => {
  return Categories.findAll({
  })
}

const registerCategories = async (name) => {
  const cat = new Categories()
  cat.name = name
  return cat.save().then(() => {
    return cat
  }).catch(err => {
    return {errors: true, data: 'Não possivel cadastrar', err: err}
  })
}

module.exports = {
  getAll,
  register,
  update,
  destroy,
  users,
  getAllCategories,
  registerCategories
}
