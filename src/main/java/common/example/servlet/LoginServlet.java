package common.example.servlet;

import common.example.dao.UserDAO;
import common.example.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否已经登录
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            // 已登录，根据角色重定向
            String role = (String) session.getAttribute("role");
            if ("admin".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/admin.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/shop.jsp");
            }
            return;
        }
        
        // 未登录，显示登录页面（使用forward避免双标签）
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 处理登录请求
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // 从数据库验证用户
        User loginUser = UserDAO.authenticate(username, password);
        
        // 验证用户
        if (loginUser != null) {
            // 登录成功，创建会话
            HttpSession session = request.getSession();
            session.setAttribute("username", loginUser.getUsername());
            session.setAttribute("role", loginUser.getRole());
            session.setAttribute("user", loginUser); // 存储完整的User对象
            session.setMaxInactiveInterval(30 * 60); // 30分钟超时
            
            // 根据角色重定向到不同页面
            if (loginUser.isAdmin()) {
                // 管理员跳转到管理界面
                response.sendRedirect(request.getContextPath() + "/admin.jsp");
            } else {
                // 普通用户跳转到商城页面
                response.sendRedirect(request.getContextPath() + "/shop.jsp");
            }
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
