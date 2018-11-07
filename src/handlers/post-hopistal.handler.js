const hospitalService = require('../services/hospital.service')
const addressService = require('../services/address.service')
const Boom = require('boom')
const Joi = require('joi')

const schema = Joi.object({
  name: Joi.string().min(3).required(),
  address: Joi.object({
    address: Joi.string().required(),
    neighborhood: Joi.string().required(),
    state: Joi.string().required(),
    zipcode: Joi.string().required(),
    number: Joi.number().required(),
    complement: Joi.string().allow('').optional()
  })
})

module.exports = {
  method: 'POST',
  path: '/hospital',
  handler: async (request, reply) => {
    if (!request.payload.address && !request.payload.addressId) {
      throw Boom.badRequest(JSON.stringify({data: 'falta endereço'}))
    }
    const hospital = {
      ...request.payload
    }
    if (typeof request.payload.address === 'object') {
      return addressService.register(request.payload.address).then((address) => {
        hospital.addressId = address.id
        return hospitalService.register(hospital)
      })
    }
    return hospitalService.register(request.payload)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['hospital.create']
    },
    cors: {
      origin: ['*']
    },
    validate: {
      payload: schema
    }
  }
}
