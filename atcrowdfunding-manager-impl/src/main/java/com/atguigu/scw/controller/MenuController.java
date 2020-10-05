package com.atguigu.scw.controller;

import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.service.impl.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping(value = "/menu")
public class MenuController {
    @Autowired
    MenuService menuService;

    @RequestMapping(value = "/index")
    public String menuPage(){
        return "menus/menu";
    }

    @ResponseBody
    @RequestMapping(value = "/getMenus")
    public List<TMenu> getMenus(){
        System.out.println("到达了getMenus方法");
        List<TMenu> pMenus = menuService.getPMenus();
        return pMenus;
    }


    @ResponseBody
    @RequestMapping(value = "/addMenu")
    public String addMenu(TMenu tMenu){
//        System.out.println(tMenu);
        menuService.addMenu(tMenu);
        return "ok";
    }


    @ResponseBody
    @RequestMapping(value = "/getMenu")
    public TMenu getMenu(Integer id){
        TMenu menu = menuService.getMenu(id);
        System.out.println(menu);
        return menu;
    }

    @PreAuthorize("hasAnyRole('知府')")
    @ResponseBody
    @RequestMapping(value = "/updateMenu")
    public String  updateMenu(TMenu tMenu){
        System.out.println("收到的修改的菜单是"+tMenu);
        menuService.updateMenu(tMenu);
        return "ok";
    }

    @PreAuthorize("hasAnyRole('知府')")
    @ResponseBody
    @RequestMapping(value = "/deleteMenu")
    public String  deleteMenu(Integer id){
        menuService.deleteMenu(id);
        return "ok";
    }

}
