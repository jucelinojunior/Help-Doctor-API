const Sequelize = require('sequelize')
const {
  POSTGRES_HOST,
  POSTGRES_USERNAME,
  POSTGRES_PASSWORD,
  POSTGRES_DATABASE,
  POSTGRES_PORT
} = process.env
console.log(POSTGRES_DATABASE, POSTGRES_USERNAME, POSTGRES_PASSWORD)

global.sequelize = new Sequelize(POSTGRES_DATABASE, POSTGRES_USERNAME, POSTGRES_PASSWORD, {
  host: POSTGRES_HOST,
  port: POSTGRES_PORT,
  dialect: 'postgres',
  charset: 'utf8mb4',
  logging: true,
  freezeTableName: true
})
require('./define-models')() // Requere todos os módulos do Sequelize

// console.log(chalk.green(`Connecting to database: ${MYSQL_USERNAME}:${MYSQL_PASSWORD}@${MYSQL_HOST}/${MYSQL_DATABASE}`))

module.exports = () => {
  global.sequelize.authenticate()
}
