const medicalRecords = require('../models/pronouncer')
const Hospital = require('../models/hospital');
const Patient = require('../models/patient');
const Appointment = require('../models/appointment');

const create = async (data) => {

	if(!data.patient_id || !data.hospital_id || !data.type_pronouncer || !data.description) {
		return {errors: true, data: "Faltam atributos"};
	}

	var pronouncer = await medicalRecords.findOne({
		where: {
			$and: [
      			global.sequelize.where(global.sequelize.fn('date', sequelize.col('createdAt')), '=', '2018-11-07'),
      			{ patient_id: data.patient_id },
      			{ hospital_id: data.hospital_id }
    		]
		}
	});

	if (pronouncer == null) {
		pronouncer = new medicalRecords();
	}
	
	return pronouncer.update(data).then(() => {
		return {errors: false,data: pronouncer};
	}).catch(err => {
		return {errors: true,data: "Erro ao salvar atributos, erro no atributo err",err: err};
	});
}

const update = async(id,data) => {
	
	var pronouncer = await medicalRecords.findOne({
		where: {
			id: id
		}
	});

	return pronouncer.update(data).then(() => {
		return {errors: false,data: pronouncer};
	}).catch(err => {
		return {errors: true,data: "Erro ao salvar atributos, erro no atributo err",err: err};
	});
}

const getAll = async(isFull,value1,key1,value2,key2) => {
	
	var obj = {}
	obj[key1] = value1;

	if(key2 != undefined) {
		obj[key2] = value2;
	}

	if(key1 == "id") {
		var all =  await medicalRecords.findOne({
			where: obj,
			include: [
				{
					model: Patient,
					as: 'patient',
					required: true,
					attributes: [
						'id',
						'name',
						'email',
						'personal_document',
						'birthday',
						'genre'
					]
				},
				{
					model: Hospital,
					as: 'hospital',
					required: true,
					attributes: [
						'id',
						'name',
					]
				},
			]
		});

    	if (isFull) {
			all.dataValues.pronouncer = await Appointment.findAll({
				where: {
					pronouncer_id: all.id
				}
			});
		}
	}
	
	else { 
		var all =  await medicalRecords.findAll({
			where: obj,
			include: [
				{
					model: Patient,
					as: 'patient',
					required: true,
					attributes: [
						'id',
						'name',
						'email',
						'personal_document',
						'birthday',
						'genre'
					]
				},
				{
					model: Hospital,
					as: 'hospital',
					required: true,
					attributes: [
						'id',
						'name',
					]
				}
			]
		});
	}

	return {errors: false, data: all};

}

module.exports = {
	create,
	update,
	getAll
}