package com.atguigu.scw.controller;

import com.atguigu.scw.bean.TAdmin;
import com.atguigu.scw.bean.TRole;
import com.atguigu.scw.service.impl.RoleService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping(value = "/role")
public class RoleController {
    @Autowired
    RoleService roleService;

    @RequestMapping(value = "index")
    public String rolePage(){
        return "/role/role";
    }

    @ResponseBody
    @RequestMapping(value = "/getRoles")
    public PageInfo<TRole> getRoles(Model model,HttpSession session,
                                @RequestParam(value = "pageNum",defaultValue = "1",required = false)Integer pageNum,
                                @RequestParam(value = "condition", defaultValue = "", required = false) String condition){

        Page<Object> objects = PageHelper.startPage(pageNum, 3);
        List<TRole> roles = roleService.getRoles(condition);
        PageInfo<TRole> pageInfo = new PageInfo<>(roles,5);
        return pageInfo;
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public String delete(Integer id){
        Integer i = roleService.delete(id);
        if(i == 1){
            return "ok";
        }
        return "false";
    }

    @ResponseBody
    @RequestMapping(value = "/batchDelRoles")
    public String batchDelRoles(@RequestParam("ids")List<Integer> ids){
        int size = ids.size();
        int influence = roleService.batchDelRoles(ids);
        return size==influence ? "ok":"fail";
    }

    @ResponseBody
    @RequestMapping(value = "/addRole")
    public String  addRole(TRole tRole){
        Integer refluence = roleService.addRole(tRole);
        return refluence==1 ? "ok":"fail";
    }


    @ResponseBody
    @RequestMapping(value = "/updateRole")
    public String updateRole(TRole tRole){
        Integer influence = roleService.updateRole(tRole);
        return influence==1 ? "ok":"false";
    }

    @ResponseBody
    @RequestMapping(value = "/getRoleById")
    public TRole getRoleById(Integer id){
        TRole roleById = roleService.getRoleById(id);
        return roleById;
    }
}
