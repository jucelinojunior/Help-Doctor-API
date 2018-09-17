const client = require('../../config/dbConnect.js').connect();
const PRONOUNCER = require('../enums/pronoucer.js');
const SEVERITY = require('../enums/severity.js');
const QUEUE = require('../enums/queue.js');

const age = function (birthday) {
	var ageDifMs = Date.now() - birthday.getTime();
   	var ageDate = new Date(ageDifMs); // miliseconds from epoch
   	return Math.abs(ageDate.getUTCFullYear() - 1970);
}

module.exports = {
	method: 'POST',
	path: '/screening',
	handler: function(request, h) {

		return client.query('SELECT TB_APPOINTMENT.*,TB_PATIENT.*,TB_TYPE_PRONOUNCER.*,TB_PRONOUNCER.hospital_id,TB_TYPE_PRONOUNCER.id AS type_pronouncer_id,TB_PATIENT.id AS user_id  FROM TB_APPOINTMENT INNER JOIN TB_PATIENT ON TB_PATIENT.id = TB_APPOINTMENT.user_id INNER JOIN TB_PRONOUNCER ON TB_APPOINTMENT.pronouncer_id = TB_PRONOUNCER.id INNER JOIN TB_TYPE_PRONOUNCER ON TB_PRONOUNCER.type_pronouncer = TB_TYPE_PRONOUNCER.id WHERE TB_APPOINTMENT.id = $1 LIMIT 1',[request.payload.id]).then((res) => {

			const appointment = res.rows[0];
			var vals = [
				appointment.hospital_id,
				appointment.user_id,
				QUEUE.IN_QUEUE
			];

			if(appointment.type_pronouncer_id == PRONOUNCER.APPOINTMENT) 
				vals.push(SEVERITY.BLUE);
			else if (appointment.heart_attack || appointment.hypovolemic_shock || appointment.convulsion == QUEUE.CONVULSIONS_ATTACKS || appointment.skin_burn > 1)
				vals.push(SEVERITY.RED);
			else if (appointment.heart_attack || appointment.hypovolemic_shock || appointment.convulsion == QUEUE.CONVULSION || appointment.skin_burn == 1 || appointment.apnea)
				vals.push(SEVERITY.YELLOW);
			else if (appointment.diarrhea || appointment.is_pregnant || age(appointment.birthday) > 60 || appointment.asthma || appointment.vomit)
				vals.push(SEVERITY.GREEN);
			else
				vals.push(SEVERITY.BLUE);

			return client.query('INSERT INTO TB_QUEUE (hospital_id,tb_user,status,severity) VALUES ($1,$2,$3,$4) RETURNING *',vals).then((res) => {
				return res;
			});

		}).catch((err) => {
			return err;	
		});
	}
}