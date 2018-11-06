const Address = require('../models/address')

const register = async (address) => {
  address.formatedaddress = `${address.address}, ${address.number} - ${address.neighborhood} ${address.state}`
  return Address.findOrCreate({ where: {
    formatedaddress: address.formatedaddress
  },
  defaults: address
  })
    .spread((address, created) => {
      return address.get({
        plain: true
      })
    })
}
/**
 * @desc Atualiza o endereço
 * @param {string|integer} id
 * @param {object} address
 */
const update = async (id, address) => {
  address.formatedaddress = `${address.address}, ${address.number} - ${address.neighborhood} ${address.state}`
  return Address.update(address, {
    where: {
      id: id
    }
  })
}

/**
 * @desc Procura um endereço por ID
 * @param {integer} id
 */
const findById  = async (id) => {
  return Address.findById(id)
}

module.exports = {
  register,
  update,
  findById
}
