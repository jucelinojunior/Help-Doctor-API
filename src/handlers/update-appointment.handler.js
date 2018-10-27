const queue = require('../services/queue.service')
const APPOINTMENT = require('../enums/pronoucer.js');
const Appointment = require('../models/appointment');

module.exports = {
	method: 'PUT',
	path: '/appointment/{id}',
	handler: async (request, h) => {
		
		if(request.query.remove) {
			queue.removeInQueue(request.query.remove);
		}
		
		if(request.query.queue) {
			queue.insertQueue(request.params.id);
		}
		
		const appointment = await Appointment.findOne({
			where: {
				id: request.params.id
			}
		});
		
		return appointment.update(request.payload).then(()=>{
			return appointment;
		});
	}
}