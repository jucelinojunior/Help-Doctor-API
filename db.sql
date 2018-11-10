drop schema public cascade;
create schema public;

/*

SE ATUALIZAR AQUI, ATUALIZAR O ARQUIVO get-init-system.handler TAMBÉM

*/

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
        city  VARCHAR(255) NULL,
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
        id SERIAL,
        role_id INT NOT NULL,
        action_id INT NOT NULL,
        "createdAt" TIMESTAMP NULL DEFAULT NOW(),
        "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
        "deletedAt" TIMESTAMP DEFAULT NULL,
        foreign key (action_id) REFERENCES ACTIONS(id),
        foreign key (role_id) REFERENCES ROLES(id),
        PRIMARY KEY (id, role_id, action_id)
      );

      CREATE TABLE HOSPITAL (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        "addressId" INT NOT NULL,
        "createdAt" TIMESTAMP NULL DEFAULT NOW(),
        "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
        "deletedAt" TIMESTAMP DEFAULT NULL,
        foreign key ("addressId") REFERENCES ADDRESS(id)
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
        "addressId" INT NOT NULL,
        genre VARCHAR(1) NULL,
        "phoneNumber" VARCHAR(100) NOT NULL,
        "createdAt" TIMESTAMP NULL DEFAULT NOW(),
        "updatedAt" TIMESTAMP DEFAULT NOW(),
        "deletedAt" TIMESTAMP DEFAULT NULL,
        foreign key ("addressId") REFERENCES ADDRESS(id)
      );



      CREATE TABLE TYPE_APPOINTMENT (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        "createdAt" TIMESTAMP NULL DEFAULT NOW(),
        "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
        "deletedAt" TIMESTAMP DEFAULT NULL
      );

      CREATE TABLE MEDICAL_CATEGORY (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        "createdAt" TIMESTAMP NULL DEFAULT NOW(),
        "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
        "deletedAt" TIMESTAMP DEFAULT NULL
      );

      CREATE TABLE TYPE_PRONOUNCER (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        "createdAt" TIMESTAMP NULL DEFAULT NOW(),
        "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
        "deletedAt" TIMESTAMP DEFAULT NULL
      );

      CREATE TABLE USERS_HAS_MEDICAL_CATEGORY (
        user_id INT NOT NULL,
        medical_category_id INT NOT NULL,
        PRIMARY KEY (user_id, medical_category_id),
        "createdAt" TIMESTAMP NULL DEFAULT NOW(),
        "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
        "deletedAt" TIMESTAMP DEFAULT NULL,
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
          foreign key (hospital_id) references HOSPITAL(id),
          foreign key (appointment_id) references APPOINTMENT(id)
        );

        CREATE TABLE PAIN (
          id SERIAL PRIMARY KEY,
          pain_name VARCHAR(255) NOT NULL,
          severity SMALLINT NOT NULL,
          "createdAt" TIMESTAMP NULL DEFAULT NOW(),
          "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
          "deletedAt" TIMESTAMP DEFAULT NULL
        );


        CREATE TABLE TRAUMA (
          id SERIAL PRIMARY KEY,
          severity SMALLINT NOT NULL,
          trauma_name VARCHAR(255) NOT NULL,
          trauma_type INT NOT NULL,
          "createdAt" TIMESTAMP NULL DEFAULT NOW(),
          "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
          "deletedAt" TIMESTAMP DEFAULT NULL
        );

        CREATE TABLE APPOINTMENT_HAS_TRAUMAS (
          id SERIAL PRIMARY KEY,
          appointment_id INT NOT NULl,
          trauma_id INT NOT NULL,
          "createdAt" TIMESTAMP NULL DEFAULT NOW(),
          "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
          "deletedAt" TIMESTAMP DEFAULT NULL,
          foreign key (appointment_id) REFERENCES APPOINTMENT(id),
          foreign key (trauma_id) REFERENCES TRAUMA(id)
        );

        CREATE TABLE APPOINTMENT_HAS_PAIN (
          id SERIAL PRIMARY KEY,
          appointment_id INT NOT NULl,
          pain_id INT NOT NULL,
          "createdAt" TIMESTAMP NULL DEFAULT NOW(),
          "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
          "deletedAt" TIMESTAMP DEFAULT NULL,
          foreign key (appointment_id) REFERENCES APPOINTMENT(id),
          foreign key (pain_id) REFERENCES PAIN(id)
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
          id SERIAL NOT NULL,
          hospital_id INT NOT NULL,
          user_id INT NOT NULL,
          "createdAt" TIMESTAMP NULL DEFAULT NOW(),
          "updatedAt" TIMESTAMP NULL DEFAULT NOW(),
          "deletedAt" TIMESTAMP DEFAULT NULL,
          foreign key (hospital_id) references HOSPITAL(id),
          foreign key (user_id) references USERS(id),
          PRIMARY KEY (id, hospital_id, user_id)
        );

INSERT INTO public.address(
            address, neighborhood, state, zipcode, "number", complement, formatedaddress, city)
    VALUES ('Rua teste','Bairro Teste', 'SP', '04174090', 8, '', 'Rua teste, 8 Bairro Teste - 04174090', 'Cidate Teste');

INSERT INTO public.hospital(
             name, "addressId")
    VALUES ( 'Hospital teste', 1);
insert into hospital_has_user (user_id, hospital_id) values (1,1);

INSERT INTO public.users(
            name,
            email,
            salt,
            password,
            "addressId",
            birthday,
            medical_document,
            personal_document,
            responsable_hospital,
            genre,
            "createdAt",
            "updatedAt",
            "deletedAt"
          )
    VALUES (
      'Administrador',
      'admin@helpdoctor.com.br',
      '$2a$10$VfGHHzlP0BjjbHWWpg4BhO',
      '$2a$10$VfGHHzlP0BjjbHWWpg4BhOR/zhjeDbmWjnAgNbvN7omojJMHtnw9a',
      1,
      '1980-01-01',
      null,
      '12345678923',
      null,
      'M',
      '2018-10-12 17:36:33.58',
      '2018-10-12 17:36:33.58',
      null);

INSERT INTO public.users(
            id,
            name,
            email,
            salt,
            password,
            "addressId",
            birthday,
            medical_document,
            personal_document,
            responsable_hospital,
            genre,
            "createdAt",
            "updatedAt",
            "deletedAt"
          )
    VALUES (
      2,
      'Manager',
      'manager@helpdoctor.com.br',
      '$2a$10$VfGHHzlP0BjjbHWWpg4BhO',
      '$2a$10$VfGHHzlP0BjjbHWWpg4BhOR/zhjeDbmWjnAgNbvN7omojJMHtnw9a',
      1,
      '1980-01-01',
      null,
      '06497063072',
      1,
      'M',
      '2018-10-12 17:36:33.58',
      '2018-10-12 17:36:33.58',
      null);




INSERT INTO public.roles(
            name)
    VALUES ( 'ADMIN');

    INSERT INTO public.roles(
            name)
    VALUES ( 'MANAGER');


-- Vinculo de roles e actions para usuario admin
INSERT INTO users_has_roles (user_id, role_id) VALUES (1,1);

insert into actions (name) values ('user.create');
insert into actions (name) values ('user.all');
insert into actions (name) values ('user.find');
insert into actions (name) values ('user.update');
insert into actions (name) values ('user.delete');
insert into actions (name) values ('hospital.create');
insert into actions (name) values ('hospital.update');
insert into actions (name) values ('user.list');
insert into actions (name) values ('hospital.list');
insert into actions (name) values ('hospital.all');
insert into actions (name) values ('hospital.delete');
insert into actions (name) values ('hospital.find');
insert into actions (name) values ('queue.list');
insert into actions (name) values ('medical_category.list');
insert into actions (name) values ('medical_category.create');
insert into actions (name) values ('hospital_user.add');
insert into actions (name) values ('user.resetpassword');
insert into actions (name) values ('role.list');
insert into actions (name) values ('role.find');
insert into actions (name) values ('role.delete');
insert into actions (name) values ('role.update');
insert into actions (name) values ('role.create');
insert into actions (name) values ('role_action.create');
insert into actions (name) values ('role_action.delete');
insert into actions (name) values ('user_role.delete');
insert into actions (name) values ('user_role.create');
insert into actions (name) values ('action.list');
insert into actions (name) values ('appointment.update');
insert into actions (name) values ('patient.list');
insert into actions (name) values ('patient.create');
insert into actions (name) values ('patient.update');
insert into actions (name) values ('patient.delete');
insert into actions (name) values ('patient.find');

insert into roles_has_actions (role_id, action_id) values (1,1);
insert into roles_has_actions (role_id, action_id) values (1,2);
insert into roles_has_actions (role_id, action_id) values (1,3);
insert into roles_has_actions (role_id, action_id) values (1,4);
insert into roles_has_actions (role_id, action_id) values (1,5); -- user.delete
insert into roles_has_actions (role_id, action_id) values (1,6);
insert into roles_has_actions (role_id, action_id) values (1,7); -- hospital.update
insert into roles_has_actions (role_id, action_id) values (1,8); -- user.list
insert into roles_has_actions (role_id, action_id) values (1,9); -- hospital.list
insert into roles_has_actions (role_id, action_id) values (1,10); -- hospital.all
insert into roles_has_actions (role_id, action_id) values (1,11); -- hospital.delete
insert into roles_has_actions (role_id, action_id) values (1,12); -- hospital.find
insert into roles_has_actions (role_id, action_id) values (1,13); -- queue.list
insert into roles_has_actions (role_id, action_id) values (1,14); -- medical_category.list
insert into roles_has_actions (role_id, action_id) values (1,15); -- medical_category.create
insert into roles_has_actions (role_id, action_id) values (1,16); -- hospital_user.add
insert into roles_has_actions (role_id, action_id) values (1,17); -- user.resetpassword
insert into roles_has_actions (role_id, action_id) values (1,18); -- role.list
insert into roles_has_actions (role_id, action_id) values (1,19); -- role.find
insert into roles_has_actions (role_id, action_id) values (1,20); -- role.delete
insert into roles_has_actions (role_id, action_id) values (1,21); -- role.update
insert into roles_has_actions (role_id, action_id) values (1,22); -- role.create
insert into roles_has_actions (role_id, action_id) values (1,23); -- role_action.create
insert into roles_has_actions (role_id, action_id) values (1,24); -- role_action.delete
insert into roles_has_actions (role_id, action_id) values (1,25); -- user_role.delete
insert into roles_has_actions (role_id, action_id) values (1,26); -- user_role.create
insert into roles_has_actions (role_id, action_id) values (1,27); -- action.list
insert into roles_has_actions (role_id, action_id) values (1,28); -- appointment.update
insert into roles_has_actions (role_id, action_id) values (1,29); -- patient.list
insert into roles_has_actions (role_id, action_id) values (1,30); -- patient.create
insert into roles_has_actions (role_id, action_id) values (1,31); -- patient.update
insert into roles_has_actions (role_id, action_id) values (1,32); -- patient.delete
insert into roles_has_actions (role_id, action_id) values (1,33); -- patient.find



-- Vinculo de roles e actions para o usuario manager
INSERT INTO users_has_roles (user_id, role_id) VALUES (2,2);
insert into roles_has_actions (role_id, action_id) values (2,8); -- user.list
insert into roles_has_actions (role_id, action_id) values (2,9); -- hospital.list
insert into roles_has_actions (role_id, action_id) values (2,29); -- patient.list
insert into roles_has_actions (role_id, action_id) values (2,30); -- patient.create
insert into roles_has_actions (role_id, action_id) values (2,31); -- patient.update
insert into roles_has_actions (role_id, action_id) values (2,32); -- patient.delete
insert into roles_has_actions (role_id, action_id) values (2,33); -- patient.find

-- SELECT * FROM users as users
-- inner join users_has_roles as users_has_roles ON users_has_roles.user_id = users.id
-- inner join roles as roles ON roles.id = users_has_roles.role_id
-- inner join roles_has_actions as roles_has_actions ON roles_has_actions.role_id = roles.id
-- inner join actions as actions ON actions.id = roles_has_actions.action_id

-- where personal_document = '38724313823'




