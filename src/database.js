const Sequelize = require('sequelize')
const pg = require('pg')
const {
  NODE_ENV,
  POSTGRES_HOST,
  POSTGRES_USERNAME,
  POSTGRES_PASSWORD,
  POSTGRES_DATABASE,
  POSTGRES_PORT
} = process.env
let shouldUseSSL = false
if (NODE_ENV ==='production') {
  pg.defaults.ssl = true
  shouldUseSSL = true
}

console.log(POSTGRES_DATABASE, POSTGRES_USERNAME, POSTGRES_PASSWORD)

global.sequelize = new Sequelize(POSTGRES_DATABASE, POSTGRES_USERNAME, POSTGRES_PASSWORD, {
  host: POSTGRES_HOST,
  port: POSTGRES_PORT,
  dialect: 'postgres',
  charset: 'utf8mb4',
  logging: false,
  freezeTableName: true,
  ssl: shouldUseSSL
})
require('./define-models')() // Requere todos os módulos do Sequelize

// console.log(chalk.green(`Connecting to database: ${MYSQL_USERNAME}:${MYSQL_PASSWORD}@${MYSQL_HOST}/${MYSQL_DATABASE}`))

module.exports = () => {
  global.sequelize.authenticate()
}
