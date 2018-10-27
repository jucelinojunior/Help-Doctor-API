const User = require('../models/users')
const Hospital = require('../models/hospital')
const Address = require('../models/address')

const getAll = async (roles = []) => {
  return await Hospital.findAll({
  	include: [
 		{
 			model: Address,
        	as: 'address_info',
        	required: false,
        	attributes: ['id','formatedaddress']
 		}
  	]
  });
}

module.exports = {
  getAll
}
