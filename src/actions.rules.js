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
  },
  'user.create': {
    require: [
      'role.list'
    ]
  }
}
module.exports = ACTIONS
