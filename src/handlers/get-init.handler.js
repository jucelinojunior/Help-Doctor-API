function table (request,h) {

	const xlsxj = require("xlsx-to-json");
	const sheets = ['TB_TYPE_PRONOUNCER','TB_TYPE_APPOINTMENT','TB_ROLE','TB_USER','TB_HOSPITAL','TB_PATIENT','TB_MEDICAL_CATEGORY','TB_USER_HAS_MEDICAL_CATEGORY','TB_PRONOUNCER','TB_APPOINTMENT'];
	const client = require('../../config/dbConnect.js').connect();

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
	path: '/init',
	handler: function (request, h) {

		const client = require('../../config/dbConnect.js').connect();
		return client.query(`
			
			DROP TABLE IF EXISTS TB_TRAUMA,TB_PAIN,TB_APPOINTMENT,TB_USER_HAS_MEDICAL_CATEGORY,TB_MEDICAL_CATEGORY,TB_TYPE_APPOINTMENT,TB_QUEUE,TB_SCREENING,TB_SCREENING_INFO,TB_TYPE_PRONOUNCER,TB_PRONOUNCER,TB_PATIENT,TB_HOSPITAL,TB_USER,TB_ROLE;

			CREATE TABLE IF NOT EXISTS TB_ROLE (
					id SERIAL PRIMARY KEY,
					name  VARCHAR(255) NOT NULL,
					createdAt TIMESTAMP WITH TIME ZONE NULL DEFAULT now(),
					updatedAt TIMESTAMP WITH TIME ZONE NULL DEFAULT now()
				);

				CREATE TABLE IF NOT EXISTS TB_USER (
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

				CREATE TABLE IF NOT EXISTS TB_HOSPITAL (
					id SERIAL PRIMARY KEY,
					name VARCHAR(255) NOT NULL,
					address VARCHAR(255) NOT NULL,
					numbberAddress VARCHAR(100) NOT NULL,
					complement VARCHAR(100) NULL,
					createdAt TIMESTAMP WITH TIME ZONE NULL DEFAULT NOW(),
					updatedAt TIMESTAMP WITH TIME ZONE NULL DEFAULT NOW()
				);	

				CREATE TABLE IF NOT EXISTS TB_PATIENT (
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

				CREATE TABLE TB_TYPE_PRONOUNCER (
					id SERIAL PRIMARY KEY,
					name VARCHAR(255) NOT NULL,
					createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
					updatedAt TIMESTAMP WITH TIME ZONE DEFAULT NOW()
				);

				CREATE TABLE TB_PRONOUNCER (
					id SERIAL PRIMARY KEY,
					patient_id INT NOT NULL,
					hospital_id INT NOT NULL,
					type_pronouncer INT NOT NULL,
					description VARCHAR(255) NOT NULL,
					createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
					updatedAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
					foreign key (patient_id ) references TB_PATIENT(id),
					foreign key (hospital_id ) references TB_HOSPITAL(id),
					foreign key (type_pronouncer ) references TB_TYPE_PRONOUNCER(id)
				);


			CREATE TABLE TB_QUEUE (
				id SERIAL PRIMARY KEY,
				hospital_id INT NOT NULL,
				tb_user INT NOT NULL,
				severity SMALLINT NOT NULL,
				status SMALLINT NOT NULL,
				updatedAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
				createdAt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
				foreign key (hospital_id) references TB_HOSPITAL(id),
				foreign key (tb_user) references TB_USER(id)
			);

			CREATE TABLE TB_TYPE_APPOINTMENT (
			  id SERIAL PRIMARY KEY,
			  name VARCHAR(255) NOT NULL,
			  createdAt TIMESTAMP NULL DEFAULT NOW(),
			  updatedAt TIMESTAMP NULL DEFAULT NOW()
			);

			CREATE TABLE TB_MEDICAL_CATEGORY (
			  id SERIAL PRIMARY KEY,
			  name VARCHAR(255) NOT NULL,
			  createdAt TIMESTAMP NULL DEFAULT NOW(),
			  updatedAt TIMESTAMP NULL DEFAULT NOW()
			);


			CREATE TABLE TB_USER_HAS_MEDICAL_CATEGORY (
			  user_id INT NOT NULL,
			  medical_category_id INT NOT NULL,
			  PRIMARY KEY (user_id, medical_category_id),
			  createdAt TIMESTAMP NULL DEFAULT NOW(),
			  updatedAt TIMESTAMP NULL DEFAULT NOW(),
			   foreign key (user_id) REFERENCES TB_USER(id),
			   foreign key (medical_category_id) REFERENCES TB_MEDICAL_CATEGORY(id)
			);

			CREATE TABLE TB_APPOINTMENT (
				id SERIAL PRIMARY KEY,
				pronouncer_id INT NOT NULL,
				schedule TIMESTAMP NOT NULL,
				medical_category_id INT NOT NULL,
				type_id INT NOT NULL,
				user_id INT NOT NULL,
				description VARCHAR(255) NOT NULL,
				skin_burn INT DEFAULT 0,
				fever FLOAT DEFAULT 0,
				convulsion SMALLINT DEFAULT 0,
				asthma BOOLEAN DEFAULT FALSE,
				vomit BOOLEAN DEFAULT FALSE,
				diarrhea BOOLEAN DEFAULT FALSE,
				apnea BOOLEAN DEFAULT FALSE,
				status SMALLINT DEFAULT 1,
				heart_attack BOOLEAN DEFAULT FALSE,
				hypovolemic_shock BOOLEAN DEFAULT FALSE,
				createdAt TIMESTAMP NULL DEFAULT NOW(),
				updatedAt TIMESTAMP NULL DEFAULT NOW(),
				medical_return BOOLEAN DEFAULT FALSE,
				is_pregnant BOOLEAN DEFAULT FALSE,
				foreign key (type_id) references TB_TYPE_APPOINTMENT(id),
				foreign key (pronouncer_id)  references TB_PRONOUNCER(id),
				foreign key (user_id) references TB_USER(id)
			);

			CREATE TABLE TB_PAIN (
			  id SERIAL PRIMARY KEY,
			  pain_name VARCHAR(255) NOT NULL,
			  createdAt TIMESTAMP NULL DEFAULT NOW(),
			updatedAt TIMESTAMP NULL DEFAULT NOW()
			);

			CREATE TABLE TB_TRAUMA (
			  id SERIAL PRIMARY KEY,
			  trauma_name VARCHAR(255) NOT NULL,
			  trauma_type INT NOT NULL,
			  createdAt TIMESTAMP NULL DEFAULT NOW(),
				updatedAt TIMESTAMP NULL DEFAULT NOW()
			);
			`).then((res) => {

			return table(request, h);
		}).catch(e => {
			return {status: 400,data: e};
		});
	}

}