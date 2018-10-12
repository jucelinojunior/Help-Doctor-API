module.exports = () => {
  const models = require('glob').sync(require('path').join(__dirname, './models/*.js'))
  models.forEach(model => require(model))
}
