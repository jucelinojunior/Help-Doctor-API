const { Client } = require('pg');
const client = new Client({
	  user: 'postgres',
	  host: 'localhost',
	  database: 'tcc',
	  password: '',
	  port: 5432,
});
client.connect();

module.exports.connect = function () {
	return client;
}