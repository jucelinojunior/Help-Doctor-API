drop schema public cascade;
create schema public;


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
  address_id INT NULL,
  phoneNumber VARCHAR(100) NOT NULL,
  createdAt TIMESTAMP NULL DEFAULT NOW(),
  updatedAt TIMESTAMP NULL DEFAULT NOW(),
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
  createdAt TIMESTAMP NULL DEFAULT NOW(),
  updatedAt TIMESTAMP NULL DEFAULT NOW(),
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

skin_burn INT DEFAULT 0,
fever INT DEFAULT 0,
convulsion BOOLEAN DEFAULT FALSE,
asthma BOOLEAN DEFAULT FALSE,
vomit BOOLEAN DEFAULT FALSE,
diarrhea BOOLEAN DEFAULT FALSE,
apnea BOOLEAN DEFAULT FALSE,
  heart_attack BOOLEAN DEFAULT FALSE,
hypovolemic_shock BOOLEAN DEFAULT FALSE,
createdAt TIMESTAMP NULL DEFAULT NOW(),
updatedAt TIMESTAMP NULL DEFAULT NOW(),
  medical_return BOOLEAN DEFAULT FALSE,
 is_pregnant BOOLEAN DEFAULT FALSE,
  foreign key (type_id) references TYPE_APPOINTMENT(id),
   foreign key (pronouncer_id)  references PRONOUNCER(id),
   foreign key (user_id) references USERS(id)
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

INSERT INTO public.address(
            address, neighborhood, state, zipcode, "number", complement)
    VALUES ('Rua teste','Bairro Teste', 'SP', '04174090', 8, '');

INSERT INTO public.hospital(
             name, address)
    VALUES ( 'Hospital teste', 1);


INSERT INTO public.roles(
            name)
    VALUES ( 'ADMIN');

insert into actions (name) values ('create-user');
insert into roles_has_actions (role_id, action_id) values (1,1);

-- SELECT * FROM users as users
-- inner join users_has_roles as users_has_roles ON users_has_roles.user_id = users.id
-- inner join roles as roles ON roles.id = users_has_roles.role_id
-- inner join roles_has_actions as roles_has_actions ON roles_has_actions.role_id = roles.id
-- inner join actions as actions ON actions.id = roles_has_actions.action_id

-- where personal_document = '38724313823'