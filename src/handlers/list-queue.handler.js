const queue = require('../services/queue.service');

module.exports = {
	method: 'GET',
	path: '/queue/hospital/{id}',
	handler: function(request, h) {
		return queue.viewQueue(request.params.id);
	}
}