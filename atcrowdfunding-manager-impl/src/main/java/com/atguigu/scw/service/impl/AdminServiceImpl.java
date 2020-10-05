package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.TAdmin;
import com.atguigu.scw.bean.TAdminExample;
import com.atguigu.scw.mapper.TAdminMapper;
import com.atguigu.scw.utils.DateUtil;
import com.atguigu.scw.utils.MD5Util;
import com.atguigu.scw.utils.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class AdminServiceImpl implements AdminService{
    @Autowired
    TAdminMapper adminMapper;

    @Override
    public TAdmin login(String loginacct, String userpswd) {
        TAdminExample tAdminExample = new TAdminExample();
        tAdminExample.createCriteria().andLoginacctEqualTo(loginacct).andUserpswdEqualTo(MD5Util.digest(userpswd));
        System.out.println("到了service内的login方法");
        List<TAdmin> tAdmins = adminMapper.selectByExample(tAdminExample);
        if(CollectionUtils.isEmpty(tAdmins)|| tAdmins.size()>1){
            return null;
        }
        TAdmin tAdmin = tAdmins.get(0);
        return tAdmin;
    }

    @Override
    public List<TAdmin> getAdminList(String condition) {
        if(StringUtil.isEmpty(condition)){
            List<TAdmin> list1 = adminMapper.selectByExample(null);
            return list1;
        }

        //带条件的查找是将每个字段的内容都进行模糊查找
        //select * from t_admin where loginacct like '%xxx%' or username like '%xx%'  or email like '%xxx%'  limit index ,size
        TAdminExample exa = new TAdminExample();
        TAdminExample.Criteria c1 = exa.createCriteria();
        c1.andLoginacctLike("%" + condition + "%");
        TAdminExample.Criteria c2 = exa.createCriteria();
        c2.andUsernameLike("%" + condition + "%");
        TAdminExample.Criteria c3 = exa.createCriteria();
        c3.andEmailLike("%" + condition + "%");
        exa.or(c2);
        exa.or(c3);
        List<TAdmin> list2 = adminMapper.selectByExample(exa);
        return list2;
    }

    @Override
    public void saveAdmin(TAdmin admin) {
        TAdminExample exa = new TAdminExample();
        exa.createCriteria().andLoginacctEqualTo(admin.getLoginacct());
        long count0 = adminMapper.countByExample(exa);
        if(count0 > 0){
            throw new RuntimeException("帐号重复");
        }
        exa.clear();
        exa.createCriteria().andUsernameEqualTo(admin.getUsername());
        long count1 = adminMapper.countByExample(exa);
        if(count1 > 0){
            throw new RuntimeException("用户名重复");
        }
        exa.clear();
        exa.createCriteria().andEmailEqualTo(admin.getEmail());
        long count2 = adminMapper.countByExample(exa);
        if(count2 > 0){
            throw new RuntimeException("邮箱重复");
        }

        admin.setCreatetime(DateUtil.getFormatTime());
        admin.setUserpswd(MD5Util.digest(admin.getUserpswd()));

        adminMapper.insertSelective(admin);
    }

    @Override
    public void deleteAdmin(Integer id) {
        adminMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void batchDelAdmins(List<Integer> list) {
        //delete from t_admin where id in (1,2,3,4);
        TAdminExample exa = new TAdminExample();
        exa.createCriteria().andIdIn(list);
        adminMapper.deleteByExample(exa);
    }

    @Override
    public void updateAdmin(TAdmin admin) {
        adminMapper.updateByPrimaryKeySelective(admin);
    }

    @Override
    public TAdmin getAdminById(Integer id) {
        TAdmin admin = adminMapper.selectByPrimaryKey(id);
        return admin;
    }
}
