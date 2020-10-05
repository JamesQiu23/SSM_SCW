package com.atguigu.scw.controller;

import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.mapper.TMenuMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DispatcherController {
    /*自动装配Mapper*/
    @Autowired
    TMenuMapper menuMapper;

    @RequestMapping(value = {"/","index","index.html","index.jsp"}, method = RequestMethod.GET)
    public String toIndex(){
        System.out.println("到了toIndex方法内");
        return "index";
    }

}