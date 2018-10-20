const QUEUE = require('../enums/queue.js');
const client = require('../pgConnect.js').connect();

module.exports = {
	method: 'GET',
	path: '/queue/hospital/{id}',
	handler: function(request, h) {
		client.connect();
		return client.query(`
			SELECT PATIENT.*,QUEUE.severity,QUEUE.appointment_id,QUEUE."createdAt" as start,QUEUE.id as queue_id,
						CASE 
							WHEN QUEUE."createdAt" > (now() AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '120 minutes') AND QUEUE.severity = 1 THEN 1
							WHEN QUEUE."createdAt" > (now() AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '60 minutes') AND QUEUE.severity = 2 THEN 1
							WHEN QUEUE."createdAt" > (now() AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '30 minutes') AND QUEUE.severity = 3 THEN 1
							WHEN QUEUE."createdAt" > (now() AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '2 minutes') AND QUEUE.severity = 4 THEN 1
							ELSE 0
						END as needNow
    					FROM QUEUE 
						INNER JOIN APPOINTMENT ON QUEUE.appointment_id = APPOINTMENT.id 
						INNER JOIN PRONOUNCER ON APPOINTMENT.pronouncer_id = PRONOUNCER.id
						INNER JOIN PATIENT ON PRONOUNCER.patient_id = PATIENT.id
			WHERE QUEUE.hospital_id = $1 and QUEUE.status = $2
			ORDER BY needNow,severity,start ASC;
		`,[request.params.id,QUEUE.IN_QUEUE]).then((res) => {
			return res.rows;
		}).catch((err) => {
			return err;	
		});
	}
}