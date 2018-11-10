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

module.exports = {
  getAll
}
