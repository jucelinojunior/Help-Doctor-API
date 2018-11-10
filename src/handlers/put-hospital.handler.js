const hospitalService = require('../services/hospital.service')
const addressService = require('../services/address.service')
const Boom = require('boom')
const Joi = require('joi')

const schema = Joi.object({
  name: Joi.string().min(3).optional(),
  addressId: Joi.number(),
  address: Joi.object({
    address: Joi.string(),
    neighborhood: Joi.string(),
    city: Joi.string().required(),
    state: Joi.string(),
    state: Joi.string(),
    zipcode: Joi.string(),
    number: Joi.number(),
    complement: Joi.string().allow('').optional()
  })
})
module.exports = {
  method: 'PUT',
  path: '/hospital/{id}',
  handler: async (request, reply) => {
    if (!request.params.id) throw Boom.badRequest('Informe o id do hospital para a edição')
    // if (!request.payload.address && !request.payload.addressId) {
    //   throw Boom.badRequest(JSON.stringify({data: 'falta endereço'}))
    // }

    //  Recupera o hospital
    let hospital = await hospitalService.findById(request.params.id)
    if (!hospital) throw Boom.notFound(`O hospital com o ID ${request.params.id} não foi encontrado`)
    //  Atualiza o hospital de acordo com as info passada do payload
    hospital = {
      ...hospital.dataValues,
      ...request.payload
    }

    //  Se passar um objeto de endereço, então eu recupero o endereço e atualizo o mesmo do hospital
    if (request.payload.address && typeof request.payload.address === 'object') {
      //  Recupera o endereço do hospital
      let addressHospital = await addressService.findById(hospital.addressHospital.id)

      //  Atualiza o endereço do hospital de acordo com payload
      const {address} = request.payload
      addressHospital = {
        ...addressHospital.dataValues,
        ...address
      }
      //  Atualiza
      await addressService.update(addressHospital.id, addressHospital)
    } else if (request.payload.addressId) { //  Se passar um ID de endereço, eu atrelo ao hospital
      hospital.addressId = request.payload.addressId
    }
    await hospitalService.update(hospital.id, hospital)

    //  Recupera o hospital
    hospital = await hospitalService.findById(request.params.id)
    return hospital.dataValues

    //  Atualiza o hospital
    // if (typeof request.payload.address === 'object') {
    //   //
    //   //  Recupera o endereço
    //   // addressService.
    //   return addressService.update(request.payload.address.id, request.payload.address.data).then((h) => {
    //     request.payload.address = h.id
    //     return hospitalService.update(request.params.id, request.payload)
    //   })
    // }
    // return hospitalService.update(request.params.id, request.payload)
  },
  config: {
    validate: {
      payload: schema
    },
    auth: {
      strategy: 'helpdoctor',
      scope: ['hospital.update']
    },
    cors: {
      origin: ['*']
    }
  }
}
