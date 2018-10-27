const { Client } = require('pg');

const {
  POSTGRES_HOST,
  POSTGRES_USERNAME,
  POSTGRES_PASSWORD,
  POSTGRES_DATABASE,
  POSTGRES_PORT
} = process.env

module.exports.connect = function () {
  
  const client = new Client({
    user: POSTGRES_USERNAME,
    host: POSTGRES_HOST,
    database: POSTGRES_DATABASE,
    password: POSTGRES_PASSWORD,
    port: POSTGRES_PORT,
  });

  return client;
}