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
          foreign key (hospital_id) references HOSPITAL(id),
          foreign key (user_id) references USERS(id),
          PRIMARY KEY (id, hospital_id, user_id)
        );

INSERT INTO public.address(
            address, neighborhood, state, zipcode, "number", complement)
    VALUES ('Rua teste','Bairro Teste', 'SP', '04174090', 8, '');

INSERT INTO public.address(
            address, neighborhood, state, zipcode, "number", complement)
    VALUES ('Rua teste','Bairro Teste', 'SP', '04174090', 8, '');

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
      1,
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



INSERT INTO public.hospital(
             name, address)
    VALUES ( 'Hospital teste', 1);
insert into hospital_has_user (user_id, hospital_id) values (1,1);

INSERT INTO public.roles(
            name)
    VALUES ( 'ADMIN');

INSERT INTO users_has_roles (user_id, role_id) VALUES (1,1);

insert into actions (name) values ('user.create');
insert into actions (name) values ('user.all');
insert into actions (name) values ('user.find');
insert into roles_has_actions (role_id, action_id) values (1,1);
insert into roles_has_actions (role_id, action_id) values (1,2);

-- SELECT * FROM users as users
-- inner join users_has_roles as users_has_roles ON users_has_roles.user_id = users.id
-- inner join roles as roles ON roles.id = users_has_roles.role_id
-- inner join roles_has_actions as roles_has_actions ON roles_has_actions.role_id = roles.id
-- inner join actions as actions ON actions.id = roles_has_actions.action_id

-- where personal_document = '38724313823'