const QUEUE = require('../enums/queue.js');
const client = require('../../config/dbConnect.js').connect();
module.exports = {
	method: 'GET',
	path: '/screening/{id}',
	handler: function(request, h) {
		
		return client.query('SELECT * FROM TB_QUEUE WHERE hospital_id = $1 AND status = $2 ORDER BY severity,createdAt ASC',[request.params.id,QUEUE.IN_QUEUE]).then((res) => {
			return res;
		}).catch((err) => {
			return err;	
		});
		
	}
}