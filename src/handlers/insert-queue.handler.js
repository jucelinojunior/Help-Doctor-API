const APPOINTMENT = require('../enums/pronoucer.js');
const PRONOUNCER = require('../enums/pronoucer.js');
const SEVERITY = require('../enums/severity.js');
const QUEUE = require('../enums/queue.js');

const Appointment = require('../models/appointment');
const User = require('../models/users');
const Pronouncer = require('../models/pronouncer');
const Patient = require('../models/patient');
const Queue = require('../models/queue');

const age = function (birthday) {
	var ageDifMs = Date.now() - birthday.getTime();
   	var ageDate = new Date(ageDifMs); // miliseconds from epoch
   	return Math.abs(ageDate.getUTCFullYear() - 1970);
}

module.exports = {
	method: 'POST',
	path: '/queue',
	handler: async (request, h) => {

		const appointment = await Appointment.findOne({
			where: {
				id: request.payload.id
			},
			include: [
		      {
		        model: User,
		        as: 'user',
		        required: true,
		        attributes: ['id','name']
		      },
		      {
		        model: Pronouncer,
		        as: 'pronouncer',
		        required: true,
		        attributes: ['id','type_pronouncer','hospital_id'],
		        include: [
			        {
			        	model: Patient,
			        	as: 'patient',
			        	required: true,
			        	attributes: ['id','birthday']
			        }
		        ]
		      }
      		]
  		});

		appointment.status = APPOINTMENT.QUEUE;

		const queue = new Queue();
		queue.hospital_id = appointment.pronouncer.hospital_id;
		queue.appointment_id = appointment.id;
		queue.status = QUEUE.IN_QUEUE;
		
		if(appointment.pronouncer.type_pronouncer == PRONOUNCER.APPOINTMENT) 
			queue.severity = SEVERITY.BLUE;
		else if (appointment.heart_attack || appointment.hypovolemic_shock || appointment.convulsion == QUEUE.CONVULSIONS_ATTACKS || appointment.skin_burn > 1)
			queue.severity = SEVERITY.RED;
		else if (appointment.heart_attack || appointment.hypovolemic_shock || appointment.convulsion == QUEUE.CONVULSION || appointment.skin_burn == 1 || appointment.apnea)
			queue.severity = SEVERITY.YELLOW;
		else if (appointment.diarrhea || appointment.is_pregnant || age(appointment.pronouncer.patient.birthday) > 60 || appointment.asthma || appointment.vomit)
			queue.severity = SEVERITY.GREEN;
		else
			queue.severity = SEVERITY.BLUE;
  		
  		return queue.save().then(() => {
  			return appointment.save().then(() => {
  				return queue;
  			}).catch((err) => {
  				return err;
  			});
  		}).catch(err => {return err;});
	}
}