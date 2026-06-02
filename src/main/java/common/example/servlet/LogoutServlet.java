package common.example.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 获取当前会话并使其失效
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // 重定向到登录页面（使用Servlet映射路径）
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
