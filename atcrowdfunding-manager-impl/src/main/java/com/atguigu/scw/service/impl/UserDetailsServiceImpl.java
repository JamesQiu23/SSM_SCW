
package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.*;
import com.atguigu.scw.mapper.TAdminMapper;
import com.atguigu.scw.mapper.TAdminRoleMapper;
import com.atguigu.scw.mapper.TPermissionMapper;
import com.atguigu.scw.mapper.TRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    TAdminMapper adminMapper;
    @Autowired
    TAdminRoleMapper adminRoleMapper;
    @Autowired
    TRoleMapper roleMapper;
    @Autowired
    TPermissionMapper permissionMapper;

     //主体对象的唯一需重写的方法就是根据用户输入的账号去数据库获取主体对象，
    // 再将主体对象中包含的从数据库获取的密码与用户输入的密码进行比对
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        //将角色名和权限名称封装为集合
        List<GrantedAuthority> authorities = new ArrayList<>();
        //根据账户名查询到用户对象
        TAdminExample exa = new TAdminExample();
        exa.createCriteria().andLoginacctEqualTo(username);
        List<TAdmin> adminList = adminMapper.selectByExample(exa);

        if(CollectionUtils.isEmpty(adminList)|| adminList.size()>1){ //账号在数据库中只能有一个
            return null; //账号不存在
        }
        TAdmin admin = adminList.get(0); //第一个也是唯一的一个
        Integer adminId = admin.getId(); //根据账户查询到用户，获取到用户id
        //根据用户id查询到"用户-角色 中间表"对象集合
        TAdminRoleExample exa2 = new TAdminRoleExample();
        exa2.createCriteria().andAdminidEqualTo(adminId);
        List<TAdminRole> adminRoles = adminRoleMapper.selectByExample(exa2);
        //根据"用户-角色 中间表"对象集合获取角色id集合
        List<Integer> roleids = new ArrayList<>();
        for (TAdminRole adminRole : adminRoles) {
            roleids.add(adminRole.getRoleid());
        }

        if(!CollectionUtils.isEmpty(roleids)){
            //根据角色id集合获取到角色集合(角色表对象集合)
            TRoleExample exa3 = new TRoleExample();
            exa3.createCriteria().andIdIn(roleids);
            List<TRole> roles = roleMapper.selectByExample(exa3);
            //根据角色集合获取到角色名的字符串集合
            List<String> rolenames = new ArrayList<>();
            for (TRole role : roles) {
                rolenames.add(role.getName());
            }
            //角色名称封装时需要手动指定ROLE_前缀
            for (String rolename : rolenames) {
                authorities.add(new SimpleGrantedAuthority("ROLE_"+rolename));
            }

            //根据角色集合获取权限名的字符串集合
            List<String> permissionnames = permissionMapper.getPermissionNamesByRoleIds(roleids);


            for (String permissionname : permissionnames) {
                authorities.add(new SimpleGrantedAuthority(permissionname));
            }
        }

        User user = new User(username, admin.getUserpswd(), authorities);
        System.out.println("主体对象 = " + user);
        //封装查询的数据为主体对象返回
        return user;
    }
}

