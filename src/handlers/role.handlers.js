const userService = require('../services/role.service')

const roles = {
  method: 'GET',
  path: '/role',
  handler: async (request, reply) => {
    return userService.getAllRoles()
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['role.list']
    },
    cors: {
      origin: ['*']
    }
  }
}

const roles2 = {
  method: 'GET',
  path: '/role/{id}',
  handler: async (request, reply) => {
    return userService.getRole(request.params.id)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['role.find']
    },
    cors: {
      origin: ['*']
    }
  }
}

const roles3 = {
  method: 'DELETE',
  path: '/role/{id}',
  handler: async (request, reply) => {
    return userService.removeRole(request.params.id)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['role.delete']
    },
    cors: {
      origin: ['*']
    }
  }
}

const roles4 = {
  method: 'PUT',
  path: '/role/{id}',
  handler: async (request, reply) => {
    return userService.updateRole(request.params.id, request.payload.name)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['role.update']
    },
    cors: {
      origin: ['*']
    }
  }
}

const roles5 = {
  method: 'POST',
  path: '/role',
  handler: async (request, reply) => {
    return userService.addRole(request.payload.name)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['role.create']
    },
    cors: {
      origin: ['*']
    }
  }
}

const roles6 = {
  method: 'POST',
  path: '/role/action',
  handler: async (request, reply) => {
    return userService.addActionToRole(request.payload.action_id, request.payload.role_id)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['role_action.create']
    },
    cors: {
      origin: ['*']
    }
  }
}

const roles8 = {
  method: 'DELETE',
  path: '/role/action',
  handler: async (request, reply) => {
    return userService.removeActionToRole(request.payload.action_id, request.payload.role_id)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['role_action.delete']
    },
    cors: {
      origin: ['*']
    }
  }
}

const roles9 = {
  method: 'DELETE',
  path: '/role/user',
  handler: async (request, reply) => {
    return userService.userRemoveRole(request.payload.role_id, request.payload.user_id)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['user_role.delete']
    },
    cors: {
      origin: ['*']
    }
  }
}

const roles7 = {
  method: 'POST',
  path: '/role/user',
  handler: async (request, reply) => {
    return userService.userAddRole(request.payload.role_id, request.payload.user_id)
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['user_role.create']
    },
    cors: {
      origin: ['*']
    }
  }
}

const roles10 = {
  method: 'GET',
  path: '/action',
  handler: async (request, reply) => {
    return userService.actions()
  },
  config: {
    auth: {
      strategy: 'helpdoctor',
      scope: ['action.list']
    },
    cors: {
      origin: ['*']
    }
  }
}

module.exports = {
  roles,
  roles2,
  roles3,
  roles4,
  roles5,
  roles6,
  roles7,
  roles8,
  roles9,
  roles10
}