INSERT INTO ROLES(name) VALUES('ADMIN');
INSERT INTO ROLES(name) VALUES('Atendente');
INSERT INTO ROLES(name) VALUES('Enfermeiro');
INSERT INTO ROLES(name) VALUES('Médico');
INSERT INTO ACTIONS(name) VALUES('create-user');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Alet Einstein, 627 Moumi | São Paulo Telefone: (11) 2151-1233','teste','TESTE','SP','9780900','627','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Diogo Caea, 94 Imiim | São Paulo Telefone: (11) 2189-1199','teste','TESTE','SP','9780900','94','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Bigadeio Gavião Peixoto 123 Lapa | São Paulo Telefone: (11) 2189-1199','teste','TESTE','SP','9780900','123','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Guilheme Asah Neto, 438 Chácaa Floa | São Paulo Telefone: (11) 2185-0300','teste','TESTE','SP','9780900','438','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Min. Gaiel Resende Passos, 550 Moema | São Paulo Telefone: (11) 2186 9900','teste','TESTE','SP','9780900','550','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Baão do Rio Banco, 555 Santo Amao | São Paulo Telefone: 2185.0500','teste','TESTE','SP','9780900','555','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida João Fimino, 250 Assunção – São Benado do Campo Telefone: (11) 4344- 8000','teste','TESTE','SP','9780900','250','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Pade Adelino, 901 Belém – São Paulo Telefone: (11) 6602- 0000','teste','TESTE','SP','9780900','901','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Baão de Iguape, 209 Liedade – São Paulo Telefone: (11) 3345-2000','teste','TESTE','SP','9780900','209','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maesto Cadim, 769 Paaíso – São Paulo Telefone: (11) 3505-1000','teste','TESTE','SP','9780900','769','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Maiana U. do E. Santo, 140 Bom Clima – Guaulhos Telefone: (11) 2472-4200','teste','TESTE','SP','9780900','140','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Cel. Fenando Pestes, 1.177 Santo Andé – SP Telefones: (11) 2127-6666','teste','TESTE','SP','9780900','1,177','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Alcântaa Machado, 60 Bás – São Paulo Telefone: (11) 3278-0010 (11) 3346-6500','teste','TESTE','SP','9780900','60','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua do Oatóio, 1369 Mooca – São Paulo Telefone: (11) 2602- 8000','teste','TESTE','SP','9780900','1369','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Manoel Coelho, 845 São Caetano do Sul – São Paulo Telefone: (11) 4223| 4400','teste','TESTE','SP','9780900','845','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Cao Jose Teixeia, 189 Guaianazes – São Paulo Telefone: (11) 2551-5151','teste','TESTE','SP','9780900','189','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Lins de Vasconcelos, 356 Camucí – São Paulo Telefone: (11) 3348-4000','teste','TESTE','SP','9780900','356','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Moeia Guimaães, 699 Indianópolis – São Paulo Telefones: (11) 505-8714','teste','TESTE','SP','9780900','699','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. D. Dante Pazzanese, 500 Vila Maiana – São Paulo Telefone: (11) 5085 4000 (11) 5081-7983','teste','TESTE','SP','9780900','500','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. D. Eneas de C. Aguia, 255 Cequeia Césa – São Paulo Telefone: (11) 3069- 6226 (11) 3069 6000','teste','TESTE','SP','9780900','255','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Ael Tavaes, 21 Emelino Mataazzo – São Paulo Telefone: (11) 2546-6218 (11) 2546- 5422','teste','TESTE','SP','9780900','21','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Moeia Guimaães, 699 Indianópolis – São Paulo Telefone: (11) 5056 0100','teste','TESTE','SP','9780900','699','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Des. Eliseu Guilheme, 147 Paaíso – São Paulo Telefone: (11) 3053-6611','teste','TESTE','SP','9780900','147','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('R. Boges Lagoa, 1450 Vila Clementino – São Paulo Telefone: (11) 5080| 4300','teste','TESTE','SP','9780900','1450','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Dona Antonia, 636 Vila Palmeias – Guaulhos Telefone: (11) 2440| 0308 —','teste','TESTE','SP','9780900','636','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Silvia, 276 Bela Vista – São Paulo Telefones: (11) 3147-6200','teste','TESTE','SP','9780900','276','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Pofesso Fancisco Moato, 719 Butantã – São Paulo Telefone: (11) 3094-2300 / 3094- 2423','teste','TESTE','SP','9780900','719','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Douto Enéas Cavalho Aguia, 44 Cequeia Césa – São Paulo Telefone: (11) 3069 5000','teste','TESTE','SP','9780900','44','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Uucuama, 7610 São Miguel Paulista – São Paulo Telefone: (11) 2030-6000','teste','TESTE','SP','9780900','7610','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. D. Enéas Cavalho de Aguia, 647 Cequeia Césa – São Paulo Telefone: (11) 3069-8500','teste','TESTE','SP','9780900','647','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Usulina D’ângelo, 366 Itaquea – São Paulo Telefone: (11) 2286-2633','teste','TESTE','SP','9780900','366','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Atu Azevedo 1659 Pinheios – São Paulo Telefone: (11) 3081-6655','teste','TESTE','SP','9780900','1659','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Tês Imãos, 121 Moumi – Sao Paulo Telefone: (11) 3723-4700','teste','TESTE','SP','9780900','121','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Conselheio Boteo, 999 Santa Cecília – São Paulo Telefone: (11) 3825-5000 / 3825-5525','teste','TESTE','SP','9780900','999','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Macelina, 441 Lapa – Vila Romana – São Paulo Telefone: (11) 3677-2000','teste','TESTE','SP','9780900','441','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Pade Damaso, 100 Cento – Osasco – São Paulo Telefone: (11) 3685- 2943','teste','TESTE','SP','9780900','100','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Celso Gacia, 4815 Tatuapé – São Paulo Telefone: (11) 6191-7000','teste','TESTE','SP','9780900','4815','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Pistóia, 100 Paque Novo Mundo – São Paulo Telefone: (11) 2633-2200','teste','TESTE','SP','9780900','100','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Nossa Senhoa de Fátima, 497 São Caetano do Sul Telefone: (11) 4227- 8200','teste','TESTE','SP','9780900','497','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Hannemann, 234 Pai – São Paulo Telefone: (11) 3322-6500','teste','TESTE','SP','9780900','234','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Peixoto Gomide, 625 Cequeia Césa – São Paulo Telefone: (11) 3147-9999','teste','TESTE','SP','9780900','625','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua João Julião, 331 Paaíso – São Paulo Telefone: (11) 3549 0000 Fax 3287 8177','teste','TESTE','SP','9780900','331','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua D. Diogo de Faia, 780 Vila Clementino – São Paulo Telefone: (11) 5087| 8700 / 5087| 8787','teste','TESTE','SP','9780900','780','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Raimundo Peeia Magalhães, 12.335 Paada de Taipas – São Paulo Telefone: (11) 3948-8221','teste','TESTE','SP','9780900','12,335','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Candido Potinai, 455 Vila Jaguaa – São Paulo Telefone: (11) 3465-0700 (11) 3465- 0777','teste','TESTE','SP','9780900','455','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('A. Nova Cachoeiinha, 2398 Tucuuvi – São Paulo Telefone: (11) 6203- 6611','teste','TESTE','SP','9780900','2398','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Al. Joaquim Eugênio de Lima, 383 Bela Vista – São Paulo Telefone: (11) 3269-2233','teste','TESTE','SP','9780900','383','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Fagundes Filho, 300 Jaaquaa – São Paulo Telefone: (11) 5071-6198 (11) 5581-7633','teste','TESTE','SP','9780900','300','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Ruen Beta, 1100 Indianópolis – São Paulo Telefone: (11) 5908- 6474','teste','TESTE','SP','9780900','1100','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Besse, 1954 Bás – São Paulo Telefones: (11) 2693-0595','teste','TESTE','SP','9780900','1954','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Conselheio Boteo, 1486 Higienópolis – São Paulo Telefones: (11) 3821-5300','teste','TESTE','SP','9780900','1486','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Nossa Senhoa do Saaá, 70 Santo Amao – São Paulo Telefone: (11) 5548-3136 / 5524-8572','teste','TESTE','SP','9780900','70','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Douto Cesáio Motta Júnio, 112 Santa Cecília – São Paulo Telefones: (11) 2176- 7000','teste','TESTE','SP','9780900','112','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Paulista, 200 Bela Vista – São Paulo Tel: (11) 3016- 4133 Fax: 3016-4413','teste','TESTE','SP','9780900','200','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Santa Cuz, 398 Vila Maiana – São Paulo Telefone: (11) 5080-2002','teste','TESTE','SP','9780900','398','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua São Joaquim, 36 Liedade – São Paulo Telefone: (11) 3275- 5326 (11) 3340- 8011','teste','TESTE','SP','9780900','36','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Dona Veidiana, 311 Higienópolis – São Paulo Tel: (11) 2176-7700 / Fax: 2176-7709','teste','TESTE','SP','9780900','311','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua do Paaíso, 432 Paaíso – São Paulo Telefones: (11) 5080- 6000 e 5080-6001','teste','TESTE','SP','9780900','432','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Santa Macelina, 177 Itaquea – São Paulo Telefone: (11) 2070- 6000','teste','TESTE','SP','9780900','177','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Santa Cataina, 2785 Jaaquaa – São Paulo Telefone: (11) 5013-1100 | 5562-8081 | 5562-8836','teste','TESTE','SP','9780900','2785','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Santo Amao, 2468 Booklin Paulista –&nsp;São Paulo Telefone: 3040- 8000','teste','TESTE','SP','9780900','2468','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Cuatão, 1.190 Vila Maiana – São Paulo Telefone: 5908| 6000 / 5908| 6098','teste','TESTE','SP','9780900','1,190','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Celso Gacia, 2.294 Belém – São Paulo Telefones: (11) 2799- 3162','teste','TESTE','SP','9780900','2,294','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Baão Dupat, 140 Santo Amao – São Paulo Telefone: (11) 5696-2333 / 5548-2333','teste','TESTE','SP','9780900','140','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Jacú Pêssego, 2.705 Itaquea – São Paulo Telefone: (11) 2842-5500','teste','TESTE','SP','9780900','2,705','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Lucas Nogueia Gacez, 400 Jadim do Ma – São Benado do Campo Telefone: (11) 4121- 1428','teste','TESTE','SP','9780900','400','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Pouso Alege, 1 Ipianga – São Paulo Telefones: (11) 2066- 7000','teste','TESTE','SP','9780900','1','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Pompéia, 1178 POMPÉIA – São Paulo Telefones: (11) 3677-4444','teste','TESTE','SP','9780900','1178','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Voluntáios da Pátia, 3696 Santana – São Paulo Telefones: (11) 2972- 8000','teste','TESTE','SP','9780900','3696','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Teenas, 161 Mooca – São Paulo Telefone: (11) 62029- 7222','teste','TESTE','SP','9780900','161','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Piapitingui, 80 Liedade – São Paulo Telefone: (11) 3208- 4411','teste','TESTE','SP','9780900','80','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua D Luiz Pícolo, 11 São Miguel Paulista – São Paulo Telefone: (11) 2714- 0144','teste','TESTE','SP','9780900','11','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Napoleão de Baos, 715 Vila Clementino – São Paulo Telefone: (11) 5576- 4522','teste','TESTE','SP','9780900','715','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Joaquim Maa, 138 Vila Matilde – São Paulo Telefone: (11) 2652- 2000','teste','TESTE','SP','9780900','138','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Vegueio, 4210 Vila Maiana – São Paulo Telefone: (11) 2182- 4444','teste','TESTE','SP','9780900','4210','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Pedo de Toledo, 1810 Vila Clementino – São Paulo Telefones: (11) 5583-7001','teste','TESTE','SP','9780900','1810','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Casto Alves, 60 Aclimação – São Paulo Telefone: (11) 3208- 2211','teste','TESTE','SP','9780900','60','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maechal Rondon, 299 Cento – Osasco Telefone (11) 3652- 8000 (11) 3652- 8015','teste','TESTE','SP','9780900','299','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Dona Adma Jafet, 91 Bela Vista – São Paulo Telefone: (11) 3155 0200','teste','TESTE','SP','9780900','91','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maia Cândida Peeia, 549 Itapegica – Guaulhos Telefone: (11) 2423-8500','teste','TESTE','SP','9780900','549','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Pofesso Lineu Pestes, 2565 Butantã – São Paulo Telefones: (11) 3091-9200','teste','TESTE','SP','9780900','2565','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Av. Nossa Senhoa do Saaá, 2375 Santo Amao – São Paulo Telefone: (11) 5631-1424 / 5633-4510','teste','TESTE','SP','9780900','2375','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Cao José Teixeia, 189 Lageado – Guaianazes – SP Telefone: (11) 2253|- 2118 / 2257- 9204','teste','TESTE','SP','9780900','189','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Voluntáios da Pátia 2786 Santana – São Paulo Telefone: (11) 2955| 1601','teste','TESTE','SP','9780900','2786','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Alameda Santos, Cerqueira César - São Paulo - SP','teste','TESTE','SP','01418-100','1126','ANDAR 3');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Vinte e Três, Centro - Ituiutaba - MG','teste','TESTE','SP','38300-114','1980','apto 803, Edificio Antares');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua José de Holanda, Torre - Recife - PE','teste','TESTE','SP','50710-140','580','apt 901');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Pitinga, Vila Lucia - São Paulo - SP','teste','TESTE','SP','03146-030','51','Apto 134 A');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Schon, Nova Gerty - São Caetano do Sul - SP','teste','TESTE','SP','09580-220','58','-');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Adélia Muanis Aydar, Jardim São Marco - São José do Rio Preto - SP','teste','TESTE','SP','15081-310','805','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Travessa Orquídea Reis Ortega, Residencial Parque Douradinho - São Carlos - SP','teste','TESTE','SP','13568-688','212','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Doutor Nilo Peçanha, Marape - SANTOS - SP','teste','TESTE','SP','11070-050','166','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Visconde de Jequitinhonha, Boa Viagem - Recife - PE','teste','TESTE','SP','51030-020','518','apt 602');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Gonçalves Chaves, Centro - Pelotas - RS','teste','TESTE','SP','96015-560','3625','504');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Serra de Juréa, Cidade Mãe do Céu - São Paulo - SP','teste','TESTE','SP','03323-020','735','72');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Santa Isabel, Vila Camilópolis - Santo André - SP','teste','TESTE','SP','09230-580','510','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('..., ... - ... - RJ','teste','TESTE','SP','22011-002','160','901');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Joaquim Nabuco, Divinópolis - Caruaru - PE','teste','TESTE','SP','55010-420','752','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Ibiúna, Vila Aricanduva - São Paulo - SP','teste','TESTE','SP','03507-010','262','ap 13');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maria Terci, Jardim Morumbi - Sorocaba - SP','teste','TESTE','SP','18085-610','34','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('SHN Quadra 1, Asa Norte - Brasília - DF','teste','TESTE','SP','70701-000','1','Biarritz 804');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Inglaterra, Jardim Siesta - Jacareí - SP','teste','TESTE','SP','12321100','67','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Sud Menucci, Jardim Aurélia - Campinas - SP','teste','TESTE','SP','13033-055','65','54A');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Tenente Francisco Oliveira da Silva, Pinheiro - Maceió - AL','teste','TESTE','SP','57057-220','40','SAEM');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maria Rosa de Siqueira, Santana - São Paulo - SP','teste','TESTE','SP','02404-020','150','CASA');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Guadalajara, Barra - Salvador - BA','teste','TESTE','SP','40140-461','398','Apt 902');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Estônia, Parque das Nações - Santo André - SP','teste','TESTE','SP','09280-170','703','703');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua joao goncalves teixeira, Vila Carrão - SP - SP','teste','TESTE','SP','03447-040','2','nenhum');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Brasilina Ilka Barbosa Ferraz, Jardim Brasília (Zona Leste) - São Paulo - SP','teste','TESTE','SP','03583-010','196','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Professor João Fiúsa, Jardim Canadá - Ribeirão Preto - SP','teste','TESTE','SP','14024-260','2480','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Padre Manso, Madureira - Rio de Janeiro - RJ','teste','TESTE','SP','21310260','12','Ap 203');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Jaguaribe, Vila Buarque - São Paulo - SP','teste','TESTE','SP','01224-000','584','apto 52');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua engenheiro Jorge Oliva, Vila Mascote - São Paulo - SP','teste','TESTE','SP','04362-060','450','121');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Alameda Colombia, 24 - Alphaville 2, Alphaville - Barueri - SP','teste','TESTE','SP','06470-010','24','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Engenheiro Heitor Antônio Eiras Garcia, Jardim Esmeralda - São Paulo - SP','teste','TESTE','SP','05588-000','125','Apto 101');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua do Lago, Aparecida - Alvorada - RS','teste','TESTE','SP','94853-845','292','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('RUA ANA CRISTINA, JARDIM PAINEIRAS - ITATIAIA - RJ','teste','TESTE','SP','27580-000','164','FUNDOS');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('CLN 5 Bloco A, Riacho Fundo I - Brasília - DF','teste','TESTE','SP','71805-521','ap-102','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Alberto Mendes Júnior, Bela Vista - Osasco - SP','teste','TESTE','SP','06070-010','120','Bela Vista');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Marcílio Dias, Centro - Pelotas - RS','teste','TESTE','SP','96020-480','1229','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua São Brás, Todos os Santos - Rio de Janeiro - RJ','teste','TESTE','SP','20770-150','370','apt 803');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Joaquim Távora, Vila Mariana - São Paulo - SP','teste','TESTE','SP','04015-012','1020','152a');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Municipalidade, Umarizal - Belém - Pa','teste','TESTE','SP','66050350','1757','Ed. Urano 505');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Leonardo da Vinci, Vila Guarani - São Paulo - SP','teste','TESTE','SP','04313-001','1285','Ap 42B');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Paranavaí, Vila Jaguara - São Paulo - SP','teste','TESTE','SP','05116-060','145','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Carlos Steinen, Paraíso - São Paulo - SP','teste','TESTE','SP','04004-012','399','Apto123');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maria Florinda, Piraporinha - Diadema - SP','teste','TESTE','SP','09951-340','56','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua José do Patrocínio, Porto Novo - São Gonçalo - RJ','teste','TESTE','SP','24436-600','136','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Juventos, Jd mutinga - Barueri - SP','teste','TESTE','SP','06463-240','109','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Napoleão de Barros, Vila Clementino - São Paulo - SP','teste','TESTE','SP','04024-002','566','apartamento 93');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Dona Alice Tibiriça, Bigorrilho - Curitiba - PR','teste','TESTE','SP','80730-320','765','Apto 227');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Doutor Alberto Vieira Lima, Bairu - Juiz de Fora - MG','teste','TESTE','SP','36050-070','429','401');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Os Dezoito do Forte, Centro - Caxias do Sul - RS','teste','TESTE','SP','95020-472','692','41');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Quadra 3 Conjunto A casa, Setor Residencial Leste (Planaltina) - Brasília - DF','teste','TESTE','SP','73350-301','24','vila buritis');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Passagem Padre Roque Casteliano, Remédios - Osasco - SP','teste','TESTE','SP','06298-180','43','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('RUA CANTAGALO, TATUAPE - SAO PAULO - SP','teste','TESTE','SP','03319-000','980','APTO 161');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Giovanni Quadri, Conjunto Residencial José Bonifácio - São Paulo - SP','teste','TESTE','SP','08255-500','166','Bloco 2 Apto 31');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Travessa Maquiavel, Atuba - Colombo - PR','teste','TESTE','SP','83408-190','96','96');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Caetanos, Vila Regente Feijó - São Paulo - SP','teste','TESTE','SP','03335-010','49','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua das Araras, Lagoa da Conceição - Florianópolis - SC','teste','TESTE','SP','88062-075','350','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Chanceler Oswaldo Aranha, São Mateus - Juiz de Fora - MG','teste','TESTE','SP','36016-340','514','802');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Divino Carvalho, Santa Rosa - Uberlândia - MG','teste','TESTE','SP','38401-780','casa','143');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Orozimbo Ribeiro, Santa Mônica - Uberlândia - MG','teste','TESTE','SP','38408-242','747','Apartamento 202');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('..., ... - ... - RS','teste','TESTE','SP','90520-420','302','não tem');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Grajaú, Anchieta - Belo Horizonte - MG','teste','TESTE','SP','30310-480','126','301');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua José Haddad, Duque de Caxias - Cuiabá - Mato grosso','teste','TESTE','SP','78043298','50','Apto 803');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Jardelina de Almeida Lopes, Parque Santana - Mogi das Cruzes - SP','teste','TESTE','SP','08730-805','689','Bloco 1 Apto 506');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Cedro, Recanto Tropical - Cascavel - PR','teste','TESTE','SP','85807-160','232','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Vitória, Conjunto Habitacional Presidente Castelo Branco - Carapicuíba - SP','teste','TESTE','SP','06325-090','61','apt 33');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Jayme Sapolnik, imbuí - Salvador - BA','teste','TESTE','SP','41720-075','1183','cond. morada alto do imbuí ap 37 torre imperial');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Doutor João Ribeiro, Penha de França - São Paulo - SP','teste','TESTE','SP','03634-000','apto 43B','apto 43B');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Tiradentes, Santa Terezinha - São Bernardo do Campo - SP','teste','TESTE','SP','09780-900','1837','bl 04 apt 104');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Antônio Bento, Sítio Paecara (Vicente de Carvalho) - Guarujá - SP','teste','TESTE','SP','11461020','10','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Alecrim, Sul (Águas Claras) - Brasília - DF','teste','TESTE','SP','71938-720','6','Bloco B Ap 507');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Doutor Manoel de Paiva Ramos, Vila São Francisco - São Paulo - SP','teste','TESTE','SP','05351-015','345','ap 44');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Franklin Máximo Pereira, Centro - Itajaí - SC','teste','TESTE','SP','88302-020','218','Apto 304');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Aveleda, Jardim Santa Terezinha (Zona Leste) - São Paulo - SP','teste','TESTE','SP','03572-330','88','BLOCO 01 AP 83');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Dardanellos, Jardim Petrópolis - Campo Grande - MS','teste','TESTE','SP','79102-330','172','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Serra de Capivaruçu, Vila Renato (Zona Leste) - São Paulo - SP','teste','TESTE','SP','03979-010','507','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Evangelina, Vila Carrão - São Paulo - SP','teste','TESTE','SP','03421-000','1075','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('AOS 1 Bloco G, Área Octogonal - Brasília - DF','teste','TESTE','SP','70660-017','502','APARTAMENTO');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Eurico Gaspar Dutra, Operário - Novo Hamburgo - RS','teste','TESTE','SP','93315260','70','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Pedro de Godói, Parque da Vila Prudente - São Paulo - SP','teste','TESTE','SP','3138010','375','52');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Tabatinguera, Sé - São Paulo - SP','teste','TESTE','SP','01020-903','294','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Paula Ferreira, Freguesia do Ó - São Paulo - SP','teste','TESTE','SP','02915-000','89','bloco D apto 52-D');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Fosca, Jardim Previdência - São Paulo - SP','teste','TESTE','SP','04159-040','50','Jardim Previdência');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rodovia Amaro Antônio Vieira, Itacorubi - Florianópolis - Santa Catarina','teste','TESTE','SP','88034102','2355','Apto 727');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Estrada União e Indústria, Itaipava - Petrópolis - RJ','teste','TESTE','SP','25730-736','9153','jequitibas ap 301');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Cândido Juca, Rodolfo Teófilo - Fortaleza - CE','teste','TESTE','SP','60430-580','100','APARTAMENTO 503');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Dias Leme, 123, Mooca - São Paulo - SP','teste','TESTE','SP','03118-040','Apto 124 A','Apto 124 A');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Presidente Pedreira, Ingá - Niterói - RJ','teste','TESTE','SP','24210-470','139','AP 1003');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Jornalista Alberto Francisco Torres, Icaraí - Niterói - RJ','teste','TESTE','SP','24230-001','97','apto 901');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Vieira Ravasco, Santa Cruz - Rio de Janeiro - RJ','teste','TESTE','SP','23520-185','591','Casa 03');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Estado de Minas Gerais, Loteamento Terras de São Pedro e São Paulo - Salto - SP','teste','TESTE','SP','13324-460','262','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Japão, Jardim São Luís - Santana de Parnaíba - SP','teste','TESTE','SP','06502-345','66','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Rossini Roosevelt de Albuquerque, Piedade - Jaboatão dos Guararapes - PE','teste','TESTE','SP','54410-310','1018','apt 2003');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Voluntários da Pátria, Centro - Campos dos Goytacazes - RJ','teste','TESTE','SP','28035-260','65','1201 bl1');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Fernando de Noronha, Nova Tramandaí - Tramandaí - RS','teste','TESTE','SP','95590-000','1998','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Antônio Carlos, Consolação - São Paulo - SP','teste','TESTE','SP','01309-010','196','Apto 123 a');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Professor Álvaro Jorge, Vila Izabel - Curitiba - PR','teste','TESTE','SP','80320-040','644','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Estrada Dona Castorina, Jardim Botânico - Rio de Janeiro - RJ','teste','TESTE','SP','22460-320','110','110');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Najla Carone Guedert, Pagani - Palhoça - SC','teste','TESTE','SP','88132-150','820','Apartamento-1401');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Reinaldo Senger, Vila Pinheiro - Botucatu - SP','teste','TESTE','SP','18609-470','82','82');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Joaquim Anacleto da Conceição, Teixeira Dias (Barreiro) - Belo Horizonte - MG','teste','TESTE','SP','30644-230','70','Ap 202');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Germano Beckert, Alto - Curitiba - Parana','teste','TESTE','SP','82840230','1229','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('RUA DENTISTA BARRETO, VILA CARRÃO - SÃO PAULO - SP','teste','TESTE','SP','03420-000','318','casa 77');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Bráulio Gonçalves, Madalena - Recife - PE','teste','TESTE','SP','50720-605','115','AP. 804');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua São João Del Rei, Benedito - Indaial - SC','teste','TESTE','SP','89084-668','670','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Pedro Cândido Romero, Gleba Fazenda Palhano - Londrina - PR','teste','TESTE','SP','86050-494','85','Ap 1702, Bloco 2');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Nova Orleans, Jardim Novo Mundo - Goiânia - GO','teste','TESTE','SP','74710-140','0','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Doutor Abelardo Pompeu do Amaral, Vila Industrial - Campinas - SP','teste','TESTE','SP','13035-590','98','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Buriti, Madureira - Rio de Janeiro - RJ','teste','TESTE','SP','21360-080','201','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Desembargador João Pereira, Santa Isabel - Teresina - Piauí','teste','TESTE','SP','64053040','4277','Ap 104 Zeus');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Marquês de Sapucaí, Marquês de Maricá - Maricá - RJ','teste','TESTE','SP','24904-415','613','Qd 06 Lot 13');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Ubatuba, Santo Elói - Coronel Fabriciano - MG','teste','TESTE','SP','35170-133','245','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Aroeira, Cidade Nova - Governador Valadares - MG','teste','TESTE','SP','35063-006','469','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Desembargador Ferreira França, Alto de Pinheiros - São Paulo - SP','teste','TESTE','SP','05446-050','40','apto 64 B');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Tenente João Cícero, Boa viagem - Recife - PE','teste','TESTE','SP','51020-190','717','1601');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('LARGO DO CEMITERIO, CENTRO - Lagarto - SE','teste','TESTE','SP','49400-000','80','OX ACADEMIA');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Vinte e Quatro de Maio, República - São Paulo - SP','teste','TESTE','SP','01041-000','171','ap 1402');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Fábio Araújo Santos, Nonoai - Porto Alegre - RS','teste','TESTE','SP','91720-390','1145','ap 407');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Ibirapuera, Centro - Poá - SP','teste','TESTE','SP','08550-070','42','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Costa Rica, Cidade Vista Verde - São José dos Campos - SP','teste','TESTE','SP','12223-270','114','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Caetano Marchesini, Portão - Curitiba - PR','teste','TESTE','SP','81070-110','779','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Sebastião Rodolfo Dalgado, Conjunto Habitacional Barro Branco II - São Paulo - SP','teste','TESTE','SP','08473-610','145','CASA');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Aldo de Melo Freire, Capim Macio - Natal - RN','teste','TESTE','SP','59082-030','1900','1900');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua José Francisco da Silva, Vila Yolanda - Osasco - SP','teste','TESTE','SP','06124-250','11','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Estrada Frei Orlando, Jacaré - Niterói - RJ','teste','TESTE','SP','24350-200','141','Q. Dos ipês 10');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Emílio Goeldi, Lapa de Baixo - São Paulo - SP','teste','TESTE','SP','05065-110','545','apto 54 torre 1');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Antônio Pantaleão, Jardim Alto Rio Preto - São José do Rio Preto - sao paulo','teste','TESTE','SP','15020320','60','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua José Gonçalves Galeão, Jardim Avelino - São Paulo - SP','teste','TESTE','SP','03227-150','287','APTO 231B');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('..., ... - ... - SP','teste','TESTE','SP','12954-631','38','Chacaras Fernão Dias');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua chile, Jardim Lavínia - Mococa - SP','teste','TESTE','SP','13736-210','120','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua São Clemente, Botafogo - Rio de Janeiro - RJ','teste','TESTE','SP','22260000','114','Apto.808');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Cento e Quatro, Laranjal - Volta Redonda - RJ','teste','TESTE','SP','27255-140','147','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Angelina Marton Sestini, Residencial Nato Vetorasso - São José do Rio Preto - SP','teste','TESTE','SP','15042-120','111','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('AVENIDA BRASIL, CENTRO - São Pedro das Missões - RS','teste','TESTE','SP','98323-000','4460','APARTAMENTO 1');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Marechal Barbacena, Vila Regente Feijó - São Paulo - SP','teste','TESTE','SP','03333-000','1368','AP 42');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Doutor José Lourenço, Aldeota - Fortaleza - B','teste','TESTE','SP','60115281','955','AP 901');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Monsenhor Félix, Irajá - Rio de Janeiro - RJ','teste','TESTE','SP','21235-112','1158','404');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Galeandra, Jardim Eliane - São Paulo - SP','teste','TESTE','SP','03577-040','120','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Angelo Leonardo Tonietto, Cidade Nova - Caxias do Sul - RS','teste','TESTE','SP','95112-075','1740','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Rio de Janeiro, Mathias Velho - Canoas - RS','teste','TESTE','SP','92340-160','360','360');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Prefeito Dulcídio Cardoso, Barra da Tijuca - Rio de Janeiro - RJ','teste','TESTE','SP','22620-311','1200','bl 01, 308');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Funchal, Vila Olímpia - São Paulo - SP','teste','TESTE','SP','04551-060','418','3 andar');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua João José Rescala, Imbuí - Salvador - BA','teste','TESTE','SP','41720-000','199','Vila Anaiti, Condomínio Ikê, apt 2204');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Conselheiro Furtado, Cremação - Belém - PA','teste','TESTE','SP','66063-060','2922','203');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua 8, Parque Dois Irmãos - Fortaleza - CE','teste','TESTE','SP','60743-280','121B','Cj. Mirassol');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Augusto Duo, Vila América - Votuporanga - SP','teste','TESTE','SP','15502-107','1970','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('RUA FLORIANO PEIXOTO, CENTRO - Ijuí - RS','teste','TESTE','SP','98700-000','473','702');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Alameda Sapucaia, Botânico Mil - São Pedro - SP','teste','TESTE','SP','13520-000','274','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Nove, Centro - Ituiutaba - MG','teste','TESTE','SP','38300-150','657','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Euclides da Cunha, Nossa Senhora das Dores - Santa Maria - RS','teste','TESTE','SP','97095-407','1946','apartamento 705');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('QE 42 Conjunto S, Guará II - Brasília - DF','teste','TESTE','SP','71070-195','4','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Henrique Hartemink, centro - Panambi - RS','teste','TESTE','SP','98280-000','107','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Coronel Aparício Borges, Glória - Porto Alegre - Rio Grande do Sul','teste','TESTE','SP','90680570','1568','101');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('..., ... - ... - PE','teste','TESTE','SP','52060-450','60','apto 2202');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Travessa Vileta, Marco - Belém - PA','teste','TESTE','SP','66093-345','2585','apto 1501');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Vinte e oito de setembro, Vila Dom Pedro I - Sao Paulo - SP','teste','TESTE','SP','04267-000','523','73');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Francisco Rodrigues Filho, Vila Mogilar - Mogi das Cruzes - SP','teste','TESTE','SP','08773-380','1952','CASA 47');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Benta Pereira, Santa Teresinha - São Paulo - SP','teste','TESTE','SP','02451-000','390','172 B');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Washington Luís, Centro - São Paulo - SP','teste','TESTE','SP','01033-010','98','Apto 1505');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Bagé, Vila Mariana - São Paulo - SP','teste','TESTE','SP','04012-140','139','apto 183');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Alberto Hinoto Bento, Macedo - Guarulhos - SP','teste','TESTE','SP','07197-140','148','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Othon B . Melo, Maria Amália - Curvelo - MG','teste','TESTE','SP','35790-000','292','301');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Bagé, Vila Mariana - São Paulo - SP','teste','TESTE','SP','04012-140','230','33C');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maestro Eugênio Pereira, Campo Velho - Floriano - PI','teste','TESTE','SP','64808-480','1725','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Eurípedes Aurélio da Silva, Vila Eunice Nova - Cachoeirinha - RS','teste','TESTE','SP','94920-250','71','Apt 404');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Nossa Senhora da Conceição, Pici - Fortaleza - CE','teste','TESTE','SP','60442-740','150','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Sargento Benevides Monte, Pavuna - Rio de Janeiro - RJ','teste','TESTE','SP','21520-440','147','fundos casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Algarobo, Jardim Panorama (Zona Leste) - São Paulo - SP','teste','TESTE','SP','03245-030','13','Apartamento 3');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua conde Gonçalves, Condados da Lagoa - Lagoa Santa - MG','teste','TESTE','SP','33400-000','585','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Angélica, Higienópolis - São Paulo - SP','teste','TESTE','SP','01227-100','1535','apto 42');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Engenheiro Jorge Oliva, Vila Mascote - São Paulo - SP','teste','TESTE','SP','04362-060','323','ap 121');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua do Estilo Barroco, Santo Amaro - São Paulo - SP','teste','TESTE','SP','04709-011','630','apto 104');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('..., ... - ... - SP','teste','TESTE','SP','04649-000','323','apartamento 61');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Buenos Aires, Jardim das Américas - Cuiabá - MT','teste','TESTE','SP','78060-634','410','aparamento 1403');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Oscar Freire, Pinheiros - São Paulo - SP','teste','TESTE','SP','05409-010','1606','11-B');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Abrahão João, Jardim Bandeirantes - São Carlos - SP','teste','TESTE','SP','13562-150','783','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Barata Ribeiro, Bela Vista - São Paulo - SP','teste','TESTE','SP','01308-000','323','apt 12');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Augusta, Consolação - São Paulo - SP','teste','TESTE','SP','01305-100','941','AP 71');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('RUA SILVEIRA DANTAS, CENTRO - Desterro - PB','teste','TESTE','SP','58695-000','127','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Praça Franklin Roosevelt, Consolação - São Paulo - Sp','teste','TESTE','SP','1303020','234','Apt 93');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua José Leite, Caji - Lauro de Freitas - BA','teste','TESTE','SP','42722-020','260','Residencial Family Picuaia');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Ataulfo de Paiva, Leblon - Rio de Janeiro - RJ','teste','TESTE','SP','22440-033','50','bloco A2, ap 1401');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Lazinho Aureliano Martins, Nova Divinolandia - Divinolândia - SP','teste','TESTE','SP','13780-000','47','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua dos Conferentes, Pau Arcado - Campo Limpo Paulista - SP','teste','TESTE','SP','13234-622','998','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Jornalista Waldomiro Baddini Neto, Jardim Novo Horizonte - Maringá - PR','teste','TESTE','SP','87005-290','236','Apartamento 301');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Marquês de Lages, Vila Moraes - São Paulo - SP','teste','TESTE','SP','4162001','1532','Bl 19 Apt 123');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Quadra 36 BL 09 APTº 402, Parque Esplanada III - Valparaíso de Goiás - GO','teste','TESTE','SP','72876-336','402','COND. PARQUE REAL');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Angélica, Consolação - São Paulo - SP','teste','TESTE','SP','01227-200','2389','APTO 131 B');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Vigário Barreto, Graças - Recife - PE','teste','TESTE','SP','52020-140','127','Apartamento 2802');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Getúlio Vargas, Caçari - Boa Vista - RR','teste','TESTE','SP','69307-700','345','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('rua doutor luiz palmier, Barreto - Niterói - RJ','teste','TESTE','SP','24110-310','1001','bloco 3 apt 1106');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Felippo Roveri, Barcelona - São Caetano do Sul - SP','teste','TESTE','SP','09551-080','82','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Paraná, Estados - João Pessoa - PB','teste','TESTE','SP','58030-180','130','Apt 903');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Carolina Soares, Vila Diva (Zona Norte) - São Paulo - SP','teste','TESTE','SP','02554-000','623','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Miguel Tostes, Rio Branco - Porto Alegre - RS','teste','TESTE','SP','90430-061','139','ap 302');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Siqueira Campos, Copacabana - Rio de Janeiro - Select County','teste','TESTE','SP','22031071','253','303');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES(', Asa Sul - Brasília - DF','teste','TESTE','SP','70730-040','306','Apartamento');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Doutor Nei Luiz Gonzaga, Coqueiros - Florianópolis - Santa Catarina','teste','TESTE','SP','88080070','111','Ap 201');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maringá, Vila Guarani (Z Sul) - São Paulo - RJ','teste','TESTE','SP','04317-020','70','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Doutor Sampaio Ferraz, Cambuí - Campinas - SP','teste','TESTE','SP','13024-430','151','apto 192');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Garibaldi, Tijuca - Rio de Janeiro - RJ','teste','TESTE','SP','20511-330','225','aptº 1005 - bloco 2');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida João Scarparo Netto, Loteamento Center Santa Genebra - Campinas - SP','teste','TESTE','SP','13080-655','240','apto 313 bl trovadores');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('...Rua Crsitiano Stockler, ...Centro - ...Passos - MG','teste','TESTE','SP','37900-150','204','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Doutor Odon Carlos de Figueiredo Ferraz, Parque São Domingos - São Paulo - SP','teste','TESTE','SP','05121-000','877','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Tiradentes, Santa Terezinha - São Bernardo do Campo - SP','teste','TESTE','SP','09780-900','1837','...');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Via Transversal Sul, Novo Osasco - Osasco - SP','teste','TESTE','SP','06045-420','169','TORRE 5 - AP 42');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('2ª Travessa São Francisco, São Cristóvão - Salvador - BA','teste','TESTE','SP','41510-195','13','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Pablo Neruda, Carlos Guinle - Teresópolis - RJ','teste','TESTE','SP','25959-120','91','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Ministro Ferreira Alves, Perdizes - São Paulo - SP','teste','TESTE','SP','05009-060','333','APARTAMENTO 113');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Carmine Monetti, Jardim das Oliveiras - São Paulo - SP','teste','TESTE','SP','08111-160','184','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida São João, Jardim Esplanada - São José dos Campos - SP','teste','TESTE','SP','12242-840','AP 12 TORRE B','AP 12 TORRE B');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maria José Leal, Granville - Juiz de Fora - MG','teste','TESTE','SP','36036-247','160','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Veneza, Iputinga - Recife - PE','teste','TESTE','SP','50800-400','125','Apartamento 101');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Berenice Rezende Diniz, Morada da Colina - Uberlândia - MG','teste','TESTE','SP','38411-162','300','35');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maniçoba, Jardim Umarizal - São Paulo - SP','teste','TESTE','SP','5756420','839','Apto 1406A');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Postal, Vila Santana - São Paulo - SP','teste','TESTE','SP','08240-120','42','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Conselheiro Antônio Prado, Jardim Taquaral - Promissão - SP','teste','TESTE','SP','16370-000','695','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Artur Bernardes, Catete - Rio de Janeiro - RJ','teste','TESTE','SP','22220-070','26','Apto 1202');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Dallas, Araçagy - São José de Ribamar - MA','teste','TESTE','SP','65110-000','4','Central Park');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('SQN 208 Bloco G, Asa Norte - Brasília - DF','teste','TESTE','SP','70853-070','104','apartamento 104');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida das Américas, Barra da Tijuca - Rio de Janeiro - RJ','teste','TESTE','SP','22631-000','1981','casa 99');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Miguel Couto, Parque São Luiz - Teresópolis - RJ','teste','TESTE','SP','25953-350','35','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Sílvio MaiaRua Silvio Maia, Vila Silveira - Guarulhos - SP','teste','TESTE','SP','07093-020','484','24');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Santa Isabel, Monte Castelo - Teixeira de Freitas - BA','teste','TESTE','SP','45990-114','820','Casa 09');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Francisco Alves Alexandre, Núcleo Residencial Bairro da Vitória - Campinas - SP','teste','TESTE','SP','13044-755','174','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('CSA 02 lote 8 Ed. Francisco Muniz, Taguatinga Sul - Brasília - DF','teste','TESTE','SP','72015-025','201','201');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Manoel Picão Júnior, Parque Industrial Lagoinha - Ribeirão Preto - SP','teste','TESTE','SP','14095-070','321','APTO 63');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Avenida Antônio Roberto, Jardim das Belezas - Carapicuíba - SP','teste','TESTE','SP','06315-270','291','Apto 13');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Angelino Rosim, Jardim Vale do Cedro - Londrina - PR','teste','TESTE','SP','86038-398','18','CASA');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Abrão Caixe, Condomínio Itamaraty - Ribeirão Preto - SP','teste','TESTE','SP','14020-630','819','Apto. 14');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua joao goncalves teixeira, Vila Carrão - SP - SP','teste','TESTE','SP','03447-040','2','13');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('..., ... - ... - SP','teste','TESTE','SP','03447-040','2','Vila Carrão');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Abadia dos Dourados, Vila Indiana - São Paulo - SP','teste','TESTE','SP','05586-030','Apt 07','Apt 07');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('..., ... - ... - SP','teste','TESTE','SP','05585-020','75','apt');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Abadia dos Dourados, Vila Indiana - São Paulo - SP','teste','TESTE','SP','05586-030','Apt 07','Apt 07');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Doutor Alfredo Weyne, Fátima - Fortaleza - CE','teste','TESTE','SP','60415-065','55','Apto 301 A');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua David Ben Gurion, Jardim Monte Kemel - São Paulo - SP','teste','TESTE','SP','05634-001','apto 191 Torre 5','955');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Cananéia, Vila Príncipe de Gales - Santo André - SP','teste','TESTE','SP','09060-480','168','apto 41 Ed Amazonas');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Nicola Laurito, Cecap 3 - Limeira - B','teste','TESTE','SP','13481334','60','Casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Lauro Linhares, Trindade - Florianópolis - SC','teste','TESTE','SP','88036-002','1288','105B3');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Maxwell, Vila Isabel - Rio de Janeiro - RJ','teste','TESTE','SP','20541-100','90','AP 201');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Engenheiro Godofredo dos Santos, Estoril - Belo Horizonte - MG','teste','TESTE','SP','30494-220','24','Bloco 07 - apto 403');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('rua luciano batista, vila saul - Santa Cruz do Rio Pardo - SP','teste','TESTE','SP','18900-000','97','casa');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua do Albatroz, Imbuí - Salvador - BA','teste','TESTE','SP','41720-420','128','Apto. 603');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('CA 5, Setor de Habitações Individuais Norte - Brasília - DF','teste','TESTE','SP','71503-505','5','Lote F, APTO 19');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Independência, Setor Presidente Kennedy - Luziânia - GO','teste','TESTE','SP','72810-570','172','Quadra 14');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Altamiro Di Bernardi, Campinas - São José - SC','teste','TESTE','SP','88101-150','662','APTO 102');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua dos Timbiras, Santo Agostinho - Belo Horizonte - MG','teste','TESTE','SP','30140-903','2500','APTO 1708');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Dona Alice Tibiriçá, Bigorrilho - Curitiba - PR','teste','TESTE','SP','80730-320','455','606');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua José Theodoro Ribeiro, Ilha da Figueira - Jaraguá do Sul - SC','teste','TESTE','SP','89258-000','785','');
INSERT INTO ADDRESS(formatedAddress,address,neighborhood,state,zipcode,number,complement) VALUES('Rua Senador Pompeu, José Bonifácio - Fortaleza - CE','teste','TESTE','SP','60025-001','2420','Apto 803');
INSERT INTO HOSPITAL("addressId",name) VALUES('1','HOSPITAL ALBERT EINSTEIN');
INSERT INTO HOSPITAL("addressId",name) VALUES('2','HOSPITAL ALBERT SABIN | UNIDADE IMIRIM');
INSERT INTO HOSPITAL("addressId",name) VALUES('3','HOSPITAL ALBERT SABIN | UNIDADE LAPA');
INSERT INTO HOSPITAL("addressId",name) VALUES('4','HOSPITAL ALVORADA CHÁCARA FLORA');
INSERT INTO HOSPITAL("addressId",name) VALUES('5','HOSPITAL ALVORADA MOEMA');
INSERT INTO HOSPITAL("addressId",name) VALUES('6','HOSPITAL ALVORADA SANTO AMARO');
INSERT INTO HOSPITAL("addressId",name) VALUES('7','HOSPITAL ASSUNÇÃO');
INSERT INTO HOSPITAL("addressId",name) VALUES('8','HOSPITAL AVICCENA');
INSERT INTO HOSPITAL("addressId",name) VALUES('9','HOSPITAL BANDEIRANTES');
INSERT INTO HOSPITAL("addressId",name) VALUES('10','HOSPITAL BENEFICÊNCIA PORTUGUESA SP');
INSERT INTO HOSPITAL("addressId",name) VALUES('11','HOSPITAL BOM CLIMA');
INSERT INTO HOSPITAL("addressId",name) VALUES('12','HOSPITAL BRASIL');
INSERT INTO HOSPITAL("addressId",name) VALUES('13','CASA DE SAÚDE DOM PEDRO II (SANTA MAGGIORE)');
INSERT INTO HOSPITAL("addressId",name) VALUES('14','HOSPITAL CEMA');
INSERT INTO HOSPITAL("addressId",name) VALUES('15','HOSPITAL CENTRAL');
INSERT INTO HOSPITAL("addressId",name) VALUES('16','HOSPITAL CENTRAL DE GUAIANAZES');
INSERT INTO HOSPITAL("addressId",name) VALUES('17','HOSPITAL CRUZ AZUL');
INSERT INTO HOSPITAL("addressId",name) VALUES('18','HOSPITAL CRUZ VERMELHA');
INSERT INTO HOSPITAL("addressId",name) VALUES('19','HOSPITAL DANTE PAZZANESE');
INSERT INTO HOSPITAL("addressId",name) VALUES('20','HOSPITAL DAS CLÍNICAS FMUSP');
INSERT INTO HOSPITAL("addressId",name) VALUES('21','HOSPITAL DAY HOSPITAL ERMELINO MATARAZZO');
INSERT INTO HOSPITAL("addressId",name) VALUES('22','HOSPITAL DEFEITOS DA FACE');
INSERT INTO HOSPITAL("addressId",name) VALUES('23','HOSPITAL DO CORAÇÃO');
INSERT INTO HOSPITAL("addressId",name) VALUES('24','HOSPITAL EDMUNDO VASCONCELOS');
INSERT INTO HOSPITAL("addressId",name) VALUES('25','HOSPITAL GUARULHOS');
INSERT INTO HOSPITAL("addressId",name) VALUES('26','HOSPITAL IGESP');
INSERT INTO HOSPITAL("addressId",name) VALUES('27','HOSPITAL IGUATEMI (ATUAL METROPOLITANO)');
INSERT INTO HOSPITAL("addressId",name) VALUES('28','HOSPITAL INCOR – INSTITUTO DO CORAÇÃO');
INSERT INTO HOSPITAL("addressId",name) VALUES('29','HOSPITAL INDEPENDÊNCIA');
INSERT INTO HOSPITAL("addressId",name) VALUES('30','HOSPITAL INSTITUTO DA CRIANÇA FMM');
INSERT INTO HOSPITAL("addressId",name) VALUES('31','HOSPITAL ITAQUERA');
INSERT INTO HOSPITAL("addressId",name) VALUES('32','HOSPITAL JARDINS');
INSERT INTO HOSPITAL("addressId",name) VALUES('33','HOSPITAL LEFORTE');
INSERT INTO HOSPITAL("addressId",name) VALUES('34','HOSPITAL MARIA JOSÉ');
INSERT INTO HOSPITAL("addressId",name) VALUES('35','HOSPITAL METROPOLITANO');
INSERT INTO HOSPITAL("addressId",name) VALUES('36','HOSPITAL MONTREAL');
INSERT INTO HOSPITAL("addressId",name) VALUES('37','HOSPITAL MUNICIPAL DO TATUAPÉ');
INSERT INTO HOSPITAL("addressId",name) VALUES('38','HOSPITAL NIPO BRASILEIRO');
INSERT INTO HOSPITAL("addressId",name) VALUES('39','HOSPITAL NOSSA SENHORA DE FÁTIMA');
INSERT INTO HOSPITAL("addressId",name) VALUES('40','HOSPITAL NOSSA SENHORA DO PARI');
INSERT INTO HOSPITAL("addressId",name) VALUES('41','HOSPITAL NOVE DE JULHO');
INSERT INTO HOSPITAL("addressId",name) VALUES('42','HOSPITAL OSWALDO CRUZ');
INSERT INTO HOSPITAL("addressId",name) VALUES('43','HOSPITAL PAULISTA');
INSERT INTO HOSPITAL("addressId",name) VALUES('44','HOSPITAL PLENA SAÚDE SERVIÇOS MÉDICOS');
INSERT INTO HOSPITAL("addressId",name) VALUES('45','HOSPITAL PORTINARI');
INSERT INTO HOSPITAL("addressId",name) VALUES('46','HOSPITAL PRESIDENTE');
INSERT INTO HOSPITAL("addressId",name) VALUES('47','HOSPITAL PRO MATRE PAULISTA');
INSERT INTO HOSPITAL("addressId",name) VALUES('48','HOSPITAL PRONTO BABY PS INFANTIL');
INSERT INTO HOSPITAL("addressId",name) VALUES('49','HOSPITAL RUBEN BERTA');
INSERT INTO HOSPITAL("addressId",name) VALUES('50','HOSPITAL SALVALUS');
INSERT INTO HOSPITAL("addressId",name) VALUES('51','HOSPITAL SAMARITANO');
INSERT INTO HOSPITAL("addressId",name) VALUES('52','HOSPITAL SAMARO');
INSERT INTO HOSPITAL("addressId",name) VALUES('53','HOSPITAL SANTA CASA DE MISERICÓRDIA SP');
INSERT INTO HOSPITAL("addressId",name) VALUES('54','HOSPITAL SANTA CATARINA');
INSERT INTO HOSPITAL("addressId",name) VALUES('55','HOSPITAL SANTA CRUZ');
INSERT INTO HOSPITAL("addressId",name) VALUES('56','HOSPITAL SANTA HELENA');
INSERT INTO HOSPITAL("addressId",name) VALUES('57','HOSPITAL SANTA ISABEL');
INSERT INTO HOSPITAL("addressId",name) VALUES('58','HOSPITAL SANTA JOANA');
INSERT INTO HOSPITAL("addressId",name) VALUES('59','HOSPITAL SANTA MARCELINA');
INSERT INTO HOSPITAL("addressId",name) VALUES('60','HOSPITAL SANTA MARINA');
INSERT INTO HOSPITAL("addressId",name) VALUES('61','HOSPITAL SANTA PAULA');
INSERT INTO HOSPITAL("addressId",name) VALUES('62','HOSPITAL SANTA RITA');
INSERT INTO HOSPITAL("addressId",name) VALUES('63','HOSPITAL SANTA VIRGINIA');
INSERT INTO HOSPITAL("addressId",name) VALUES('64','HOSPITAL SANTO AMARO');
INSERT INTO HOSPITAL("addressId",name) VALUES('65','HOSPITAL SANTO EXPEDITO');
INSERT INTO HOSPITAL("addressId",name) VALUES('66','HOSPITAL SÃO BERNARDO');
INSERT INTO HOSPITAL("addressId",name) VALUES('67','HOSPITAL SÃO CAMILO |UNIDADE IPIRANGA');
INSERT INTO HOSPITAL("addressId",name) VALUES('68','HOSPITAL SÃO CAMILO |UNIDADE POMPÉIA');
INSERT INTO HOSPITAL("addressId",name) VALUES('69','HOSPITAL SÃO CAMILO |UNIDADE SANTANA');
INSERT INTO HOSPITAL("addressId",name) VALUES('70','HOSPITAL SÃO CRISTÓVÃO');
INSERT INTO HOSPITAL("addressId",name) VALUES('71','HOSPITAL SÃO LUCAS');
INSERT INTO HOSPITAL("addressId",name) VALUES('72','HOSPITAL SÃO MIGUEL');
INSERT INTO HOSPITAL("addressId",name) VALUES('73','HOSPITAL SÃO PAULO');
INSERT INTO HOSPITAL("addressId",name) VALUES('74','HOSPITAL SÃO PEDRO');
INSERT INTO HOSPITAL("addressId",name) VALUES('75','HOSPITAL SEPACO');
INSERT INTO HOSPITAL("addressId",name) VALUES('76','HOSPITAL SERVIDOR PÚBLICO ESTADUAL');
INSERT INTO HOSPITAL("addressId",name) VALUES('77','HOSPITAL SERVIDOR PÚBLICO MUNICIPAL');
INSERT INTO HOSPITAL("addressId",name) VALUES('78','HOSPITAL SINO BRASILEIRO');
INSERT INTO HOSPITAL("addressId",name) VALUES('79','HOSPITAL SÍRIO LIBANÊS');
INSERT INTO HOSPITAL("addressId",name) VALUES('80','HOSPITAL STELLA MARIS');
INSERT INTO HOSPITAL("addressId",name) VALUES('81','HOSPITAL UNIVERSITÁRIO – USP');
INSERT INTO HOSPITAL("addressId",name) VALUES('82','HOSPITAL VIDAS');
INSERT INTO HOSPITAL("addressId",name) VALUES('83','HOSPITAL VILA IOLANDA');
INSERT INTO HOSPITAL("addressId",name) VALUES('84','HOSPITAL VOLUNTÁRIOS (ATUAL SÃO PAOLO)');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Alice','Alice','Alice26194@gmail.com','chuhcd1p25a2p6rghmk08f','1971-09-18','348640','140.557.377-50','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Miguel','Miguel','Miguel27954@gmail.com','lwrx5kca1tdbizbqfski9','1976-07-13','53454','405.308.934-44','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Sophia','Sophia','Sophia26538@gmail.com','t4m6bvz8kmhvnj3z043grs','1972-08-27','875320','720.531.464-00','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Arthur','Arthur','Arthur20958@gmail.com','wr7dnu3fgfhk7ustw1pgga','1957-05-18','424910','484.258.702-40','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Helena','Helena','Helena14067@gmail.com','aery3l498qrwn7gbbzc8q','1938-07-06','37598','812.761.164-62','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Bernardo','Bernardo','Bernardo23413@gmail.com','kjsk8juej5eoxs1ats6l9','1964-02-06','526493','815.125.909-40','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Valentina','Valentina','Valentina27211@gmail.com','2p4z6en0kumgk88vrwd3','1974-07-01','484310','563.256.666-82','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Heitor','Heitor','Heitor16995@gmail.com','nga7w73u28hybvpogxp4gc','1946-07-12','159528','211.124.266-71','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Laura','Laura','Laura12670@gmail.com','nuxseu2qwxf0h4xifnv77am','1934-09-08','766769','262.837.392-02','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Davi','Davi','Davi16844@gmail.com','k9hmhzgxpjji3nicdbaw5o','1946-02-11','466334','642.772.938-16','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Isabella','Isabella','Isabella18057@gmail.com','m63soevt7iidjz1fn0upgh','1949-06-08','88664','080.761.633-82','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Lorenzo','Lorenzo','Lorenzo17940@gmail.com','hyk91r8546clyir8dkk419','1949-02-11','597810','642.633.417-08','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Manuela','Manuela','Manuela24859@gmail.com','dwm7nv4h3abxhowvlpzxb','1968-01-22','89255','781.731.357-11','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Théo','Théo','Théo14826@gmail.com','2whbzeppehgbo4htxzevvr','1940-08-03','94572','362.953.134-26','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Júlia','Júlia','Júlia14688@gmail.com','3g375mursq6isoxzon6b9m','1940-03-18','179418','297.235.416-88','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Pedro','Pedro','Pedro13517@gmail.com','h6l2zprawxugjtitr3pt2g','1937-01-02','981681','867.966.120-19','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Heloísa','Heloísa','Heloísa19226@gmail.com','31jqy0b1ms6z1xzl66sxua','1952-08-20','601311','512.781.655-50','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Gabriel','Gabriel','Gabriel12664@gmail.com','1vfhloe3ywyw2nquvf0rq7','1934-09-02','672117','989.431.933-51','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Luiza','Luiza','Luiza30195@gmail.com','dba0vo46xrdn827h0d5k','1982-09-01','271583','814.647.659-79','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Enzo','Enzo','Enzo31981@gmail.com','p5o6v310xpokvc0asqphdd','1987-07-23','307326','436.170.796-01','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Luiza','Maria Luiza','Maria Luiza30655@gmail.com','tbaizl9jb56fx6u8qjg6c','1983-12-05','867198','537.835.962-70','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Matheus','Matheus','Matheus33331@gmail.com','d93usr4bygxsrzulemsfk','1991-04-03','208380','603.161.288-72','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Lorena','Lorena','Lorena18664@gmail.com','orygdjjbtf1xt55omxlyi','1951-02-05','561366','625.598.752-33','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Lucas','Lucas','Lucas27641@gmail.com','2rj484cogcrcat9xcgk0x9','1975-09-04','416446','483.577.867-74','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Lívia','Lívia','Lívia20671@gmail.com','pdsnt50twzcd0jmhk5nk3g','1956-08-04','27179','898.373.127-34','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Benjamin','Benjamin','Benjamin33942@gmail.com','1of1sbhf8loi57qdao6mvt','1992-12-04','926957','344.045.864-42','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Giovanna','Giovanna','Giovanna20285@gmail.com','jz1yjv49qko1tmg14uuzi','1955-07-15','43979','512.361.231-90','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Nicolas','Nicolas','Nicolas32011@gmail.com','pb3x5v88s3nzzexclme8n7','1987-08-22','203337','888.618.348-84','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Eduarda','Maria Eduarda','Maria Eduarda25738@gmail.com','x64g5l6pjvmaa9nabpmxuw','1970-06-19','471538','125.706.352-94','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Guilherme','Guilherme','Guilherme26605@gmail.com','h9q9z7xywz60c87jbkg5kho','1972-11-02','668471','995.299.309-92','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Beatriz','Beatriz','Beatriz14198@gmail.com','51b2atmh0ayfn2t5gyh2ap','1938-11-14','548838','646.346.366-38','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Rafael','Rafael','Rafael25502@gmail.com','k7qniub5ceg6xxun9vwgi2','1969-10-26','567257','261.012.444-90','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Clara','Maria Clara','Maria Clara18551@gmail.com','1o57esi8deszgw8wdsu2gk','1950-10-15','58668','818.778.697-32','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Joaquim','Joaquim','Joaquim33002@gmail.com','8rcvat29jcw1l7p9swetrd','1990-05-09','16264','609.719.152-96','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Cecília','Cecília','Cecília19534@gmail.com','8qiimb3sb030axk7vndvz8q','1953-06-24','157976','552.979.806-31','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Samuel','Samuel','Samuel26525@gmail.com','4jy8kz3jptf6uyxslq527s','1972-08-14','85668','653.479.637-60','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Eloá','Eloá','Eloá16105@gmail.com','50v0dqcze24g6wqyfg4sl','1944-02-03','476954','225.290.329-55','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Enzo Gabriel','Enzo Gabriel','Enzo Gabriel29047@gmail.com','7dlculph1xdb2pspf85fbv','1979-07-11','62879','469.046.142-26','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Lara','Lara','Lara13624@gmail.com','yqclsfv4lfi79611oezosu','1937-04-19','526163','292.553.646-85','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('João Miguel','João Miguel','João Miguel28162@gmail.com','p19idxwcfdkp3lbue3ghcr','1977-02-06','644356','557.813.349-55','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Júlia','Maria Júlia','Maria Júlia30882@gmail.com','tod2isz2zpsnqc4ximqav','1984-07-19','259064','702.174.286-06','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Henrique','Henrique','Henrique19014@gmail.com','mto1eu6pjwt4a19s7iji1v','1952-01-21','765275','053.417.111-73','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Isadora','Isadora','Isadora30093@gmail.com','eple43ulmn6mpnienuutk','1982-05-22','237851','677.538.250-20','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Gustavo','Gustavo','Gustavo24834@gmail.com','q2qrrzt4wfnfq3m46yyln8','1967-12-28','813496','536.273.786-44','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Mariana','Mariana','Mariana32588@gmail.com','dg8x4qsfucoupf4uevcxrs','1989-03-21','637292','733.372.713-08','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Murilo','Murilo','Murilo28079@gmail.com','xo290vl2j8wjwxhbyqsui','1976-11-15','233948','791.742.833-83','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Emanuelly','Emanuelly','Emanuelly21857@gmail.com','zymdtdw8hhh0bnkrl1hw','1959-11-03','294152','149.368.618-63','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Pedro Henrique','Pedro Henrique','Pedro Henrique16011@gmail.com','yd3w1e1k8svd1rv0ts8qh','1943-11-01','931380','806.264.337-97','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana Júlia','Ana Júlia','Ana Júlia24212@gmail.com','pziim6q3imqmr5rivtb2','1966-04-15','32103','388.889.826-98','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Pietro','Pietro','Pietro14379@gmail.com','oifh0zjqghid3patwbt4p','1939-05-14','60405','968.392.442-53','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana Luiza','Ana Luiza','Ana Luiza31885@gmail.com','zej3ebe71zjh8ahpuiceu','1987-04-18','32879','464.958.384-50','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Lucca','Lucca','Lucca30353@gmail.com','3ix4zt0hmcopcu3yls4hna','1983-02-06','816128','168.362.525-06','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana Clara','Ana Clara','Ana Clara27754@gmail.com','hi9owuvp5lw0tfckf8r6o09','1975-12-26','166390','272.380.643-08','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Felipe','Felipe','Felipe28599@gmail.com','jufxx5vj3fn5yb8qjl4lkm','1978-04-19','218463','862.574.629-24','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Melissa','Melissa','Melissa15087@gmail.com','i589to6rxeb0d7yzlnlmx5g','1941-04-21','683683','656.771.722-00','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('João Pedro','João Pedro','João Pedro19419@gmail.com','2ik9gmt4sxfm0kol5ln4tj','1953-03-01','631063','546.372.835-66','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Yasmin','Yasmin','Yasmin17585@gmail.com','xz1q16tu8bcdn5kqxbjys','1948-02-22','679630','858.852.254-35','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Isaac','Isaac','Isaac22151@gmail.com','e2cncmt3b4f2azxq4m1v8p','1960-08-23','831588','354.514.312-05','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Alice','Maria Alice','Maria Alice18290@gmail.com','zc5niiilywa4kr4gzdi82g','1950-01-27','434791','063.248.696-10','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Benício','Benício','Benício22181@gmail.com','zxdzezecia86l4c9tcy4x','1960-09-22','819529','732.363.412-11','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Isabelly','Isabelly','Isabelly17419@gmail.com','a0kvabp3jxd5t0ce31o0w2','1947-09-09','75955','587.867.473-47','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Daniel','Daniel','Daniel29908@gmail.com','gmvg3kon3e48xfy2xgicc','1981-11-18','142224','543.885.343-66','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Lavínia','Lavínia','Lavínia29144@gmail.com','ud33oyfzj2wmv8qfhagj','1979-10-16','101732','826.424.147-60','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Anthony','Anthony','Anthony25900@gmail.com','cye6hv35uiode02ceiwbh','1970-11-28','362275','013.489.486-39','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Esther','Esther','Esther27248@gmail.com','9pjisckaapsa0upjjxcae7','1974-08-07','539070','081.832.168-70','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Leonardo','Leonardo','Leonardo16873@gmail.com','otylnyuhpn8g80em4x4fm','1946-03-12','129394','414.356.644-34','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Sarah','Sarah','Sarah17427@gmail.com','y6u61csq5tcwdua5eura6','1947-09-17','38138','472.214.012-09','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Davi Lucca','Davi Lucca','Davi Lucca33159@gmail.com','s1gxk9nawykxzw06pb7qm','1990-10-13','743583','011.918.113-44','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Elisa','Elisa','Elisa15010@gmail.com','oj6go5mmn94ap1jtt4gtz','1941-02-03','979676','150.004.417-29','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Bryan','Bryan','Bryan24487@gmail.com','8jrgnir6c9rwqeuux6qf3q','1967-01-15','827313','598.268.756-19','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Antonella','Antonella','Antonella26785@gmail.com','7ki8empinj7pnmcjtgelf','1973-05-01','559589','113.848.463-60','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Eduardo','Eduardo','Eduardo21454@gmail.com','v2p1oow3zs0qg09vwmaih','1958-09-26','671448','522.301.684-01','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Rafaela','Rafaela','Rafaela30304@gmail.com','ok7l6cibirat71rbk1m7k','1982-12-19','213280','612.888.886-00','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('João Lucas','João Lucas','João Lucas28655@gmail.com','hoirhpgcrclgnk8tz478tk','1978-06-14','218787','601.734.015-89','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Cecília','Maria Cecília','Maria Cecília15266@gmail.com','r3ja01gee2t6a0jqx4myr','1941-10-17','991312','588.005.789-50','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Victor','Victor','Victor15486@gmail.com','pzwunu15ld7xpitblz0vs','1942-05-25','351370','651.667.611-97','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Liz','Liz','Liz16529@gmail.com','rhhx1f5ulhbbx9ouzvdd','1945-04-02','199176','554.883.661-72','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('João','João','João22616@gmail.com','7ubmkwdd4zfppad4dx9or','1961-12-01','144251','177.162.342-00','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Marina','Marina','Marina13142@gmail.com','ny6gwsltifrqhv6vwb7g9','1935-12-24','491239','530.282.533-30','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Cauã','Cauã','Cauã18125@gmail.com','i1chzxg1krx7smoptwpig','1949-08-15','112548','468.107.427-60','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Nicole','Nicole','Nicole24648@gmail.com','33v07gd2oq9ws8fqdrtt1o','1967-06-25','989591','243.237.726-53','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Antônio','Antônio','Antônio22203@gmail.com','oyrpxmqluxb4xgywtewc','1960-10-14','486666','106.720.450-44','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maitê','Maitê','Maitê13842@gmail.com','149k76i00uczh63mgzs41','1937-11-23','94669','627.136.129-34','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Vicente','Vicente','Vicente31256@gmail.com','d87mt07iqq9jmw8piwfn3o','1985-07-28','62272','135.373.514-10','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Isis','Isis','Isis33182@gmail.com','imm26lsql8scglen7gbeyi','1990-11-05','353466','701.277.453-35','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Caleb','Caleb','Caleb19920@gmail.com','27azyzonxm4d89qiuyqjwq','1954-07-15','777456','217.233.346-85','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Alícia','Alícia','Alícia17200@gmail.com','i2uofmg0inqu69ykyuilh','1947-02-02','582922','510.047.782-28','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Gael','Gael','Gael22754@gmail.com','4ca4rj9jejfcubfdlusu0q','1962-04-18','459855','049.789.088-76','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Luna','Luna','Luna16727@gmail.com','7d7tocn4b3n6vhw78b7fa','1945-10-17','4263','717.077.242-61','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Bento','Bento','Bento21502@gmail.com','71g2mguvd0ekfv5ppm4ws','1958-11-13','94199','804.267.686-71','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Rebeca','Rebeca','Rebeca20711@gmail.com','1ret8xz99bkjl7r8pmk4d','1956-09-13','247143','818.591.489-30','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Caio','Caio','Caio22416@gmail.com','5ms1gtxtycmetpmqa4gmyg','1961-05-15','494514','066.875.372-29','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Agatha','Agatha','Agatha18966@gmail.com','01ufz9c9s3nuvuf5hp6ejj','1951-12-04','257928','736.528.874-41','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Emanuel','Emanuel','Emanuel15811@gmail.com','y5pls5dw9d9t91zuk2fno','1943-04-15','355258','225.623.741-93','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Letícia','Letícia','Letícia25318@gmail.com','x2512rrcgigb43z21pjik','1969-04-25','858970','226.741.197-05','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Vinícius','Vinícius','Vinícius14109@gmail.com','m3z2ijmmtdlc78nfua1ej','1938-08-17','144441','002.715.261-81','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria-','Maria-','Maria-33061@gmail.com','3fbpxr0xzb7ss6cexrlzad','1990-07-07','54281','447.831.211-76','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('João Guilherme','João Guilherme','João Guilherme19630@gmail.com','a36vs2d8q6dmt2mkadgrhr','1953-09-28','38443','651.111.509-78','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Gabriela','Gabriela','Gabriela33476@gmail.com','7gmt23vst7nku7ut5cwc9l','1991-08-26','58168','566.712.524-24','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Davi Lucas','Davi Lucas','Davi Lucas30510@gmail.com','z6bl52o45msyzmiio1cneb','1983-07-13','873926','931.801.144-01','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana Laura','Ana Laura','Ana Laura33169@gmail.com','vsbdb27hsni5gl2woqyj3','1990-10-23','544523','193.586.616-82','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Noah','Noah','Noah34139@gmail.com','tnewsw694pqsf1q987xqb','1993-06-19','314837','497.213.125-09','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Catarina','Catarina','Catarina21990@gmail.com','mi9f5fmtr5iw4ll81pabd','1960-03-15','73692','812.357.817-20','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('João Gabriel','João Gabriel','João Gabriel12957@gmail.com','hyu2d9ujiodk9dxg21edug','1935-06-22','30585','234.912.611-04','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Clara','Clara','Clara29946@gmail.com','lmc002q5lbkrc9q6eaq03','1981-12-26','56789','287.287.854-87','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('João Victor','João Victor','João Victor20807@gmail.com','8tg1swftgdystm1qtvze1','1956-12-18','946121','912.588.291-00','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana Beatriz','Ana Beatriz','Ana Beatriz33569@gmail.com','zhb8kgsld8h4lkw8jeifnm','1991-11-27','624896','894.892.575-08','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Luiz Miguel','Luiz Miguel','Luiz Miguel20212@gmail.com','mzlcm52ot0nxetjv2pvvg','1955-05-03','828462','345.422.248-64','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Vitória','Vitória','Vitória25662@gmail.com','qpc5i1eszbpsycwie72vl','1970-04-04','149742','122.357.817-80','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Francisco','Francisco','Francisco23045@gmail.com','f7hn0or03zm0l8yn5prk5ll','1963-02-03','149912','703.412.772-74','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Olívia','Olívia','Olívia25758@gmail.com','ss9khtl1tdouef5c9zii6','1970-07-09','98118','549.327.351-97','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Kaique','Kaique','Kaique24679@gmail.com','yo8hrk5wl4gpxk0hemnx1p','1967-07-26','883583','444.674.228-03','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Fernanda','Maria Fernanda','Maria Fernanda23177@gmail.com','mez3q1ydntjf64842z4pi','1963-06-15','649585','624.182.285-33','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Otávio','Otávio','Otávio13140@gmail.com','yquedwrs81ychr3oleva','1935-12-22','699441','529.265.980-09','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Emilly','Emilly','Emilly23273@gmail.com','f89arbkpitw3d9buxqhe','1963-09-19','866596','980.852.177-08','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Augusto','Augusto','Augusto19556@gmail.com','qxmjrd8q8oq2lgamuttmc','1953-07-16','516679','342.266.588-92','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Valentina','Maria Valentina','Maria Valentina18366@gmail.com','2ke18o2436jj746d0nb3ok','1950-04-13','461527','682.570.558-08','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Levi','Levi','Levi23674@gmail.com','vzvynxpxjjmahqgyoiy509','1964-10-24','671542','827.398.274-23','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Milena','Milena','Milena20945@gmail.com','l84zwlgfx2vkoxoh4ymvd','1957-05-05','842584','065.446.846-00','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Yuri','Yuri','Yuri20482@gmail.com','cctvjz0coxefujyl4bndfr','1956-01-28','823696','740.638.213-82','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Helena','Maria Helena','Maria Helena12829@gmail.com','ltpf6oh9tg9hpjmppn419','1935-02-14','132425','746.191.080-90','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Enrico','Enrico','Enrico16540@gmail.com','io3656qdcbvpsjo1ascha','1945-04-13','713322','873.518.584-89','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Bianca','Bianca','Bianca32953@gmail.com','4wdf5g9p4bk1524nwhq0d3','1990-03-21','55692','454.110.347-87','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Thiago','Thiago','Thiago22366@gmail.com','ejcvwuxsyawenynmcfbhh','1961-03-26','302721','169.883.315-65','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Larissa','Larissa','Larissa27857@gmail.com','nsa4i0xz1a142qm70y5e3f','1976-04-07','668028','286.530.785-92','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ian','Ian','Ian14392@gmail.com','9t0vt2we34eecel9x7c05q','1939-05-27','654916','295.157.342-15','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Mirella','Mirella','Mirella15864@gmail.com','4gd9exi5kjx817xlv9x1','1943-06-07','968165','229.242.660-92','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Victor Hugo','Victor Hugo','Victor Hugo16784@gmail.com','toxflns6zekevwv2e7op6','1945-12-13','273890','665.836.473-70','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Flor','Maria Flor','Maria Flor17798@gmail.com','bwmaktjrbq6kos0ea5jfy','1948-09-22','51195','662.518.434-97','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Thomas','Thomas','Thomas14239@gmail.com','k4a59b43s4bfjyrekckken','1938-12-25','524192','077.158.926-37','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Allana','Allana','Allana12985@gmail.com','31zqpv6evpz43ne3uap5rn','1935-07-20','89374','217.309.177-80','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Henry','Henry','Henry14819@gmail.com','0muwm0z7wltmkvhejel7ssj','1940-07-27','569125','279.224.748-73','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana Sophia','Ana Sophia','Ana Sophia28293@gmail.com','feb9ok64dkozcu2rm93fbe','1977-06-17','732150','196.085.092-03','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Luiz Felipe','Luiz Felipe','Luiz Felipe13937@gmail.com','ysxus2qqagj8fgnjkykqa','1938-02-26','108063','580.112.134-07','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Clarice','Clarice','Clarice21302@gmail.com','duwjhvd79klnwx90ql1d7','1958-04-27','854584','482.583.798-01','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ryan','Ryan','Ryan26470@gmail.com','fd7808wgw07qowjkzfpvms','1972-06-20','462098','682.457.234-95','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Pietra','Pietra','Pietra29470@gmail.com','4f39s94giemv0tle6k6bda','1980-09-06','552992','837.323.504-36','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Arthur Miguel','Arthur Miguel','Arthur Miguel28926@gmail.com','7lmbnzox96tkw2erlr10z','1979-03-12','99043','427.175.886-80','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Vitória','Maria Vitória','Maria Vitória23967@gmail.com','e5638wl7k9j3vh8jf3qsk','1965-08-13','26478','576.221.154-10','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Davi Luiz','Davi Luiz','Davi Luiz21617@gmail.com','qpbndoc4gl1aim7964ejs','1959-03-08','625889','187.328.331-80','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maya','Maya','Maya20018@gmail.com','bz2i9e945hjkkl9l8zpmef','1954-10-21','105237','313.667.355-79','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Nathan','Nathan','Nathan15162@gmail.com','j4gjwgtybqhxlsgz79dz9o','1941-07-05','715512','788.544.148-24','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Laís','Laís','Laís17711@gmail.com','39qwcinm4dmai91j72ci57','1948-06-27','514598','382.557.811-96','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Pedro Lucas','Pedro Lucas','Pedro Lucas28311@gmail.com','tj47tlqnlvlgff0i27pm','1977-07-05','411273','065.508.348-05','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ayla','Ayla','Ayla26976@gmail.com','rvosx9p3428sd1eumjzlkd','1973-11-08','563016','744.117.282-90','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Davi Miguel','Davi Miguel','Davi Miguel23361@gmail.com','u80ce4wh0xk2mzlmq9x9hf','1963-12-16','479649','716.233.259-51','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana Lívia','Ana Lívia','Ana Lívia33029@gmail.com','8arapb8wpc7saebe5243ze','1990-06-05','309462','866.216.219-30','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Raul','Raul','Raul21860@gmail.com','4g0o9utd7lmye2ngfbx54m','1959-11-06','22579','372.465.655-66','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Eduarda','Eduarda','Eduarda32569@gmail.com','0refm6wlm2bmpnxbk0gy2d','1989-03-02','954296','138.552.675-02','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Pedro Miguel','Pedro Miguel','Pedro Miguel31828@gmail.com','r1xxf7z6yo9t8l8jgm6l0o','1987-02-20','302019','660.513.045-68','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Mariah','Mariah','Mariah18660@gmail.com','dxmu2d8vdbjvkv54ed5o','1951-02-01','351787','614.156.233-76','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Luiz Henrique','Luiz Henrique','Luiz Henrique22619@gmail.com','3hrcn3wigtag9k2rc76u4v','1961-12-04','121459','036.857.575-63','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Stella','Stella','Stella16231@gmail.com','yt6cq2ow2el7scdj4sq7rx','1944-06-08','262420','606.571.808-40','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Luan','Luan','Luan31192@gmail.com','em2j77spwrll66odoc4iqd','1985-05-25','394577','975.772.241-38','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana','Ana','Ana28430@gmail.com','ee618ywth15z0cdp5otlo','1977-11-01','721655','021.293.841-02','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Erick','Erick','Erick20826@gmail.com','gl5c8z8unf4mw9d0z2qv8','1957-01-06','484030','855.945.505-18','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Gabrielly','Gabrielly','Gabrielly22760@gmail.com','8fwcsrydx2he7vudgh9srb','1962-04-24','443767','352.645.985-17','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Martin','Martin','Martin20953@gmail.com','pfotsv6g9gbfiobrlxh8l','1957-05-13','717552','401.990.460-00','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Sophie','Sophie','Sophie30232@gmail.com','cn6pm2funfod9h37klxtck','1982-10-08','152479','357.274.496-26','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Bruno','Bruno','Bruno13214@gmail.com','nn2d93avtc1oc4y45oiz4','1936-03-05','83115','760.683.544-66','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Carolina','Carolina','Carolina18285@gmail.com','z0o1mgwjl3kyr3wbfww6','1950-01-22','314692','724.777.893-84','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Rodrigo','Rodrigo','Rodrigo33000@gmail.com','ibzpaw0g7n3kkdp1o0k09','1990-05-07','745193','128.964.749-60','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Laura','Maria Laura','Maria Laura19542@gmail.com','4ifixxm0oocumxtoqzb1','1953-07-02','857082','834.071.286-14','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Luiz Gustavo','Luiz Gustavo','Luiz Gustavo30724@gmail.com','3hg8umedr9jmzjltix5ivc','1984-02-12','209229','426.323.775-79','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Heloísa','Maria Heloísa','Maria Heloísa33697@gmail.com','7fhlo040liewt0zx2ccx9','1992-04-03','76363','720.851.461-55','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Arthur Gabriel','Arthur Gabriel','Arthur Gabriel26546@gmail.com','g74f40vcwffl575xtg8suj','1972-09-04','66161','313.227.255-86','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Sophia','Maria Sophia','Maria Sophia25167@gmail.com','zvgxyfpwre4d02rbdn20y','1968-11-25','189827','349.450.787-26','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Breno','Breno','Breno33659@gmail.com','56vw6guwt93rfa2duughb','1992-02-25','742987','824.601.929-59','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Fernanda','Fernanda','Fernanda28257@gmail.com','1e3pcqodud9juksirr400z','1977-05-12','133319','316.193.181-56','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Kauê','Kauê','Kauê32752@gmail.com','6oos3e6jmt9m5krpi85bhs','1989-09-01','71575','277.271.358-01','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Malu','Malu','Malu25912@gmail.com','kkenp1wnh7qv7gik44y0p','1970-12-10','714250','955.864.833-78','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Enzo Miguel','Enzo Miguel','Enzo Miguel12624@gmail.com','no12wyspej38i85to25dn','1934-07-24','474664','124.701.445-23','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Analu','Analu','Analu24438@gmail.com','83xarxa5vukpxfwk2mw86','1966-11-27','733625','981.297.721-08','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Fernando','Fernando','Fernando14280@gmail.com','8023ejjdcui8tbbo9pwbt6','1939-02-04','919166','723.345.819-76','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Amanda','Amanda','Amanda19259@gmail.com','6qf2bfrpkyvpoowlbicr6s','1952-09-22','719536','007.467.145-64','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Arthur Henrique','Arthur Henrique','Arthur Henrique23817@gmail.com','qnc3j7p4pqokqzmsl3yl7r','1965-03-16','5897','756.159.696-01','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Aurora','Aurora','Aurora20129@gmail.com','eohmyrvb3hs0ikcjvbxaqrb','1955-02-09','182451','154.424.439-80','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Luiz Otávio','Luiz Otávio','Luiz Otávio26493@gmail.com','rrdo066lb3lxy2xf3oez','1972-07-13','401058','434.584.473-85','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Maria Isis','Maria Isis','Maria Isis29061@gmail.com','dwzm0qc8xkopn1o98xtlrr','1979-07-25','974323','745.197.378-69','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Carlos Eduardo','Carlos Eduardo','Carlos Eduardo22955@gmail.com','2srgmyfboxjps1mtbtst2','1962-11-05','927467','126.647.953-84','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Louise','Louise','Louise20115@gmail.com','8k6q5hxcgxcpewc3ed27x','1955-01-26','263466','602.038.767-41','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Tomás','Tomás','Tomás25263@gmail.com','szfbv6b3m6f3mggxsk2dv','1969-03-01','832281','581.433.794-00','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Heloise','Heloise','Heloise31631@gmail.com','8zrpse128wn3wygsydy5h','1986-08-07','504491','386.977.528-92','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Lucas Gabriel','Lucas Gabriel','Lucas Gabriel33422@gmail.com','yfb2u9uj6jdivgnz42rs4','1991-07-03','927045','851.818.857-13','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana Vitória','Ana Vitória','Ana Vitória20701@gmail.com','x70rjdsbj3v3uqogh3zag','1956-09-03','36216','364.045.073-66','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('André','André','André13272@gmail.com','ww5gb5auh3tnf6gn1emrr','1936-05-02','903293','868.872.579-98','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana Cecília','Ana Cecília','Ana Cecília16908@gmail.com','l6ka3bm9vhcodipcy96b3h','1946-04-16','691576','931.604.373-53','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('José','José','José30656@gmail.com','7zljmau8fmac90jeg5p3gf','1983-12-06','464936','787.195.692-20','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ana Liz','Ana Liz','Ana Liz19464@gmail.com','arno344pv0rlmwzha8556b','1953-04-15','295758','962.605.128-05','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Yago','Yago','Yago12562@gmail.com','2fj0sgi56nelu6k4o9sd9h','1934-05-23','44339','164.572.264-34','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Joana','Joana','Joana12422@gmail.com','wgv7ftcfpwzad70caj2n','1934-01-03','68472','274.160.426-66','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Danilo','Danilo','Danilo22111@gmail.com','aqrlw7nu3hcpd1p4jq9g5','1960-07-14','127488','156.245.465-05','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Luana','Luana','Luana30325@gmail.com','c28orx5aobf0rd2s43yfgu','1983-01-09','259070','625.853.574-73','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Anthony Gabriel','Anthony Gabriel','Anthony Gabriel28846@gmail.com','f3rbo9jtfc78qljxnk1p6k','1978-12-22','96387','954.804.158-83','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Antônia','Antônia','Antônia26109@gmail.com','s32wxrxlk09cailyurxo6n','1971-06-25','644671','121.001.265-04','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Ruan','Ruan','Ruan23154@gmail.com','fuaqqlidjefy5ncrnb4rz','1963-05-23','713460','852.806.035-70','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Isabel','Isabel','Isabel28145@gmail.com','jro7vgrjb44ktntiorn54','1977-01-20','1882','338.567.694-04','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Miguel Henrique','Miguel Henrique','Miguel Henrique21599@gmail.com','ajz5q76sebiwzoymsun4r','1959-02-18','982894','683.096.944-15','M');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Bruna','Bruna','Bruna26249@gmail.com','tcxsmf8xoktfelj5gh6b9','1971-11-12','529224','398.876.953-35','F');
INSERT INTO USERS(salt,name,email,password,birthday,medical_document,personal_document,genre) VALUES('Oliver','Oliver','Oliver25451@gmail.com','pzsdebkt3dwfee20hnop','1969-09-05','949557','034.322.388-00','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('85','afraates','afraates@gmail.com','(11) 99620-2147','13650671816','1962-07-06','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('86','airton_neto','airton_neto@hotmail.com','(34) 98829-6714','059.884.756-12','1993-03-28','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('87','ALDOMARIO LEITE TORRES','aldomarioltorres@gmail.com','(81) 99526-4419','35617187449','2002-03-13','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('88','alegomesrueda','alegomesrueda@gmail.com','(11) 98105-3483','37018320801','2008-03-01','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('89','alexandre','alexandre@rizzuti.com.br','(55) 11423-8812','420.215.898-97','1984-01-04','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('90','alexandretrujillo1944','alexandretrujillo1944@gmail.com','(17) 98117-7379','25694819802','2013-06-03','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('91','alice60moreira','alice60moreira@gmail.com','(61) 99737-1416','087.530.322-68','1986-05-24','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('92','americo.dan','americo.dan@hotmail.com','(13) 97420-9119','60978201868','1987-11-25','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('93','anacarolinasantos','anacarolinasantos@hotmail.com','(81) 3877-4164','68645813491','1960-03-22','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('94','anaclaudialucas','anaclaudialucas@hotmail.com','(53) 9982-6702','59908041053','1984-03-03','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('95','anacrisansone','anacrisansone@hotmail.com','(11) 9988-74110','25123919813','1991-12-03','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('96','André Simões da Silva','ad.simoes@gmail.com','(11) 9647-17551','310.476.288-05','1936-12-09','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('97','André Silva de Souza','andre.silva@beadell.com.br','(21) 99447-5235','2907503502','1939-04-18','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('98','andre.sales.2','andre.sales.2@hotmail.com','(81) 9980-34021','3611049441','2002-06-12','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('99','andreacristh','andreacristh@gmail.com','(11) 94991-9110','134.467.338-41','1948-11-09','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('100','andreshimada','andreshimada@gmail.com','(15) 98151-2359','32286239800','2015-01-07','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('101','angelosousaff','angelosousaff@gmail.com','(61) 99247-6246','055.033.074-70','1942-02-01','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('102','anitalafey','anitalafey@gmail.com','(12) 98121-0622','25995021877','1949-05-08','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('103','annalydia','annalydia@gmail.com','(19) 99662-4037','39377668808','1966-07-22','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('104','antonio.arq79','antonio.arq79@gmail.com','(82) 99992-2132','007.596.964-54','2010-01-13','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('105','arletenamk','arletenamk@gmail.com','(11) 99399-6146','85744620800','1995-09-28','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('106','ataquechel','ataquechel@gmail.com','(71) 9821-63536','016.535.385-62','1951-04-06','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('107','barbieri.ricardo.sp','barbieri.ricardo.sp@gmail.com','(11) 98197-0031','32680516850','1961-01-19','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('108','beatriz','beatriz@2wp.com.br','(55) 11966-891182','39872417806','1956-01-22','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('109','Beatriz Macedo do Amaral','beatrizmacedoamaral@gmail.com','(11) 98434-9030','407.392.908-94','1948-03-26','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('110','beth.linhares','beth.linhares@ig.com.br','(16) 99165-9202','19645450802','2013-05-03','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('111','bethfg1','bethfg1@bol.com.br','(21) 99129-5900','11726959708','1945-01-10','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('112','bmedeirosf','bmedeirosf@gmail.com','(11) 99518-8780','067.882.254-94','1945-01-21','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('113','Adriana Rodrigues','adriana@brasileirosnouruguai.com.br','(11) 94277-3004','28889294817','2012-03-17','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('114','brihaque','brihaque@gmail.com','(55) 11982-9019','116845098','1937-04-16','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('115','brunno.reimann','brunno.reimann@hotmail.com','(11) 9590-30853','413.172.848-60','2003-03-21','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('116','ca.ferraz91','ca.ferraz91@hotmail.com','(51) 99525-4432','2476710024','1984-07-02','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('117','cardoso.ariella','cardoso.ariella@gmail.com','(24) 98126-4409','3599486182','1998-07-03','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('118','cardosobio22','cardosobio22@gmail.com','(61) 99209-1057','396.516.734-00','1985-12-28','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('119','carolinapagan','carolinapagan@hotmail.com','(11) 98995-8900','28059017896','1969-03-21','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('120','carolinascardoso','carolinascardoso@gmail.com','(53) 98101-8092','98511165053','1955-01-17','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('121','carolinasoufi','carolinasoufi@gmail.com','(21) 99460-9299','142.415.707-20','1935-11-25','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('122','carolpritz','carolpritz@gmail.com','(11) 99494-6931','317.423.478-60','2007-12-23','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('123','castilho.marcelo','castilho.marcelo@gmail.com','(91) 99155-4766','251.880.542-72','1998-07-24','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('124','cayrescarolina','cayrescarolina@gmail.com','(11) 9766-38694','31584877804','1992-02-16','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('125','ceciliamariaverna','ceciliamariaverna@gmail.com','(11) 96440-5435','30260848832','1993-06-01','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('126','chiavini','chiavini@hotmail.com','(11) 98245-8694','26890413830','2012-12-16','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('127','Cibele de Almeida Zuca Ferreira','bele_zuca@yahoo.com.br','(11) 94742-2073','34203066875','1984-05-28','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('128','Cintia Marques dos Santos Silva','cintiassmarques@gmail.com','(21) 99994-3371','080.352.937-61','1974-02-18','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('129','clarice.rts','clarice.rts@gmail.com','(11) 99993-8991','949727881','2016-02-26','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('130','claudia.totolu','claudia.totolu@gmail.com','(55) 11989-7525','21872893899','1943-10-25','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('131','Cleuza Viana da Silva','cleuza_viana@yahoo.com.br','(47) 98462-1045','004.181.009-00','1935-03-25','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('132','crisfisioterapia2010','crisfisioterapia2010@gmail.com','(32) 99952-7016','087.191.326-70','1959-12-18','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('133','crismaria.riva','crismaria.riva@hotmail.com','(54) 99600-4753','014.821.480-05','1934-05-10','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('134','cvarellas','cvarellas@gmail.com','(61) 98265-2326','68961022172','1949-03-04','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('135','dani.mande','dani.mande@hotmail.com','(11) 97280-4971','36009209870','1942-06-20','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('136','DANIELA PELISARI','DPELISARI@GMAIL.COM','(11) 99791-9978','18345373801','1969-08-16','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('137','DANILO DE FIGUEIREDO MATIAS','danilofgmatias07@gmail.com','(11) 9537-08245','34078224806','1998-01-03','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('138','Dayana Fracaro','dayanafracaro@gmail.com','(41) 9915-63016','4662351944','1973-09-10','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('139','degallo','degallo@uol.com.br','(11) 2673-1421','8888936807','1987-04-28','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('140','deia.silveira89','deia.silveira89@gmail.com','(55) 48996-014682','6169265965','1978-11-12','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('141','deniscachoeira','deniscachoeira@yahoo.com.br','(32) 99818-1285','4930085608','1974-03-24','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('142','Diangellis Emanuel de Lima Silva','diangellislima@gmail.com','(34) 99637-8159','3568980320','2007-08-04','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('143','diegodemiranda','diegodemiranda@outlook.com','(31) 9740-01412','12334226777','1992-12-03','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('144','dlehugeur','dlehugeur@hotmail.com','(51) 99967-8248','479004150-68','1947-01-21','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('145','dpetruceli','dpetruceli@hotmail.com','(31) 98686-1994','3365473661','1952-06-02','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('146','ebersaraiva','ebersaraiva@yahoo.com.br','(65) 99289-6920','89913027691','1981-06-26','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('147','edgar.dm','edgar.dm@gmail.com','(11) 97245-0508','28871607880','1945-06-19','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('148','edilsonagner','edilsonagner@hotmail.com','(45) 99118-2626','844.498.619-49','1983-01-16','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('149','eduardo.smelo','eduardo.smelo@uol.com.br','(11) 98510-0370','28646211851','2001-08-12','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('150','elainenutri','elainenutri@gmail.com','(71) 99640-0139','2022501560','1998-12-10','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('151','elisabete maria rossi','elisabet.rossi@superig.com.br','(11) 98945-6944','6247140800','1996-02-22','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('152','eliterafapg97','eliterafapg97@gmail.com','(11) 96550-6864','446.783.758-21','1953-03-25','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('153','elohass','elohass@hotmail.com','(13) 99121-9471','37437298813','1946-06-24','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('154','elvis.wolvie','elvis.wolvie@gmail.com','(61) 98151-5012','4644340413','2012-12-02','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('155','Enrico Mazzeo','mazzeo986@hotmail.com','(55) 11987-5094','36145497807','2012-07-20','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('156','enzodonat','enzodonat@gmail.com','(47) 99615-9829','104.322.079-88','1937-06-04','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('157','eriquinha.eriquinha','eriquinha.eriquinha@hotmail.com','(11) 9879-47514','28535392882','1947-04-17','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('158','evandrogouvea','evandrogouvea@hotmail.com','(67) 99275-3662','99303540182','1976-10-28','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('159','f.fukushima.jp','f.fukushima.jp@gmail.com','(11) 95137-2691','26312406857','2016-10-01','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('160','Fabiana Forseto','fabiforseto@gmail.com','(11) 99541-1100','153.042.238-88','1971-08-09','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('161','fabianogd','fabianogd@icloud.com','(61) 98306-1919','033.356.001-93','2013-08-18','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('162','facidade45','facidade45@hotmail.com','(51) 99592-8908','38898691068','1988-05-06','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('163','fantoniaraujo','fantoniaraujo@uol.com.br','(11) 96532-6709','49928278772','1945-03-28','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('164','fatima_das','fatima_das@uol.com.br','(11) 98385-0276','5477152850','2015-11-03','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('165','Maria de Fátima Moreira Mendonça','fatima.m.m0707@gmail.com','(11) 98887-2599','17962344865','1971-04-27','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('166','fcbaroni','fcbaroni@hotmail.com','(11) 9976-59625','41923654802','1977-06-07','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('167','fernandaconto','fernandaconto@hotmail.com','','3910952933','1956-03-14','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('168','Fernando ferreira dos santos','santosff78@gmail.com','(21) 9952-07117','043.419.937-04','1983-04-22','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('169','fhilipe1982','fhilipe1982@gmail.com','(88) 99660-3746','95627880325','1971-09-24','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('170','flaviabotana','flaviabotana@gmail.com','(11) 99129-0924','36835890860','1968-01-07','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('171','flavio.camara','flavio.camara@gmail.com','(21) 98863-3061','634.128.297-49','1935-07-22','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('172','flexor','flexor@on.br','(21) 2719-7593','462225534','2009-10-12','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('173','FLÚVIA OLIVEIRA DA SILVA VITORINO','fluvia.oliveira@gmail.com','(21) 96490-3241','4770190727','2013-05-24','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('174','ftfmantovani','ftfmantovani@gmail.com','(11) 94969-9145','34104588830','2006-08-21','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('175','gabidavanzo','gabidavanzo@hotmail.com','(11) 9411-26936','28592448832','1957-07-25','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('176','gabriela.epifani','gabriela.epifani@gmail.com','(81) 99743-6150','6299251433','1971-02-21','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('177','gabrielacase','gabrielacase@gmail.com','(22) 99995-9321','312571780','1982-05-12','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('178','Gabriel Antônio Dalla Colletta da Costa','gabrielconcurseiro@gmail.com','(51) 98572-2872','93787529004','2003-06-12','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('179','gabriella.61','gabriella.61@gmail.com','(11) 99946-8778','403.577.048-51','2002-01-19','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('180','gabrielskiba13','gabrielskiba13@yahoo.com.br','(41) 99623-5337','5127258960','1972-02-15','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('181','georgy11235','georgy11235@gmail.com','(21) 9818-05147','6320321709','1985-10-05','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('182','geovanemanoel','geovanemanoel@hotmail.com','(48) 99922-2763','4104052990','1992-01-11','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('183','giraldelli.lucas','giraldelli.lucas@gmail.com','(12) 98161-8191','405.866.918-71','1967-06-28','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('184','glaucoazevedo','glaucoazevedo@sapo.pt','(31) 99687-8422','4615367651','1937-05-26','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('185','gozdecki','gozdecki@hotmail.com','(55) 41998-340729','7729094908','2015-11-25','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('186','grahh_domingos','grahh_domingos@hotmail.com','(11) 99341-0134','414.281.418-47','1976-08-27','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('187','gutembergxavier','gutembergxavier@gmail.com','(81) 99905-3038','069.994.284-50','1987-02-08','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('188','gutogregory','gutogregory@yahoo.com.br','(47) 9642-1603','3783187990','2016-05-09','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('189','hallison.fernando','hallison.fernando@gmail.com','(43) 98806-3937','9750260970','1941-07-20','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('190','heliogaldino','heliogaldino@yahoo.com.br','(62) 99239-1825','1930887116','1966-06-20','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('191','heloisa_loul','heloisa_loul@hotmail.com','(19) 99417-7525','31244721875','1935-06-17','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('192','Hiagobruno139','Hiagobruno139@gmail.com','(21) 98145-8401','13233639716','1999-02-26','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('193','husousa','husousa@hotmail.com','(86) 9997-98169','40555330478','1973-01-09','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('194','ibitimac','ibitimac@hotmail.com','(48) 98456-8629','399.248.317-72','2017-09-25','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('195','icanedocampos','icanedocampos@uol.com.br','(55) 31999-883778','557.485.976-91','1962-01-20','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('196','ingridthayse','ingridthayse@hotmail.com','(33) 99132-5987','079.794.856-29','1971-03-01','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('197','ipistili','ipistili@mayerbrown.com','(11) 97346-5191','40636343880','1955-01-27','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('198','isabelafarias','isabelafarias@live.com','(81) 99926-5645','2274421480','2016-11-03','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('199','isabelaras','isabelaras@hotmail.com','(75) 99932-1962','3407611560','1944-02-15','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('200','isaverri_vale','isaverri_vale@hotmail.com','(11) 96186-6867','39921223879','1987-08-19','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('201','izabel.araujo08','izabel.araujo08@gmail.com','(51) 98309-2658','43914039000','1964-12-07','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('202','jalbuquerquec','jalbuquerquec@hotmail.com','(11) 99720-9396','269.853.508-36','1934-03-16','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('203','janaina.afovi','janaina.afovi@gmail.com','(12) 98853-7165','35491554847','2017-12-05','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('204','jaquelineparedez','jaquelineparedez@hotmail.com','(41) 99236-0118','088.462.309-22','1995-10-06','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('205','jaysson-cavalcante','jaysson-cavalcante@hotmail.com','(11) 94463-6550','428.523.058-52','1957-05-01','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('206','JULIO CESAR BORGES DE PAIVA','juliocbpaiva2@gmail.com','(84) 3345-6572','85190187420','2010-01-19','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('207','Jéssica Silva','jee.plass@gmail.com','(11) 9825-62354','400.239.278-36','1946-10-07','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('208','jessielindsey','jessielindsey@live.com','(55) 21995-905149','149.912.467-84','1956-01-15','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('209','joanamigliacci','joanamigliacci@hotmail.com','(11) 97129-0713','36900561870','2003-03-28','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('210','joaopaulo','joaopaulo@newm.com.br','(17) 99675-3096','39045183803','1993-03-23','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('211','joekakiuchi','joekakiuchi@gmail.com','(11) 9474-46860','230.080.098-59','1980-01-16','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('212','josue-lima0300','josue-lima0300@hotmail.com','(11) 99860-6095951','446.877.738-93','1941-03-22','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('213','jsgsoares','jsgsoares@yahoo.com.br','(19) 98173-2374','001.110.537-22','1990-03-27','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('214','juliamado','juliamado@gmail.com','(21) 99125-8646','1473152712','1940-01-27','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('215','julio.salgado','julio.salgado@csn.com.br','(24) 98133-2806','74487329787','1953-05-16','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('216','junior.riopreto','junior.riopreto@gmail.com','(17) 3353-7659','285.005.268-07','1969-10-12','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('217','karenzandona','karenzandona@gmail.com','(55) 98433-0313','911.273.780-15','1986-11-11','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('218','katialeonel','katialeonel@uol.com.br','(11) 98175-7582','14372036809','1998-06-04','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('219','kelsen.jus','kelsen.jus@hotmail.com','(85) 99953-0303','024.993.863-47','1996-04-02','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('220','kyruak','kyruak@gmail.com','(21) 9857-63041','13742312740','1957-09-01','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('221','lais.r.ozuna','lais.r.ozuna@gmail.com','(11) 96944-9234','44670468871','1938-06-19','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('222','lauriane.ruppental','lauriane.ruppental@gmail.com','(54) 98138-9383','50197924034','1946-04-12','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('223','lcnaibert','lcnaibert@hotmail.com','(51) 98111-7114','81149310006','1959-05-14','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('224','leasegal','leasegal@gmail.com','(21) 97230-9888','9127596745','1943-06-22','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('225','leia.lima','leia.lima@live.com','(11) 98345-4124','31005832803','1956-04-04','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('226','livi.lavigne','livi.lavigne@gmail.com','(71) 99972-5723','814.435.795-72','1989-08-25','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('227','llima_galvao','llima_galvao@yahoo.com.br','(55) 99165-2230','21960658204','1937-06-11','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('228','lubrito21','lubrito21@yahoo.com.br','(85) 99921-9539','88371263368','1957-10-09','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('229','lucascubo2','lucascubo2@hotmail.con','(17) 98167-9036','39413108870','1994-03-21','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('230','lucianachechi','lucianachechi@terra.com.br','(55) 99122-3696','92659411034','1980-07-11','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('231','lucianagcastro12','lucianagcastro12@gmail.com','(19) 9818-29400','16076033819','2008-11-28','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('232','lucio.patrao','lucio.patrao@hotmail.com','(34) 99973-3029','27430669620','1965-09-04','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('233','ludimendonca','ludimendonca@hotmail.com','(55) 98100-6778','7611880616','1994-02-19','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('234','luiza-moreno','luiza-moreno@hotmail.com','(61) 99156-2483','4209673110','2004-08-19','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('235','luizotaviorosario','luizotaviorosario@gmail.com','(55) 3375-0932','455.183.190-53','2000-06-03','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('236','m2decor','m2decor@hotmail.com','(51) 99630-6325','239.101.270-53','2017-12-23','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('237','madalena180','madalena180@hotmail.com','(55) 81999-6511','17351030472','1952-07-24','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('238','Marcelo Pereira de Magalhães','marcelo2312000@hotmail.com','(91) 98850-4500','645414280','1961-10-16','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('239','marciayuri.k','marciayuri.k@gmail.com','(11) 94925-4791','28226504899','1943-12-01','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('240','mario.gallego.neto','mario.gallego.neto@uol.com.br','(11) 94121-0240','26497046836','1964-11-28','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('241','marlicastilha','marlicastilha@hotmail.com','(11) 95458-5268','14408330876','1935-10-10','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('242','Mauricio Barbosa Santana','mauriiciobarbosa@gmail.com','(11) 98679-4124','057.680.085-60','2006-02-17','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('243','mipaglione','mipaglione@gmail.com','(11) 5572-2473','304096598-00','1947-08-03','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('244','Leticia Vania Miranda','leticia.vania@hotmail.com','(11) 98031-5168','21345164882','1980-10-23','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('245','mlarafranco','mlarafranco@bol.com.br','(38) 9910-51727','66388279600','2007-12-23','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('246','mmansour','mmansour@terra.com.br','(55) 97575-8959','628.337.158-20','1941-04-15','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('247','mohemaduarte','mohemaduarte@hotmail.com','(89) 9945-95218','60071394338','1964-12-20','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('248','Jose pedro molina moraes','molinampg@gmail.com','(51) 99669-1374','34487646049','1966-12-03','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('249','monick_lim','monick_lim@yahoo.com.br','(85) 98869-5046','2690757397','1951-03-22','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('250','monizinn_rodrigues','monizinn_rodrigues@hotmail.com','(21) 98553-9417','11410237761','1968-03-06','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('251','Daniel Costa','danielmorosov@gmail.com','(11) 97516-1083','43681994803','1951-10-26','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('252','mrrates','mrrates@gmail.com','(31) 98862-9014','73642592600','1953-08-08','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('253','msrubiao','msrubiao@uol.com.br','(11) 3366-5365','7702007885','1960-07-23','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('254','murilobnu','murilo@brasileirosnouruguai.com.br','(11) 94277-3004','288.892.948-17','1994-11-11','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('255','murilomolha','murilomolha@yahoo.com.br','(11) 99856-0711','28901536811','1984-05-10','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('256','murilomolha1','murilomolha@hotmail.com','(11) 97185-6995','317.711.218-58','2006-06-17','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('257','nah_barros','nah_barros@hotmail.com','(65) 9964-3913','3579966154','1981-02-09','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('258','najinha1','najinha1@hotmail.com','(11) 99978-4886','56952171800','2016-02-17','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('259','nataliadasluzes','nataliadasluzes@gmail.com','(16) 99776-6177','36884552824','1961-11-06','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('260','Natalie Rezende Batista','natalie.rbatista@gmail.com','(55) 11958-2472','1288214693','1957-02-17','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('261','nathalia.andrader','nathalia.andrader@gmail.com','(11) 98318-4798','40105185884','2010-04-20','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('262','NATHALIAYORRANNA','NATHALIAYORRANNA@GMAIL.COM','(83) 98669-4720','10001332490','1968-03-06','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('263','natimarinho','natimarinho@gmail.com','(11) 98218-3481','5619069478','1953-05-11','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('264','natyita_30','natyita_30@hotmail.com','(71) 99681-1399','1501413511','1994-07-19','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('265','nelma.rocha2009','nelma.rocha2009@hotmail.com','(21) 3497-0552','34429433704','1941-01-15','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('266','netbarion','netbarion@hotmail.com','(55) 19999-789973','41558632867','1979-10-27','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('267','netoadao','netoadao@ig.com.br','(11) 4893-3564','4477595824','1993-09-01','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('268','netodelhoyo','netodelhoyo@gmail.com','(14) 98165-9009','371.100.428-80','1964-10-01','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('269','niickaah','niickaah@hotmail.com','(11) 9524-17620','38439429860','2009-04-02','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('270','NOEME2012','NOEME2012@HOTMAIL.COM','(61) 99177-1495','61863807187','1981-02-24','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('271','og.daniela','og.daniela@gmail.com','(11) 99423-0105','115.658.868-52','1960-01-24','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('272','orlandomoraisjunior','orlandomoraisjunior@hotmail.com','(81) 99975-9989','19436408404','1946-10-12','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('273','pablo.sebrae','pablo.sebrae@gmail.com','(95) 98116-6634','98517287215','1948-12-27','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('274','patty_brj','patty_brj@hotmail.com','(21) 98258-9591','30056144768','1938-08-15','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('275','paty_trevelin','paty_trevelin@hotmail.com','(11) 9621-92525','368.973.918-75','2012-05-21','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('276','paula_nv3','paula_nv3@hotmail.com','(83) 98884-8400','038.565.534-79','2009-01-04','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('277','Paulo Aramis Bonin','paulo.aramis67@gmail.com','(11) 98098-3721','583.470.119-15','1946-03-09','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('278','paulo.knijnik','paulo.knijnik@gmail.com','(51) 99686-3808','88749487','2017-11-05','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('279','pauloc.figueiredo','pauloc.figueiredo@gmail.com','(21) 98145-6944','6624043787','1977-09-20','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('280','pcampanha','pcampanha@uol.com.br','(61) 98141-4977','011.014.347-75','1966-03-07','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('281','pedagoga.glauce','pedagoga.glauce@gmail.com','(48) 3251-0552','044.369.479-63','1983-07-18','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('282','pedrocarreteiro111','pedrocarreteiro111@gmail.com','(11) 95291-8228','100.721.537-25','1959-05-14','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('283','pedronasan','pedronasan@gmail.com','(19) 98814-8344','72249137820','2015-11-09','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('284','prof.daniellesouza','prof.daniellesouza@gmail.com','(21) 99683-7667','5309214720','1934-02-07','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('285','psakai','psakai@gmail.com','(11) 98655-9505','28418510870','1977-03-20','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('286','psformaggio','psformaggio@hotmail.com','(35) 99963-5272','36286567615','1985-05-25','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('287','r-avelino','r-avelino@uol.com.br','(11) 99780-3737','364.010.908-20','2017-01-13','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('288','Rafael Pinheiro','rafael@brasileirosnouruguai.com.br','(11) 9637-19656','467.837.582-1','2002-10-22','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('289','rafaelferesvieira','rafaelferesvieira@gmail.com','(11) 98402-8737','307.160.008-90','2000-09-17','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('290','raonicl','raonicl@gmail.com','(71) 3035-4331','1884215564','1989-05-23','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('291','raul','raul@cialconstrutora.com','(21) 99973-7142','590854798','1959-09-14','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('292','ray-ferro','ray-ferro@uol.com.br','(11) 98068-9806','259.696.844-49','1976-02-01','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('293','renataalvesbarbosa','renataalvesbarbosa@hotmail.com','(11) 99588-2446','29145950857','2010-04-06','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('294','rhlenzi','rhlenzi@ig.com.br','(12) 9972-70425','004.591.957-78','1966-12-13','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('295','ricardobaraky1962','ricardobaraky1962@ig.com.br','(32) 98814-7048','48521051620','1983-08-16','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('296','ricardofreitas0001','ricardofreitas0001@hotmail.com','(81) 98569-1860','10151069433','2003-04-27','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('297','ricardohodge','ricardohodge@yahoo.com.br','(34) 99148-0998','78849012691','1973-11-11','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('298','ricardoscsilva','ricardoscsilva@gmail.com','(11) 9519-2780','30940188821','1988-04-10','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('299','rob.pereiralima','rob.pereiralima@gmail.com','(11) 99419-8484','32160098825','2008-11-05','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('300','Rodolfo Sanches Moura','rodolfosanchesmoura@hotmail.com','(14) 3541-0999','39955921803','1961-11-12','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('301','rodrigomouraduarte','rodrigomouraduarte@hotmail.com','(21) 99869-5044','119.241.717-83','1972-11-04','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('302','samararibeiro.adv','samararibeiro.adv@gmail.com','(98) 98855-9870','1980779392','1974-01-09','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('303','Sandra Costa da Silva','ssylwa2000@yahoo.com.br','(61) 99215-2038','48538744453','2007-07-24','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('304','sepulved.rlk','sepulved.rlk@terra.com.br','(21) 99983-8021','49156276753','1989-07-05','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('305','sferreira11','sferreira11@hotmail.com','(21) 99483-7839','843784687','1967-01-15','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('306','shyveres','shyveres@gmail.com','(11) 98083-5977','34898179827','2013-03-12','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('307','silvajbl','silvajbl@yahoo.com.br','(73) 3292-5491','22173892894','1979-10-22','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('308','Silvia Castro','silviapjmj@hotmail.com','(19) 99427-5442','347.476.968-57','1948-04-24','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('309','skfdantas','skfdantas@gmail.com','(61) 98219-4399','037.372.721-66','1988-07-15','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('310','slafbero','slafbero@hotmail.com','(16) 99189-6484','9304195888','1934-06-27','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('311','ssobrinho.erika','ssobrinho.erika@gmail.com','(11) 98744-4880','695464523','1981-07-15','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('312','STELA MARIA MARCONI','pelamordi@hotmail.com','(43) 9842-12009','006.988.679-20','2015-12-02','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('313','tatianacerodio','tatianacerodio@hotmail.com','(16) 99134-8959','318.943.898-67','2007-02-18','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('314','teste','teste@2wp.com.br','(55) 11966-891182','398.724.178-06','1972-06-23','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('315','teste1','teste@afsdf.com.br','(11) 96689-1182','39872417888','1989-05-05','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('316','teste2','teste@teste.com.br','(11) 9402-74316','35570533850','2015-12-26','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('317','teste21','teste2@teste.com.br','(11) 94027-4316','35570533850','1951-11-08','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('318','teste3','teste@teste.com','(11) 9402-74316','355.705.338-50','1993-01-23','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('319','thalyne.oliveira3','thalyne.oliveira3@gmail.com','(85) 99621-1893','5064243324','1988-06-28','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('320','thiago_tx84','thiago_tx84@hotmail.com','(11) 99487-9622','33269284837','2004-10-04','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('321','thiagombrandao1','thiagombrandao1@gmail.com','(11) 94120-8412','3027807501','1956-07-18','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('322','thibarbosa7','thibarbosa7@gmail.com','(19) 99776-6063','38527513811','1955-05-08','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('323','Tiago Marcon Trichez','tiagotrichez@gmail.com','(48) 99944-7023','4435149923','2002-06-06','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('324','torquato','torquatocarneiro@gmail.com','(21) 9810-04597','10414614372','1993-02-18','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('325','tutieng','tutieng@gmail.com','(19) 98833-7781','6060009689','1996-01-03','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('326','umartelozo','umartelozo@gmail.com','(14) 99766-1581','31647932866','1955-02-01','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('327','ursula.andrade28','ursula.andrade28@gmail.com','(71) 98787-8799','4706288550','1965-12-23','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('328','valxdelgado','valxdelgado@gmail.com','(61) 98111-4229','8491989684','2013-07-23','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('329','vbmariani','vbmariani@gmail.com','(55) 61999-472122','73781550125','1982-06-09','F');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('330','vdscheidt','vdscheidt@yahoo.com.br','(48) 99690-2073','21908249900','1963-11-10','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('331','vitorfrancafaria','vitorfrancafaria@gmail.com','(31) 99517-0516','024.989.391-64','1946-01-17','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('332','WALDIRENE','WALDIRENE@GOLDCELL.COM.BR','(41) 99206-4250','79204775904','1977-09-04','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('333','waldirwatzko','waldirwatzko@gmail.com','(55) 47988-1852','1957031972','1947-07-11','M');
INSERT INTO PATIENT("addressId",name,email,"phoneNumber",personal_document,birthday,genre) VALUES('334','yannagoncalves','yannagoncalves@gmail.com','(85) 98952-7802','2497472351','1986-09-04','F');
INSERT INTO TYPE_APPOINTMENT(name) VALUES('consulta');
INSERT INTO TYPE_APPOINTMENT(name) VALUES('emergência');
INSERT INTO MEDICAL_CATEGORY(name) VALUES('Clinico geral');
INSERT INTO TYPE_PRONOUNCER(name) VALUES('consulta');
INSERT INTO TYPE_PRONOUNCER(name) VALUES('emergência');
INSERT INTO USERS_HAS_MEDICAL_CATEGORY(medical_category_id,user_id) VALUES('1','1');
INSERT INTO PRONOUNCER(description,patient_id,hospital_id,type_pronouncer) VALUES('descrição','1','1','1');
INSERT INTO PRONOUNCER(description,patient_id,hospital_id,type_pronouncer) VALUES('descrição','1','1','2');
INSERT INTO APPOINTMENT(hypovolemic_shock,pronouncer_id,schedule,medical_category_id,type_id,user_id,description,skin_burn,fever,convulsion,asthma,vomit,diarrhea,apnea,heart_attack) VALUES('false','1','11/11/18','1','1','1','Descrição','0','36','0','false','false','false','false','false');
INSERT INTO APPOINTMENT(hypovolemic_shock,pronouncer_id,schedule,medical_category_id,type_id,user_id,description,skin_burn,fever,convulsion,asthma,vomit,diarrhea,apnea,heart_attack) VALUES('false','2','11/11/18','1','1','1','Descrição','1','36','0','false','false','false','false','false');
INSERT INTO APPOINTMENT(hypovolemic_shock,pronouncer_id,schedule,medical_category_id,type_id,user_id,description,skin_burn,fever,convulsion,asthma,vomit,diarrhea,apnea,heart_attack) VALUES('false','2','11/11/18','1','1','1','Descrição','2','36','0','false','false','false','false','false');
INSERT INTO APPOINTMENT(hypovolemic_shock,pronouncer_id,schedule,medical_category_id,type_id,user_id,description,skin_burn,fever,convulsion,asthma,vomit,diarrhea,apnea,heart_attack) VALUES('false','2','11/11/18','1','1','1','Descrição','0','36','0','false','false','false','false','false');
INSERT INTO PAIN(severity,pain_name) VALUES('4','muita dor');
INSERT INTO TRAUMA(severity,trauma_name,trauma_type) VALUES('4','traumazão','1');
INSERT INTO APPOINTMENT_HAS_TRAUMAS(trauma_id,appointment_id) VALUES('1','2');
INSERT INTO APPOINTMENT_HAS_PAIN(pain_id,appointment_id) VALUES('1','3');

insert INTO hospital_has_user (user_id, hospital_id) values (2,1);
insert INTO hospital_has_user (user_id, hospital_id) values (2,3);