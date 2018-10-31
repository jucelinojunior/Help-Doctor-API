const User = require('../models/users')
const Role = require('../models/roles')
const RoleHasAction = require('../models/roles_has_actions')
const RoleHasUser = require('../models/users_has_roles')
const Actions = require('../models/actions')
const Address = require('../models/address')

const getActionsByRoles = async (roles = []) => {
  roles = !Array.isArray(roles) ? [roles] : roles

  return Actions.findAll({
    include: [
      {
        model: Actions,
        as: 'actions',
        required: false,
        attributes: ['id', 'name']
      }
    ]
  })
}

const actions = async () => {
  return await Actions.findAll({

  });
}

const getAllRoles = async () => {
  
  return await Role.findAll({
    include: [
      {
        model: Actions,
        as: 'actions',
        required: false,
        attributes: ['id', 'name']
      }
    ]
  });

}

const getRole = async (id) => {
  
  return await Role.findOne({
    where: {id: id},
    include: [
      {
        model: Actions,
        as: 'actions',
        required: false,
        attributes: ['id', 'name']
      }
    ]
  });

}

const addRole = async (name) => {
  var role = new Role();
  role.name = name;
  return role.save().then(()=>{
      return role;
  }).catch(err => {
    return {errors: true, data: 'Não foi possivel criar Role'}
  });
}

const updateRole = async (id,name) => {
  var role = await Role.findOne({
    where: {id: id}
  });
  
  role.name = name;
  
  return role.save().then(()=>{
      return role;
  }).catch(err => {
    return {errors: true, data: 'Não foi possivel atualizar Role'}
  });

}

const addActionToRole = async (action_id,role_id) => {
  var role = new RoleHasAction();

  role.action_id = action_id;
  role.role_id = role_id;
  
  return role.save().then(()=>{
      return role;
  }).catch(err => {
    return {errors: true, data: 'Não foi possivel atualizar Role',err: err}
  });

}

const removeActionToRole = async (action_id,role_id) => {
  return await RoleHasAction.destroy({
    where: {action_id: action_id,role_id: role_id}
  });
}

const removeRole = async (id) => {
  return await Role.destroy({
    where: {id: id}
  });
}

const userAddRole = async (role_id,user_id) => {
  var role = new RoleHasUser();

  role.user_id = user_id;
  role.role_id = role_id;
  
  return role.save().then(()=>{
      return role;
  }).catch(err => {
    return {errors: true, data: 'Não foi possivel atualizar Role'}
  });
}

const userRemoveRole = async (role_id,user_id) => { 
  return await RoleHasUser.destroy({
    where: {user_id: user_id,role_id: role_id}
  });
}

module.exports = {
  getActionsByRoles,
  addRole,
  updateRole,
  addActionToRole,
  removeRole,
  removeActionToRole,
  getAllRoles,
  getRole,
  userAddRole,
  userRemoveRole,
  actions
}
