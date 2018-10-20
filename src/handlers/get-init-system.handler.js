const sheets = [
		'ROLES',
		'ACTIONS',
		'ADDRESS',
		'ROLES_HAS_ACTIONS',
		'HOSPITAL',
		'USERS',
		'PATIENT',
		'TYPE_APPOINTMENT',
		'MEDICAL_CATEGORY',
		'TYPE_PRONOUNCER',
		'USERS_HAS_MEDICAL_CATEGORY',
		'PRONOUNCER',
		'APPOINTMENT'
];

/**
	SE ALTERAR NOME DE TABELA, ALTERAR A SHEET DENTRO DO EXCEL PARA O NOME DA TABELA E COLOCAR NO ARRAY ACIMA
	EM BAIXO TEM O SCRIPT PARA GERAR AS TABELAS, SE ALTERAR O NOME DE ALGUMA TABELA ALTERAR LÁ TAMBÉM

	SE FOR ADICIONAR TABELAS E ESSA TABELA TIVER UMA CARGA INICIAL, SÓ ADICIONAR UMA ABA COM O NOME DA TABELA NO EXCEL
	A PRIMEIRA LINHA SERÁ O NOME DA COLUNA, E AS DEMAIS OS VALORES, E COLOCAR NO ARRAY ACIMA O NOME DA TABELA

	CASO FOR ACRESCENDO UMA TABELA, INDEPENDETE DE CARGA INICIAL, COLOCAR O SCRIPT LOGO ABAIXO ONDE ESTÃO OS DEMAIS E TAMBÉM,
	COLOCAR O NOME NA LISTA DE DROP TABLES, PARA SEMPRE QUE PASSAR A ROTA INIT, DELETAR TUDO E FAZER DE NOVO, CUIDADO COM A ORDER DO 
	DROP POIS, AS PRIMEIRAS TABELAS A SEREM CRIADAS DEVEM SER AS ULTIMAS A SEREM EXCLUIDAS E VICE VERSA.

	SE ATUALIZAR O SCRIPT AQUI, ATUALIZAR TAMBÉM NO ARQUIVO db.sql NA RAIZ DO PROJETO.
*/

