package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.mapper.TMenuMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MenuServiceImpl implements MenuService{
    @Autowired
    TMenuMapper tMenuMapper;

    @Override
    public List<TMenu> getPMenus() {
        List<TMenu> menus = tMenuMapper.selectByExample(null);
        //获取父菜单的map集合
        Map<Integer,TMenu> pMap = new HashMap<>();
        for (TMenu t : menus) {
            if(t.getPid()==0){
                pMap.put(t.getId(),t);
            }
        }

        for (TMenu t : menus) {
            if(t.getPid()!=0){
                TMenu menu = pMap.get(t.getPid());
                boolean add = menu.getChildren().add(t);
            }
        }

        return new ArrayList<TMenu>(pMap.values());
    }

    @Override
    public void addMenu(TMenu tMenu) {
        int i = tMenuMapper.insertSelective(tMenu);
    }

    @Override
    public TMenu getMenu(Integer id) {
        TMenu menu = tMenuMapper.selectByPrimaryKey(id);
        return menu;
    }

    @Override
    public void updateMenu(TMenu tMenu) {
        tMenuMapper.updateByPrimaryKeySelective (tMenu);
    }

    @Override
    public void deleteMenu(Integer id) {
        tMenuMapper.deleteByPrimaryKey(id);
    }


}
