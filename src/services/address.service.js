const Address = require('../models/address');

const register = async (h) => {
  const hospital = new Address();
  h.formatedaddress = h.address + ", " + h.number + " - " + h.neighborhood + " " + h.state;
  return hospital.update(h).then(()=>{
      return hospital;
    });
}

const update = async (id,h) => {
  const hospital = await Address.findOne({
  	where: {id: id}
  })
  h.formatedaddress = h.address + ", " + h.number + " - " + h.neighborhood + " " + h.state;
  return hospital.update(h).then(()=>{
      return hospital;
    });
}

module.exports = {
	register,
	update
}