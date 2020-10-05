package com.atguigu.scw.config;

import com.atguigu.scw.service.impl.UserDetailsServiceImpl;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.configurers.FormLoginConfigurer;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.MessageDigestPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Configuration
@EnableWebSecurity  //启用SpringSecurity功能
@EnableGlobalMethodSecurity(prePostEnabled = true) //启用security通过PreAuthorize注解控制方法的访问权限
public class AppSecurityConfig extends WebSecurityConfigurerAdapter {
    //向spring容器中注入一个PasswordEncoder的对象，springsecurity会自动获取使用
    @Bean //在方法上使用可以将方法的返回值对象注入到容器中
    public PasswordEncoder getPasswordEncoder(){
        //md5的加密处理器
        return new MessageDigestPasswordEncoder("md5");
    }

    @Autowired
    UserDetailsServiceImpl userDetailsService;
    @Override //认证配置
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        /*auth.inMemoryAuthentication() //在内存中写死账号密码信息,一般测试使用
            .withUser("admin").password("e10adc3949ba59abbe56e057f20f883e").roles("ADMIN" , "BOSS")//会自动在每个字符串前拼接"ROLE_"前缀
            .and()
            .withUser("laozhang").password("e10adc3949ba59abbe56e057f20f883e").authorities("user:add" , "user:delete");
        */
        auth.userDetailsService(userDetailsService);
    }



    @Override //授权配置
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests().antMatchers("/","/index","/index.html","/static/**","/admin/login.html").permitAll().anyRequest().authenticated();

        // 禁用CSRF功能：防跨站点攻击
        http.csrf().disable();

        //指定登录请求提交的路径、登录表单提交的请求参数key、登录成功和登录失败的跳转
        http.formLogin()
//                .loginPage("/admin/login.html")
                .loginProcessingUrl("/admin/login") //登录表单提交的地址
                .usernameParameter("loginacct") //登录表单提交登录账号的key
                .passwordParameter("userpswd")  //登录表单提交密码的key
                .successHandler(new AuthenticationSuccessHandler() {
                    @Override
                    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
                        response.sendRedirect(request.getContextPath()+"/admin/main.html"); //重定向
                    }
                })//登录成功跳转的处理配置
                .failureHandler(new AuthenticationFailureHandler() {
                    @Override
                    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {
                        //转发到登录页面
                        request.setAttribute("errorMsg","账号或密码错误.........");
                        request.getRequestDispatcher("/admin/login.html").forward(request,response);
                    }
                }); //登录失败处理的配置

        //springsecurity接管注销请求
        http.logout()
                .logoutUrl("/admin/logout") //注销提交的请求url
                .logoutSuccessHandler(new LogoutSuccessHandler() {
                    @Override
                    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
                        response.sendRedirect(request.getContextPath()+"/admin/login.html");
                    }
                });//注销成功的处理配置

        http.exceptionHandling().accessDeniedHandler(new AccessDeniedHandler() {
            @Override
            public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) throws IOException, ServletException {
                //判断是同步请求还是异步请求，如果是同步请求则跳转到自定义的异常页面；如果是同步请求，则响应一个简洁的错误信息提示
                //如何判断是异步请求？异步请求报文头中包含：X-Requested-With: XMLHttpRequest
                if("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))){
                    response.setContentType("application/json;charset=UTF-8");
                    Map map = new HashMap<>();
                    map.put("code",10001);//10001表示403
                    map.put("msg", accessDeniedException.getMessage());
                    response.getWriter().write(new Gson().toJson(map));
                }
                else { //否则就是同步请求，跳转到自定义的异常页面
                    String errorMsg = accessDeniedException.getMessage();
                    request.setAttribute("errorMsg", errorMsg);
                    request.getRequestDispatcher("/WEB-INF/pages/error/403.jsp").forward(request, response);  //转发到异常页面
                }
            }
        });
    }
}
