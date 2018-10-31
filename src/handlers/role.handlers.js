const userService = require('../services/role.service');

const roles = {
  method: 'GET',
  path: '/role',
  handler: async (request, reply) => {
    return userService.getAllRoles();
  }
}

const roles2 = {
  method: 'GET',
  path: '/role/{id}',
  handler: async (request, reply) => {
    return userService.getRole(request.params.id);
  }
}

const roles3 = {
  method: 'DELETE',
  path: '/role/{id}',
  handler: async (request, reply) => {
    return userService.removeRole(request.params.id);
  }
}

const roles4 = {
  method: 'PUT',
  path: '/role/{id}',
  handler: async (request, reply) => {
    return userService.updateRole(request.params.id,request.payload.name);
  }
}

const roles5 = {
  method: 'POST',
  path: '/role',
  handler: async (request, reply) => {
    return userService.addRole(request.payload.name);
  }
}

const roles6 = {
  method: 'POST',
  path: '/role/action',
  handler: async (request, reply) => {
    return userService.addActionToRole(request.payload.action_id,request.payload.role_id);
  }
}

const roles8 = {
  method: 'DELETE',
  path: '/role/action',
  handler: async (request, reply) => {
    return userService.removeActionToRole(request.payload.action_id,request.payload.role_id);
  }
}

const roles9 = {
  method: 'DELETE',
  path: '/role/user',
  handler: async (request, reply) => {
    return userService.userRemoveRole(request.payload.role_id,request.payload.user_id);
  }
}

const roles7 = {
  method: 'POST',
  path: '/role/user',
  handler: async (request, reply) => {
    return userService.userAddRole(request.payload.role_id,request.payload.user_id);
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
  roles9
}