package common.example.servlet;

import common.example.dao.ProductReviewDAO;
import common.example.dao.UserDAO;
import common.example.model.ProductReview;
import common.example.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/user_manage")
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.setStatus(401);
            response.getWriter().write("{\"error\":\"未登录\"}");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.setStatus(403);
            response.getWriter().write("{\"error\":\"无权限\"}");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        PrintWriter out = response.getWriter();

        switch (action) {
            case "list":
                List<User> users = UserDAO.getAllUsers();
                out.print(buildUserListJson(users));
                break;

            case "reviews":
                String reviewUsername = request.getParameter("username");
                if (reviewUsername == null || reviewUsername.isEmpty()) {
                    response.setStatus(400);
                    out.print("{\"error\":\"缺少用户名参数\"}");
                    break;
                }
                List<ProductReview> reviews = ProductReviewDAO.getReviewsByUsername(reviewUsername);
                out.print(buildReviewsJson(reviews));
                break;

            default:
                response.setStatus(400);
                out.print("{\"error\":\"未知操作\"}");
                break;
        }
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.setStatus(401);
            response.getWriter().write("{\"error\":\"未登录\"}");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.setStatus(403);
            response.getWriter().write("{\"error\":\"无权限\"}");
            return;
        }

        String action = request.getParameter("action");
        PrintWriter out = response.getWriter();

        if ("update_role".equals(action)) {
            String username = request.getParameter("username");
            String newRole = request.getParameter("newRole");

            if (username == null || newRole == null) {
                response.setStatus(400);
                out.print("{\"error\":\"缺少参数\"}");
                out.flush();
                return;
            }

            // 不允许修改自己的权限
            String currentUsername = (String) session.getAttribute("username");
            if (currentUsername.equals(username)) {
                out.print("{\"success\":false,\"error\":\"不能修改自己的权限\"}");
                out.flush();
                return;
            }

            if (!"admin".equals(newRole) && !"customer".equals(newRole)) {
                response.setStatus(400);
                out.print("{\"error\":\"无效的角色值\"}");
                out.flush();
                return;
            }

            boolean success = UserDAO.updateUserRole(username, newRole);
            if (success) {
                out.print("{\"success\":true,\"message\":\"权限修改成功\"}");
            } else {
                out.print("{\"success\":false,\"error\":\"权限修改失败\"}");
            }
        } else {
            response.setStatus(400);
            out.print("{\"error\":\"未知操作\"}");
        }
        out.flush();
    }

    /** 构建用户列表JSON（含订单数、消费金额、评价数） */
    private String buildUserListJson(List<User> users) {
        StringBuilder json = new StringBuilder();
        json.append("{\"users\":[");

        for (int i = 0; i < users.size(); i++) {
            User u = users.get(i);
            int orderCount = UserDAO.getUserOrderCount(u.getUsername());
            double totalSpending = UserDAO.getUserTotalSpending(u.getUsername());
            int reviewCount = UserDAO.getUserReviewCount(u.getUsername());

            json.append("{");
            json.append("\"username\":\"").append(escapeJson(u.getUsername())).append("\",");
            json.append("\"role\":\"").append(escapeJson(u.getRole())).append("\",");
            json.append("\"orderCount\":").append(orderCount).append(",");
            json.append("\"totalSpending\":").append(String.format("%.2f", totalSpending)).append(",");
            json.append("\"reviewCount\":").append(reviewCount);
            json.append("}");

            if (i < users.size() - 1) json.append(",");
        }

        json.append("]}");
        return json.toString();
    }

    /** 构建评价列表JSON */
    private String buildReviewsJson(List<ProductReview> reviews) {
        StringBuilder json = new StringBuilder();
        json.append("{\"success\":true,\"reviews\":[");

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        for (int i = 0; i < reviews.size(); i++) {
            ProductReview r = reviews.get(i);
            json.append("{");
            json.append("\"id\":").append(r.getId()).append(",");
            json.append("\"productId\":\"").append(escapeJson(r.getProductId())).append("\",");
            json.append("\"username\":\"").append(escapeJson(r.getUsername())).append("\",");
            json.append("\"rating\":").append(r.getRating()).append(",");
            json.append("\"content\":\"").append(escapeJson(r.getContent())).append("\",");
            json.append("\"reviewTime\":\"").append(r.getReviewTime() != null ? dateFormat.format(r.getReviewTime()) : "").append("\"");
            json.append("}");

            if (i < reviews.size() - 1) json.append(",");
        }

        json.append("]}");
        return json.toString();
    }

    /** JSON字符串转义 */
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
