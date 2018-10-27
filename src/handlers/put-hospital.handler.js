const userService = require('../services/hospital.service');
const addressService = require('../services/address.service');

module.exports = {
  method: 'PUT',
  path: '/hospital/{id}',
  handler: async (request, reply) => {

    if(!request.payload.address) {
      return {data: "falta endereço"};
    }

    if (typeof request.payload.address == "object") {
      return addressService.update(request.payload.address.id,request.payload.address.data).then((h) => {
          request.payload.address = h.id;
          return userService.update(request.params.id,request.payload);
      });
    }
    return userService.update(request.params.id,request.payload);
  } 
}