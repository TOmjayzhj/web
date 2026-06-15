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
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            String role = (String) session.getAttribute("role");
            if ("admin".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/admin.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/shop.jsp");
            }
            return;
        }
        
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        User loginUser = UserDAO.authenticate(username, password);
        
        if (loginUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", loginUser.getUsername());
            session.setAttribute("role", loginUser.getRole());
            session.setAttribute("user", loginUser);
            session.setMaxInactiveInterval(30 * 60);
            
            // 根据角色重定向，普通用户跳偏好商品类
            if (loginUser.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin.jsp");
            } else {
                String favCategory = UserDAO.getUserFavoriteCategory(username);
                String redirectUrl = request.getContextPath() + "/shop.jsp";
                if (favCategory != null && !favCategory.isEmpty()) {
                    redirectUrl += "?category=" + favCategory;
                }
                response.sendRedirect(redirectUrl);
            }
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
