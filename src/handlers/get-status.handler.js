function handler (request, h) {
  return { code: 200, status: 'Up and Running' }
}

function table (request,h) {
	
	/*
	CREATE TABLE TB_ROLE (
		id SERIAL PRIMARY KEY,
		name  VARCHAR(255) NOT NULL,
		createdAt TIMESTAMP WITH TIME ZONE NULL DEFAULT now(),
		updatedAt TIMESTAMP WITH TIME ZONE NULL DEFAULT now()
	);
	
	CREATE TABLE TB_USER (
		id SERIAL PRIMARY  KEY,
		name VARCHAR(255) NOT NULL,
		email VARCHAR(255) UNIQUE NOT NULL,
		password VARCHAR(255) NOT NULL,
		birthday DATE NOT NULL,
		role_id INT NOT NULL,
		genre CHAR(1),
		medical_document VARCHAR(100) UNIQUE NULL, 
		personal_document VARCHAR(100) UNIQUE NOT NULL,
		createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		updatedAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
		foreign key (role_id) references TB_ROLE(id)
	);
	
	CREATE TABLE TB_HOSPITAL (
		id SERIAL PRIMARY KEY,
		name VARCHAR(255) NOT NULL,
		address VARCHAR(255) NOT NULL,
		numbberAddress VARCHAR(100) NOT NULL,
		complement VARCHAR(100) NULL,
		createdAt TIMESTAMP WITH TIME ZONE NULL DEFAULT NOW(),
		updatedAt TIMESTAMP WITH TIME ZONE NULL DEFAULT NOW()
	);
	
	CREATE TABLE TB_PATIENT (
		id SERIAL PRIMARY KEY,
		name VARCHAR(200) NOT NULL,
		personal_document VARCHAR(100) NOT NULL,
		address VARCHAR(255) NOT NULL,
		addressNumber VARCHAR(100) NOT NULL,
		complement VARCHAR(100) NOT NULL,
		zipcode VARCHAR(50) NOT NULL,
		email VARCHAR(255) UNIQUE NOT NULL,
		birthday DATE NOT NULL,
		genre CHAR(1),	
		createdAt TIMESTAMP WITH TIME ZONE NULL DEFAULT NOW(),
		updatedAt TIMESTAMP WITH TIME ZONE NULL DEFAULT NOW(),
		phoneNumber VARCHAR(100) NOT NULL
	);
	#ALTER DATABASE databasename SET DATESTYLE TO ISO, YMD; caso de erro
	DROP TABLE TB_PATIENT,TB_HOSPITAL,TB_USER,TB_ROLE
	*/

	const xlsxj = require("xlsx-to-json");
	const sheets = ['TB_ROLE','TB_USER','TB_HOSPITAL','TB_PATIENT'];
	const { Client } = require('pg');
	const client = new Client({
	  user: 'postgres',
	  host: 'localhost',
	  database: 'postgres',
	  password: '',
	  port: 5432,
	});
	client.connect();
	const getJSON = function(sheet) {
		xlsxj({
    	input: "./tables/tcc-data.xlsx", 
    	output: null,
    	sheet: sheet,
  		}, function(err, result) {
    		if(err) {
      			console.error(err);
    		}else {
      			var keys = Object.keys(result[0]);
      			for(var i = 0; i < result.length; i++) {

      				var vals = [];
      				var values = [];
      				for(var z = 0; z < keys.length; z++ ) {
      					vals[z] = "$"+(z+1);
      					values[z] = result[i][keys[z]];
      				}	
      				const text = 'INSERT INTO '+sheet+'('+keys.join(",")+') VALUES('+vals.join(",")+')';
					client.query(text, values, (err, res) => {console.log(err)});
      			}
    		}
		});
	}

	for(var i = 0; i < sheets.length; i++) {	
		getJSON(sheets[i]);
	}

  	return { code: 200, status: 'Cadastando...' }
}

module.exports = {
  method: 'GET',
  path: '/status',
  handler
}

module.exports = {
	method: 'GET',
	path: '/tables',
	handler: table
}