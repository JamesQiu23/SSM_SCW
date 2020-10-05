package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.TRole;

import java.util.List;

public interface RoleService {
    public List<TRole> getRoles(String condition);

    public Integer delete(Integer id);

    public int batchDelRoles(List<Integer> list);

    public Integer addRole(TRole tRole);

    public Integer updateRole(TRole tRole);

    public TRole getRoleById(Integer id);

    public List<Integer> getAssignedRoleIdsByAdminid(Integer id);

    public void assignRolesToAdmin(Integer adminId, List<Integer> roleIds);

    public void unAssignRolesToAdmin(Integer adminId, List<Integer> roleIds);
}
