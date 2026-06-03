package common.example.servlet;

import common.example.dao.UserDAO;
import common.example.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 处理注册请求
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // 参数验证
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "用户名不能为空");
            request.setAttribute("showRegister", true);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "密码不能为空");
            request.setAttribute("showRegister", true);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的密码不一致");
            request.setAttribute("showRegister", true);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // 检查用户名是否已存在
        User existingUser = UserDAO.getUserByUsername(username);
        if (existingUser != null) {
            request.setAttribute("error", "用户名已存在");
            request.setAttribute("showRegister", true);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // 注册用户
        boolean success = UserDAO.registerUser(username, password, User.ROLE_CUSTOMER);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/login?register=success");
        } else {
            request.setAttribute("error", "注册失败，请稍后重试");
            request.setAttribute("showRegister", true);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
