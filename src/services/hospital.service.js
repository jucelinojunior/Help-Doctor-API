const User = require('../models/users')
const Hospital = require('../models/hospital')
const Address = require('../models/address')
const HospitalHasUsers = require('../models/hospital_has_user')
const Categories = require('../models/medical_category')
const Op = global.sequelize.Op

const ATTRIBUTES = [
  'id',
  'name'
]

const mapHospitalHasUser = (hospital) => {
  return hospital.hospital
}
const removeNullObject = (h) => {
  return !!h
}
const DEFAULT_INCLUDE = [
  {
    model: Address,
    as: 'addressHospital',
    required: false,
    attributes: ['id', 'formatedaddress', 'address', 'neighborhood', 'city', 'state', 'zipcode', 'number', 'complement']
  },
  {
    model: User,
    as: 'users',
    required: false,
    attributes: [
      'id',
      'name',
      'email',
      'addressId',
      'birthday',
      'medical_document',
      'personal_document',
      'genre',
      'createdAt',
      'updatedAt'
    ],
    through: { attributes: [ /* 'user_id' */ ] },
    include: [
      {
        model: Address,
        as: 'address',
        required: false,
        attributes: ['id', 'formatedaddress', 'address', 'neighborhood', 'state', 'zipcode', 'number', 'complement']
      }
    ]
  }
]

const hospitalsByUser = async (userId, names = '', address = '') => {
  const includeObject = [
    {
      model: Hospital,
      as: 'hospital',
      required: false,
      attributes: ['id', 'name'],
      include: [
        {
          model: Address,
          as: 'addressHospital',
          required: false,
          attributes: [
            'id',
            'formatedaddress',
            'address',
            'neighborhood',
            'city',
            'state',
            'zipcode',
            'number',
            'complement'
          ]
        }
      ]
    }
  ]
  if (address !== '') {
    includeObject[0].include[0].required = true
    includeObject[0].include[0].where = {
      [Op.and]: {
        name: global.sequelize.where(global.sequelize.col('formatedaddress'), {
          ilike: `%${address}%`
        })
      }
    }
  }

  if (names !== '') {
    includeObject[0].where = {
      [Op.and]: {
        name: global.sequelize.where(global.sequelize.col('name'), {
          ilike: `%${names}%`
        })
      }
    }
  }
  const hospitals = await HospitalHasUsers.findAll({
    where: {
      user_id: userId
    },
    include: includeObject,
    attributes: ATTRIBUTES
  })

  return hospitals.map(mapHospitalHasUser).filter(removeNullObject)
}

const findAllWithMultiplusId = async (ids) => {
  if (!Array.isArray(ids)) ids = [ids]
  return Hospital.find({
    where: {
      id: {
        [Op.in]: ids
      }
    },
    include: DEFAULT_INCLUDE,
    attributes: ATTRIBUTES
  })
}

const findById = async (id) => {
  const DEFAULT_INCLUDE = [
    {
      model: Address,
      as: 'addressHospital',
      required: false,
      attributes: ['id', 'formatedaddress', 'address', 'neighborhood', 'city', 'state', 'zipcode', 'number', 'complement']
    }
  ]

  return Hospital.findById(id, {
    include: DEFAULT_INCLUDE,
    attributes: ATTRIBUTES
  })
}

const getAll = async (names = '', address = '') => {
  const DEFAULT_INCLUDE = [
    {
      model: Address,
      as: 'addressHospital',
      required: false,
      attributes: ['id', 'formatedaddress', 'address', 'neighborhood', 'city', 'state', 'zipcode', 'number', 'complement']
    }
  ]

  var obj = {
    include: DEFAULT_INCLUDE,
    attributes: ATTRIBUTES
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

const addUserHospital = async (userId, hospitalId) => {
  var user = new HospitalHasUsers()
  return user.update({user_id: userId, hospital_id: hospitalId}).then(() => {
    return user
  })
}
const deleteAllUsersInHospital = async (userId) => {
  console.log('users to delete', userId)
  const hospitalUsers = await HospitalHasUsers.findAll({
    where: {
      user_id: userId
    }
  })
  if (hospitalUsers.length > 0) {
    let countRows = 0
    for (let it of hospitalUsers) {
      it.destroy()
      countRows += 1
    }
    return [
      countRows
    ]
  }
  return [
    0
  ]
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
    return {errors: true, data: 'N??o possivel cadastrar', err: err}
  })
}

module.exports = {
  getAll,
  register,
  update,
  destroy,
  addUserHospital,
  getAllCategories,
  registerCategories,
  findById,
  findAllWithMultiplusId,
  hospitalsByUser,
  deleteAllUsersInHospital
}
