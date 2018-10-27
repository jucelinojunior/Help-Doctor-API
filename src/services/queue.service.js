const APPOINTMENT = require('../enums/pronoucer.js');
const PRONOUNCER = require('../enums/pronoucer.js');
const SEVERITY = require('../enums/severity.js');
const QUEUE = require('../enums/queue.js');

const Appointment = require('../models/appointment');
const User = require('../models/users');
const hasPain = require('../models/has_pain');
const Pain = require('../models/pain');
const hasTrauma = require('../models/has_trauma');
const Trauma = require('../models/trauma');
const Pronouncer = require('../models/pronouncer');
const Patient = require('../models/patient');
const Queue = require('../models/queue');

const clientM = require('../pgConnect.js');

const age = function (birthday) {
	var ageDifMs = Date.now() - birthday.getTime();
   	var ageDate = new Date(ageDifMs); // miliseconds from epoch
   	return Math.abs(ageDate.getUTCFullYear() - 1970);
}

const verifyPain = function(appointment,severity) {
	pains = appointment.has_pain;
	for(var i = 0; i < pains.length;i++) {
		if(pains[i].pain[0].severity == severity) {
			return true;
		}
	}
	return false;
}

const verifyTrauma = function(appointment,severity) {
	traumas = appointment.has_trauma;
	for(var i = 0; i < traumas.length;i++) {
		if(traumas[i].trauma[0].severity == severity) {
			return true;
		}
	}
	return false;
}

const insertQueue = async (idAppointment) => {

	const appointment = await Appointment.findOne({
			where: {
				id: idAppointment
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
		      },
		      {
		        model: hasPain,
		        as: 'has_pain',
		        required: false,
		        attributes: ['pain_id'],
		        include: [
			        {
			        	model: Pain,
			        	as: 'pain',
			        	required: false,
			        	attributes: ['severity']
			        }
		        ]
		      },
		      {
		        model: hasTrauma,
		        as: 'has_trauma',
		        required: false,
		        attributes: ['trauma_id'],
		        include: [
			        {
			        	model: Trauma,
			        	as: 'trauma',
			        	required: false,
			        	attributes: ['severity']
			        }
		        ]
		      }
      		]
  		});
		
		appointment.status = APPOINTMENT.QUEUE;


		const queue = new Queue();
		queue.hospital_id = appointment.pronouncer[0].hospital_id;
		queue.appointment_id = appointment.id;
		queue.status = QUEUE.IN_QUEUE;
		
		if(appointment.pronouncer[0].type_pronouncer == PRONOUNCER.APPOINTMENT) 
			queue.severity = SEVERITY.BLUE;
		else if (verifyTrauma(appointment,SEVERITY.RED) || verifyPain(appointment,SEVERITY.RED) || appointment.heart_attack || appointment.hypovolemic_shock || appointment.convulsion == QUEUE.CONVULSIONS_ATTACKS || appointment.skin_burn > 1)
			queue.severity = SEVERITY.RED;
		else if (verifyTrauma(appointment,SEVERITY.YELLOW) || verifyPain(appointment,SEVERITY.YELLOW) || appointment.heart_attack || appointment.hypovolemic_shock || appointment.convulsion == QUEUE.CONVULSION || appointment.skin_burn == 1 || appointment.apnea)
			queue.severity = SEVERITY.YELLOW;
		else if (verifyTrauma(appointment,SEVERITY.GREEN) || verifyPain(appointment,SEVERITY.GREEN) || appointment.diarrhea || appointment.is_pregnant || age(appointment.pronouncer[0].patient[0].birthday) > 60 || appointment.asthma || appointment.vomit)
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

const removeInQueue = async (id) => {
	const queue = await Queue.findOne({
			where: { id: id }
		});

		queue.status = QUEUE.DONE_QUEUE;
		
		return queue.save().then(()=>{
			return queue;
		}).catch(err => {
			return "erro ao salvar o status da fila";
		});
}

const viewQueue = function (hospitalId) {
	var client = clientM.connect();
	client.connect();
	return client.query(`
		SELECT PATIENT.*,QUEUE.severity,QUEUE.appointment_id,QUEUE."createdAt" as start,QUEUE.id as queue_id,
		CASE 
		WHEN QUEUE."createdAt" > (now() AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '120 minutes') AND QUEUE.severity = 1 THEN 4
		WHEN QUEUE."createdAt" > (now() AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '60 minutes') AND QUEUE.severity = 2 THEN 3
		WHEN QUEUE."createdAt" > (now() AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '30 minutes') AND QUEUE.severity = 3 THEN 2
		WHEN QUEUE."createdAt" > (now() AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '2 minutes') AND QUEUE.severity = 4 THEN 1
		ELSE 0
		END as needNow
		FROM QUEUE 
		INNER JOIN APPOINTMENT ON QUEUE.appointment_id = APPOINTMENT.id 
		INNER JOIN PRONOUNCER ON APPOINTMENT.pronouncer_id = PRONOUNCER.id
		INNER JOIN PATIENT ON PRONOUNCER.patient_id = PATIENT.id
		WHERE QUEUE.hospital_id = $1 and QUEUE.status = $2
		ORDER BY needNow,start ASC;

		`,[hospitalId,QUEUE.IN_QUEUE]).then((res) => {
			client.end();
			return res.rows;
	}).catch((err) => {
		client.end();
		return err;	
	});
}

module.exports = {
	insertQueue,
	removeInQueue,
	viewQueue
}
