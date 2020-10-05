package com.atguigu.scw.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class AppStartUpListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String path = sce.getServletContext().getContextPath();
        sce.getServletContext().setAttribute("PATH",path);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }
}
