package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.*;
import com.atguigu.scw.mapper.TAdminRoleMapper;
import com.atguigu.scw.mapper.TRoleMapper;
import com.atguigu.scw.utils.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RoleServiceImpl implements RoleService{
    @Autowired
    TRoleMapper tRoleMapper;

    @Override
    public List<TRole> getRoles(String condition) {
        if(StringUtil.isEmpty(condition)){
            List<TRole> tRoles = tRoleMapper.selectByExample(null);
            return tRoles;
        }

        TRoleExample exa = new TRoleExample();
        TRoleExample.Criteria criteria = exa.createCriteria();
        criteria.andNameLike("%"+condition+"%");
        List<TRole> tRoles = tRoleMapper.selectByExample(exa);
        return tRoles;
    }

    @Override
    public Integer delete(Integer id) {
        int i = tRoleMapper.deleteByPrimaryKey(id);
        return i;
    }

    @Override
    public int batchDelRoles(List<Integer> list) {
        TRoleExample exa = new TRoleExample();
        exa.createCriteria().andIdIn(list);
        int influence = tRoleMapper.deleteByExample(exa);
        return influence;
    }

    @Override
    public Integer addRole(TRole tRole) {
        int influence = tRoleMapper.insertSelective(tRole);
        return influence;
    }


    @Override
    public Integer updateRole(TRole tRole) {
        int influence = tRoleMapper.updateByPrimaryKeySelective(tRole);
        return influence;
    }

    @Override
    public TRole getRoleById(Integer id) {
        TRole tRole = tRoleMapper.selectByPrimaryKey(id);
        return tRole;
    }

    @Autowired
    TAdminRoleMapper tAdminRoleMapper;
    @Override
    public List<Integer> getAssignedRoleIdsByAdminid(Integer id) {
        TAdminRoleExample exa = new TAdminRoleExample();
        exa.createCriteria().andAdminidEqualTo(id);
        List<TAdminRole> tAdminRoles = tAdminRoleMapper.selectByExample(exa);
        List<Integer> roleIds = new ArrayList<>();
        for (TAdminRole temp: tAdminRoles) {
            roleIds.add(temp.getRoleid());
        }
        return roleIds;
    }

    @Override
    public void assignRolesToAdmin(Integer adminId, List<Integer> roleIds) {
        //只需要将adminid和roleids存到t_admin_role表中即可   adminid:2 , roleids :3 , 4,5
        // insert into t_admin_role(adminid , roleid)  values(2,3),(2,4),(2,5)
        tAdminRoleMapper.batchInsertAdminRoles(adminId, roleIds);
    }

    @Override
    public void unAssignRolesToAdmin(Integer adminId, List<Integer> roleIds) {
        TAdminRoleExample exa = new TAdminRoleExample();
        exa.createCriteria().andAdminidEqualTo(adminId).andRoleidIn(roleIds);
        tAdminRoleMapper.deleteByExample(exa);
    }


}
