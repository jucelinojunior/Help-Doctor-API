const Address = require('../models/address');

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

const update = async (id,h) => {
  const hospital = await Address.findOne({
    where: {id: id}
  })
  h.formatedaddress = `${h.address}, ${h.number} - ${h.neighborhood} ${h.state}`
  return hospital.update(h)
}

module.exports = {
  register,
  update
}