function table (request,h) {

	const xlsxj = require("xlsx-to-json");
	const client = require('../pgConnect.js').connect();
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
					client.query(text, values, (err, res) => {
						
						if(err != null) {
							console.log(sheet);
							console.log(text);
							console.log(values);
							console.log(err);
							die;
						}
					});
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

		const client = require('../pgConnect.js').connect();
		client.connect();
		return client.query(`
			
			DROP TABLE IF EXISTS 
			HOSPITAL_HAS_USER,USERS_HAS_ROLES
			,TRAUMA
			,PAIN
			,QUEUE
			,APPOINTMENT
			,PRONOUNCER
			,USERS_HAS_MEDICAL_CATEGORY
			,TYPE_PRONOUNCER
			,MEDICAL_CATEGORY
			,TYPE_APPOINTMENT
			,PATIENT
			,USERS
			,HOSPITAL
			,ROLES_HAS_ACTIONS
			,ADDRESS
			,ACTIONS
			,ROLES;

			CREATE TABLE ROLES (
				id SERIAL PRIMARY KEY,
				name  VARCHAR(255) NOT NULL,
				"createdAt" TIMESTAMP NULL DEFAULT NOW(),
				"updatedAt" TIMESTAMP NULL DEFAULT NOW(),
				"deletedAt" TIMESTAMP DEFAULT NULL
			);

			CREATE TABLE ACTIONS (
				id SERIAL PRIMARY KEY,
				name  VARCHAR(255) NOT NULL,
				"createdAt" TIMESTAMP NULL DEFAULT NOW(),
				"updatedAt" TIMESTAMP NULL DEFAULT NOW(),
				"deletedAt" TIMESTAMP DEFAULT NULL
			);

			CREATE TABLE ADDRESS (
				id SERIAL PRIMARY KEY,
				address  VARCHAR(255) NOT NULL,
				neighborhood VARCHAR(255) NOT NULL,
				state VARCHAR(10) NOT NULL,
				zipcode VARCHAR(50) NOT NULL,
				number VARCHAR(50) NOT NULL,
				complement VARCHAR(100) NULL,
				formatedAddress VARCHAR(250) NULL,
				"createdAt" TIMESTAMP NULL DEFAULT NOW(),
				"updatedAt" TIMESTAMP NULL DEFAULT NOW(),
				"deletedAt" TIMESTAMP DEFAULT NULL
			);

			CREATE TABLE ROLES_HAS_ACTIONS (
				id SERIAL PRIMARY KEY,
				role_id INT NOT NULL,
				action_id INT NOT NULL,
				"createdAt" TIMESTAMP NULL DEFAULT NOW(),
				"updatedAt" TIMESTAMP NULL DEFAULT NOW(),
				"deletedAt" TIMESTAMP DEFAULT NULL,
				foreign key (action_id) REFERENCES ACTIONS(id),
				foreign key (role_id) REFERENCES ROLES(id)
			);

			CREATE TABLE HOSPITAL (
				id SERIAL PRIMARY KEY,
				name VARCHAR(255) NOT NULL,
				address INT NOT NULL,	
				"createdAt" TIMESTAMP NULL DEFAULT NOW(),
				"updatedAt" TIMESTAMP NULL DEFAULT NOW(),
				"deletedAt" TIMESTAMP DEFAULT NULL,
				foreign key (address) REFERENCES ADDRESS(id)
			);

			CREATE TABLE USERS (
				id SERIAL PRIMARY  KEY,
				name VARCHAR(255) NOT NULL,
				email VARCHAR(255) UNIQUE NOT NULL,
				salt VARCHAR(255) NOT NULL,
				password VARCHAR(255) NOT NULL,
				"addressId" INT NULL,
				birthday TIMESTAMP NOT NULL,
				genre VARCHAR(1) NULL,
				medical_document VARCHAR(100) UNIQUE NULL,
				personal_document VARCHAR(100) UNIQUE NOT NULL,
				responsable_hospital INT NULL,
				"createdAt" TIMESTAMP NULL DEFAULT NOW(),
				"updatedAt" TIMESTAMP DEFAULT NOW(),
				"deletedAt" TIMESTAMP DEFAULT NULL,
				foreign key (responsable_hospital) references HOSPITAL(id),
				foreign key ("addressId") REFERENCES ADDRESS(id)
			);


			CREATE TABLE PATIENT (
				id SERIAL PRIMARY KEY,
				name VARCHAR(200) NOT NULL,
				personal_document VARCHAR(100) NOT NULL,
				email VARCHAR(255) UNIQUE NOT NULL,
				birthday TIMESTAMP NOT NULL,
				address_id INT NOT NULL,
				genre VARCHAR(1) NULL,
				phoneNumber VARCHAR(100) NOT NULL,
				"createdAt" TIMESTAMP NULL DEFAULT NOW(),
				"updatedAt" TIMESTAMP DEFAULT NOW(),
				"deletedAt" TIMESTAMP DEFAULT NULL,
				foreign key (address_id) REFERENCES ADDRESS(id)
			);



			CREATE TABLE TYPE_APPOINTMENT (
				id SERIAL PRIMARY KEY,
				name VARCHAR(255) NOT NULL,
				createdAt TIMESTAMP NULL DEFAULT NOW(),
				updatedAt TIMESTAMP NULL DEFAULT NOW()
			);

			CREATE TABLE MEDICAL_CATEGORY (
				id SERIAL PRIMARY KEY,
				name VARCHAR(255) NOT NULL,
				createdAt TIMESTAMP NULL DEFAULT NOW(),
				updatedAt TIMESTAMP NULL DEFAULT NOW()
			);

			CREATE TABLE TYPE_PRONOUNCER (
				id SERIAL PRIMARY KEY,
				name VARCHAR(255) NOT NULL,
				createdAt TIMESTAMP NULL DEFAULT NOW(),
				updatedAt TIMESTAMP NULL DEFAULT NOW()
			);

			CREATE TABLE USERS_HAS_MEDICAL_CATEGORY (
				user_id INT NOT NULL,
				medical_category_id INT NOT NULL,
				PRIMARY KEY (user_id, medical_category_id),
				createdAt TIMESTAMP NULL DEFAULT NOW(),
				updatedAt TIMESTAMP NULL DEFAULT NOW(),
				foreign key (user_id) REFERENCES USERS(id),
				foreign key (medical_category_id) REFERENCES MEDICAL_CATEGORY(id)
			);

			CREATE TABLE PRONOUNCER (
				id SERIAL PRIMARY KEY,
				patient_id INT NOT NULL,
				hospital_id INT NOT NULL,
				type_pronouncer INT NOT NULL,
				description VARCHAR(255) NOT NULL,
				"createdAt" TIMESTAMP NULL DEFAULT NOW(),
				"updatedAt" TIMESTAMP NULL DEFAULT NOW(),
				"deletedAt" TIMESTAMP DEFAULT NULL,
				foreign key (patient_id ) references PATIENT(id),
				foreign key (hospital_id ) references HOSPITAL(id),
				foreign key (type_pronouncer ) references TYPE_PRONOUNCER(id)
			);


			CREATE TABLE APPOINTMENT (
				id SERIAL PRIMARY KEY,
				pronouncer_id INT NOT NULL,
				schedule TIMESTAMP NOT NULL,
				medical_category_id INT NOT NULL,
				type_id INT NOT NULL,
				user_id INT NOT NULL,
				description VARCHAR(255) NOT NULL,
				status SMALLINT DEFAULT 1,
				skin_burn INT DEFAULT 0,
				fever INT DEFAULT 0,
				convulsion SMALLINT DEFAULT 0,
				asthma BOOLEAN DEFAULT FALSE,
				vomit BOOLEAN DEFAULT FALSE,
				diarrhea BOOLEAN DEFAULT FALSE,
				apnea BOOLEAN DEFAULT FALSE,
				heart_attack BOOLEAN DEFAULT FALSE,
				hypovolemic_shock BOOLEAN DEFAULT FALSE,
				"createdAt" TIMESTAMP NULL DEFAULT NOW(),
				"updatedAt" TIMESTAMP NULL DEFAULT NOW(),
				"deletedAt" TIMESTAMP DEFAULT NULL,
				medical_return BOOLEAN DEFAULT FALSE,
				is_pregnant BOOLEAN DEFAULT FALSE,
				foreign key (type_id) references TYPE_APPOINTMENT(id),
				foreign key (pronouncer_id)  references PRONOUNCER(id),
				foreign key (user_id) references USERS(id)
			);

				CREATE TABLE QUEUE (
					id SERIAL PRIMARY KEY,
					hospital_id INT NOT NULL,
					appointment_id INT NOT NULL,
					severity SMALLINT NOT NULL,
					status SMALLINT NOT NULL,
					"createdAt" TIMESTAMP NULL DEFAULT NOW(),
					"updatedAt" TIMESTAMP NULL DEFAULT NOW(),
					"deletedAt" TIMESTAMP DEFAULT NULL,
					foreign key (hospital_id) references TB_HOSPITAL(id),
					foreign key (appointment_id) references TB_APPOINTMENT(id)
				);

				CREATE TABLE PAIN (
					id SERIAL PRIMARY KEY,
					pain_name VARCHAR(255) NOT NULL,
					createdAt TIMESTAMP NULL DEFAULT NOW(),
					updatedAt TIMESTAMP NULL DEFAULT NOW()
				);

				CREATE TABLE TRAUMA (
					id SERIAL PRIMARY KEY,
					trauma_name VARCHAR(255) NOT NULL,
					trauma_type INT NOT NULL,
					createdAt TIMESTAMP NULL DEFAULT NOW(),
					updatedAt TIMESTAMP NULL DEFAULT NOW()
				);

				CREATE TABLE USERS_HAS_ROLES (
					id SERIAL PRIMARY KEY,
					role_id INT NOT NULL,
					user_id INT NOT NULL,
					"createdAt" TIMESTAMP NULL DEFAULT NOW(),
					"updatedAt" TIMESTAMP DEFAULT NOW(),
					"deletedAt" TIMESTAMP DEFAULT NULL,
					foreign key (user_id) REFERENCES USERS(id),
					foreign key (role_id) REFERENCES ROLES(id)
				);

				CREATE TABLE HOSPITAL_HAS_USER (
					id SERIAL PRIMARY KEY,
					hospital_id INT NOT NULL,
					user_id INT NOT NULL,
					createdAt TIMESTAMP NULL DEFAULT NOW(),
					updatedAt TIMESTAMP NULL DEFAULT NOW(),
					foreign key (hospital_id) references HOSPITAL(id),
					foreign key (user_id) references USERS(id)
				);
			`).then((res) => {
				client.end();
				return table(request, h);
		
			}).catch(e => {
				client.end();
				return {status: 400,data: e};
			});
	}

}