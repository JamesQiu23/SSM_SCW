package com.atguigu.scw.controller;

import com.atguigu.scw.bean.TAdmin;
import com.atguigu.scw.bean.TAdminExample;
import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.bean.TRole;
import com.atguigu.scw.service.impl.AdminService;
import com.atguigu.scw.service.impl.MenuService;
import com.atguigu.scw.service.impl.RoleService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;


@Controller
@RequestMapping(value = "/admin")
public class AdminController {
    @Autowired
    AdminService adminService;

    @Autowired
    MenuService menuService;

    @RequestMapping(value = "/login.html")
    public String loginPage(){
        System.out.println("到了impl模块的loginPage方法内");
        return "admin/login";
    }

/*    @RequestMapping(value = "/login")
    public String login(String loginacct, String userpswd, Model model, HttpSession session){
        TAdmin admin = adminService.login(loginacct,userpswd);
        if(admin == null){
            String errorMsg = "账号或密码错误";
            model.addAttribute("errorMsg", errorMsg);
            return "admin/login";
        }
        session.setAttribute("admin",admin);
        return "redirect:/admin/main.html";
    }*/

    @RequestMapping(value = "/main.html")
    public String mainPage(HttpSession session){
        List<TMenu> pMenus = menuService.getPMenus();
        session.setAttribute("pMenus",pMenus);
        return "admin/main";
    }


    /*@RequestMapping(value = "/logout")
    public String logout(HttpSession session){
        session.invalidate();
        return "redirect:/admin/login.html";
    }*/

    /**
     *不经过pageHelper,直接将所有数据查出，并显示在user.jsp页面上
     */
/*    @RequestMapping(value = "/index")
    public String toAdminList(Model model){
        System.out.println("到了toAdminList方法内");
        List<TAdmin> adminList = adminService.getAdminList(null);
        model.addAttribute("adminList",adminList);
        return "admin/user";
    }*/

    /**
     * 使用pageHelper进行分页，传入查询条件和要跳转的第几页数
     */
    @RequestMapping("/index")
    public String listUserList(Model model,HttpSession session,
            @RequestParam(defaultValue = "1", required = false)Integer pageNum,
            @RequestParam(defaultValue = "",required = false)String condition){
        System.out.println("到了listUserList方法内,页数是"+pageNum+"，条件是"+condition);
        //第一个参数是要跳转到第几页，第二个参数是每页显示的条目数
        Page<Object> objects = PageHelper.startPage(pageNum, 3);
        List<TAdmin> list = adminService.getAdminList(condition);
        PageInfo<TAdmin> pageInfo = new PageInfo<>(list,5);
        model.addAttribute("pageInfo",pageInfo);
        //这里是为了之后新增成员，能够从域中取到总页数，添加后页面跳到最后一页
//        session.setAttribute("pageNum",pageInfo.getPages());
        //将当前页数放到session域中，用于删除用户时跳回到当前页
        session.setAttribute("currentPageNum",pageInfo.getPageNum());
        //但是我后悔了，我认为多余，还不如直接给int的最大值；
        return "admin/user";
    }

    @RequestMapping("/add.html")
    public String addPage(){
        System.out.println("到了addPage方法");
        return "/admin/add";
    }

    @PreAuthorize("hasAnyRole('知府') or hasAnyAuthority('role:add')")
    @RequestMapping("/save")
    public String save(TAdmin admin, HttpSession session){
        System.out.println("到了save方法内");
        try {
            adminService.saveAdmin(admin);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            session.setAttribute("saveErrorMsg",e.getMessage());
            return "redirect:/admin/add.html";
        }
        return "redirect:/admin/index?pageNum=10000";
    }

    @PreAuthorize("hasAnyRole('SA - 软件架构师')")
    @RequestMapping("/delete/{id}")
    public String delete(@PathVariable("id")Integer id, HttpSession session){
        adminService.deleteAdmin(id);
        Integer currentPageNum = (Integer)session.getAttribute("currentPageNum");
        return "redirect:/admin/index?pageNum="+currentPageNum;
    }

    @RequestMapping("/batchDelAdmins")
    public String  batchDelAdmins(@RequestParam("ids")List<Integer> list, HttpSession session){
        System.out.println("要删除的所有员工的id"+list);
        adminService.batchDelAdmins(list);
        Integer currentPageNum = (Integer)session.getAttribute("currentPageNum");
        return "redirect:/admin/index?pageNum="+currentPageNum;
    }


    @RequestMapping("/update.html/{id}")
    public String updatePage(@PathVariable("id")Integer id, Model model){
        TAdmin admin = adminService.getAdminById(id);
        model.addAttribute("originalAdmin",admin);
        return "/admin/edit";
    }

    @RequestMapping("/update")
    public String update(TAdmin admin, HttpSession session){
        System.out.println("获取到的新人物是"+admin);
        adminService.updateAdmin(admin);
        Integer currentPageNum = (Integer)session.getAttribute("currentPageNum");
        return "redirect:/admin/index?pageNum="+currentPageNum;
    }

    @Autowired
    RoleService roleService;
    @RequestMapping(value = "/assignRole.html")
    public String assignRolePage(Integer id, Model model){
        List<TRole> allRoleList = roleService.getRoles(null);
        List<Integer> assignedRoleIdsByAdminid = roleService.getAssignedRoleIdsByAdminid(id);

        List<TRole> assignedRoles = new ArrayList<>();
        List<TRole> unassignedRoles = new ArrayList<>();

        for (TRole temp:allRoleList) {
            if(assignedRoleIdsByAdminid.contains(temp.getId())){
                assignedRoles.add(temp);
            }
            else{
                unassignedRoles.add(temp);
            }
        }

        model.addAttribute("assignedRoles",assignedRoles);
        model.addAttribute("unassignedRoles",unassignedRoles);

        return "admin/assignRole";
    }


    @ResponseBody
    @RequestMapping(value = "/assignRolesToAdmin")
    public String assignRolesToAdmin(Integer adminId, @RequestParam("roleIds")List<Integer> roleIds){
        System.out.println("到assignRolesToAdmin方法内了");
        roleService.assignRolesToAdmin(adminId,roleIds);
        return "ok";
    }


    @ResponseBody
    @RequestMapping(value = "/unAssignRolesToAdmin")
    public String unAssignRolesToAdmin(Integer adminId, @RequestParam("roleIds")List<Integer> roleIds){
        System.out.println("到unAssignRolesToAdmin方法内了");
        roleService.unAssignRolesToAdmin(adminId,roleIds);
        return "ok";
    }

}
