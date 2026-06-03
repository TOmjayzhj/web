package common.example.servlet;

import common.example.dao.ProductReviewDAO;
import common.example.model.ProductReview;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("productId");
        
        if (productId == null || productId.trim().isEmpty()) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"商品ID不能为空\"}");
            return;
        }
        
        List<ProductReview> reviews = ProductReviewDAO.getReviewsByProductId(productId);
        double avgRating = ProductReviewDAO.getAverageRating(productId);
        int reviewCount = ProductReviewDAO.getReviewCount(productId);
        
        // 检查用户是否可以评价
        HttpSession session = request.getSession(false);
        boolean canReview = false;
        
        if (session != null) {
            String username = (String) session.getAttribute("username");
            if (username != null) {
                canReview = ProductReviewDAO.hasUserPurchased(username, productId);
            }
        }
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.write("{");
        out.write("\"success\":true,");
        out.write("\"reviews\":[");
        
        for (int i = 0; i < reviews.size(); i++) {
            ProductReview review = reviews.get(i);
            out.write("{");
            out.write("\"id\":" + review.getId() + ",");
            out.write("\"username\":\"" + escapeJson(review.getUsername()) + "\",");
            out.write("\"rating\":" + review.getRating() + ",");
            out.write("\"content\":\"" + escapeJson(review.getContent()) + "\",");
            out.write("\"reviewTime\":\"" + review.getReviewTime() + "\"");
            out.write("}");
            
            if (i < reviews.size() - 1) {
                out.write(",");
            }
        }
        
        out.write("],");
        out.write("\"avgRating\":" + String.format("%.1f", avgRating) + ",");
        out.write("\"reviewCount\":" + reviewCount + ",");
        out.write("\"canReview\":" + canReview);
        out.write("}");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"请先登录\"}");
            return;
        }
        
        String action = request.getParameter("action");
        
        // 删除评价（管理员）
        if ("delete".equals(action)) {
            String role = (String) session.getAttribute("role");
            if (!"admin".equals(role)) {
                response.getWriter().write("{\"success\":false,\"message\":\"权限不足\"}");
                return;
            }
            
            String reviewIdStr = request.getParameter("reviewId");
            if (reviewIdStr == null || reviewIdStr.trim().isEmpty()) {
                response.getWriter().write("{\"success\":false,\"message\":\"评价ID不能为空\"}");
                return;
            }
            
            try {
                int reviewId = Integer.parseInt(reviewIdStr);
                boolean success = ProductReviewDAO.deleteReview(reviewId);
                
                if (success) {
                    response.getWriter().write("{\"success\":true,\"message\":\"评价删除成功\"}");
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"评价删除失败\"}");
                }
            } catch (NumberFormatException e) {
                response.getWriter().write("{\"success\":false,\"message\":\"评价ID格式错误\"}");
            }
            return;
        }
        
        // 检查管理员权限
        String role = (String) session.getAttribute("role");
        if ("admin".equals(role)) {
            response.getWriter().write("{\"success\":false,\"message\":\"管理员无权评价商品\"}");
            return;
        }
        
        String username = (String) session.getAttribute("username");
        String productId = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");
        String content = request.getParameter("content");
        
        // 参数验证
        if (productId == null || productId.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"商品ID不能为空\"}");
            return;
        }
        
        if (ratingStr == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"请选择评分\"}");
            return;
        }
        
        int rating = Integer.parseInt(ratingStr);
        if (rating < 1 || rating > 5) {
            response.getWriter().write("{\"success\":false,\"message\":\"评分必须是1-5星\"}");
            return;
        }
        
        if (content == null || content.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"请输入评价内容\"}");
            return;
        }
        
        // 检查是否购买过
        if (!ProductReviewDAO.hasUserPurchased(username, productId)) {
            response.getWriter().write("{\"success\":false,\"message\":\"您还没有购买过该商品，无法评价\"}");
            return;
        }
        
        // 添加评价
        boolean success = ProductReviewDAO.addReview(productId, username, rating, content.trim());
        
        if (success) {
            response.getWriter().write("{\"success\":true,\"message\":\"评价成功\"}");
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"评价失败，请重试\"}");
        }
    }
    
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
