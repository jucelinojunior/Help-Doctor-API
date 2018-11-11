const Patient = require('../models/patient')
const Address = require('../models/address')

const ATTRIBUTES = [
  'id',
  'name',
  'personal_document',
  'email',
  'birthday',
  'genre',
  'phoneNumber'
]
const DEFAULT_INCLUDE = [
  {
    model: Address,
    as: 'address',
    required: false,
    attributes: ['id', 'formatedaddress', 'address', 'neighborhood', 'city', 'state', 'zipcode', 'number', 'complement']
  }
]

const getAll = async () => {
  return Patient.findAll({
    include: DEFAULT_INCLUDE,
    attributes: ATTRIBUTES
  })
}

const findById = async (id, showDeleteds = false) => {
  return Patient.findById(id, {
    include: DEFAULT_INCLUDE,
    paranoid: !showDeleteds,
    attributes: ATTRIBUTES
  })
}

const update = async (id, patient) => {
  return Patient.update(patient, {
    where: {
      id: id
    },
    paranoid: false
  })
}

const add = async (patient) => {
  return Patient.build(patient).save()
}

const destroy = async (id) => {
  return Patient.destroy({
    where: {
      id: id
    }
  })
}

module.exports = {
  getAll,
  findById,
  update,
  add,
  destroy
}
