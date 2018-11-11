const Patient = require('../models/patient')
const Address = require('../models/address')


const DEFAULT_INCLUDE = [
  {
    model: Address,
    as: 'address',
    required: false,
    attributes: ['id', 'formatedaddress', 'address', 'neighborhood','city', 'state', 'zipcode', 'number', 'complement', 'createdAt', 'updatedAt']
  }
]

const getAll = async () => {
  return Patient.findAll({
    include: DEFAULT_INCLUDE
  })
}

const findById = async (id, showDeleteds = false) => {
  return Patient.findById(id, {
    include: DEFAULT_INCLUDE,
    paranoid: !showDeleteds
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
