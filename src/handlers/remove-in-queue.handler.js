const Queue = require('../models/queue');
const Appointment = require('../models/appointment');
const QUEUE = require('../enums/queue.js');
const APPOINTMENT = require('../enums/appointment.js');

module.exports = {
	method: 'DELETE',
	path: '/queue/remove/{id}',
	handler: async (request, h) => {

		const queue = await Queue.findOne({
			where: { id: request.params.id }
		});

		const appointment = await Appointment.findOne({
			where: { id: queue.appointment_id }
		});

		queue.status = QUEUE.DONE_QUEUE;
		appointment.status = APPOINTMENT.DONE;

		return queue.save().then(()=>{
			return appointment.save().then(()=>{
				return appointment;
			}).catch(err => {
				return "erro ao salvar o status da consulta"
			});
		}).catch(err => {
			return "erro ao salvar o status da fila"
		});
	}
}