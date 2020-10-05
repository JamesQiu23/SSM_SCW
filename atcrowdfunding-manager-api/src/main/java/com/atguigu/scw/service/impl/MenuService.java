package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.TAdmin;
import com.atguigu.scw.bean.TMenu;

import java.util.List;

public interface MenuService {
    public List<TMenu> getPMenus();

    public void addMenu(TMenu tMenu);

    public TMenu getMenu(Integer id);

    public void updateMenu(TMenu tMenu);

    public void deleteMenu(Integer id);
}


