const userService = require('../services/hospital.service');
const addressService = require('../services/address.service');

module.exports = {
  method: 'POST',
  path: '/hospital',
  handler: async (request, reply) => {

    if(!request.payload.address) {
      return {data: "falta endereço"};
    }

    if (typeof request.payload.address == "object") {
      return addressService.register(request.payload.address).then((h) => {
          request.payload.address = h.id;
          return userService.register(request.payload);
      });
    }
    return userService.register(request.payload);
  } 
}