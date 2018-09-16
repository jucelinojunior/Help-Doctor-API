const QUEUE = require('../enums/queue.js');
const client = require('../../config/dbConnect.js').connect();
module.exports = {
	method: 'PUT',
	path: '/screening/{id}',
	handler: function(request, h) {
		
		return client.query('UPDATE TB_QUEUE SET status = $1,updatedAt = $2	 WHERE id = $3 RETURNING *',[QUEUE.DONE_QUEUE,new Date(),request.params.id]).then((res) => {
			return res;
		}).catch((err) => {
			return err;	
		});
		
	}
}