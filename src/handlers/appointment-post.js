const client = require('../../config/dbConnect.js').connect();

module.exports = {
	method: 'POST',
	path: '/appointment',
	handler: function(request, h) {
			
		return request.post;

		if(request.query.table) {
			return client.query('SELECT * FROM '+request.query.table).then((res) => {
				return res.rows;
			}).catch((err) => {
				return err;	
			});
		} else
			return 'test';
	}
}