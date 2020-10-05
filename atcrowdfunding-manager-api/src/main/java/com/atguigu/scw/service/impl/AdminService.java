package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.TAdmin;

import java.util.List;

public interface AdminService {
    public TAdmin login(String loginacct, String userpswd);

    public List<TAdmin> getAdminList(String condition);

    public void saveAdmin(TAdmin admin);

    public void deleteAdmin(Integer id);

    public void batchDelAdmins(List<Integer> list);

    public void updateAdmin(TAdmin admin);

    public TAdmin getAdminById(Integer id);

}
