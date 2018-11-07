const ACTIONS = {
  'user.all': {
    require: [
      'user.list'
    ]
  },
  'hospital.all': {
    require: [
      'hospital.list'
    ]
  }
}
module.exports = ACTIONS
