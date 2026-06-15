package common.example.servlet;

import common.example.dao.CartDAO;
import common.example.model.CartItem;
import common.example.model.Product;
import common.example.dao.ProductDAOMySQL;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    
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
        if ("admin".equals(role)) {
            response.setStatus(403);
            response.getWriter().write("{\"error\":\"管理员无权访问此功能\"}");
            return;
        }
        
        String username = (String) session.getAttribute("username");
        String action = request.getParameter("action");
        if (action == null) action = "view";
        
        PrintWriter out = response.getWriter();
        
        switch (action) {
            case "view":
                List<CartItem> cart = CartDAO.getCart(username);
                double total = CartDAO.getTotalPrice(username);
                int count = CartDAO.getItemCount(username);
                out.print(convertCartToJson(cart, total, count));
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
        
        String postRole = (String) session.getAttribute("role");
        if ("admin".equals(postRole)) {
            response.setStatus(403);
            response.getWriter().write("{\"error\":\"管理员无权访问此功能\"}");
            return;
        }
        
        String username = (String) session.getAttribute("username");
        String action = request.getParameter("action");
        
        if (action == null) {
            response.setStatus(400);
            response.getWriter().write("{\"error\":\"缺少操作参数\"}");
            return;
        }
        
        PrintWriter out = response.getWriter();
        
        switch (action) {
            case "add":
                String productId = request.getParameter("productId");
                String quantityStr = request.getParameter("quantity");
                int quantity;
                try {
                    quantity = Integer.parseInt(quantityStr);
                } catch (NumberFormatException e) {
                    response.setStatus(400);
                    out.print("{\"error\":\"参数格式错误\"}");
                    break;
                }
                
                Product product = ProductDAOMySQL.getProductById(productId);
                if (product == null) {
                    response.setStatus(404);
                    out.print("{\"error\":\"商品不存在\"}");
                    break;
                }
                
                CartItem item = new CartItem(
                    product.getId(), product.getName(), product.getIcon(),
                    product.getPrice(), quantity
                );
                CartDAO.addToCart(username, item);
                
                int itemCount = CartDAO.getItemCount(username);
                out.print("{\"success\":true,\"message\":\"添加成功\",\"itemCount\":" + itemCount + "}");
                break;
                
            case "update":
                String updateProductId = request.getParameter("productId");
                int newQuantity;
                try {
                    newQuantity = Integer.parseInt(request.getParameter("quantity"));
                } catch (NumberFormatException e) {
                    response.setStatus(400);
                    out.print("{\"error\":\"参数格式错误\"}");
                    break;
                }
                CartDAO.updateQuantity(username, updateProductId, newQuantity);
                out.print("{\"success\":true,\"message\":\"更新成功\"}");
                break;
                
            case "remove":
                String removeProductId = request.getParameter("productId");
                CartDAO.removeFromCart(username, removeProductId);
                out.print("{\"success\":true,\"message\":\"删除成功\"}");
                break;
                
            case "clear":
                CartDAO.clearCart(username);
                out.print("{\"success\":true,\"message\":\"购物车已清空\"}");
                break;
                
            default:
                response.setStatus(400);
                out.print("{\"error\":\"未知操作\"}");
                break;
        }
        out.flush();
    }
    
    private String convertCartToJson(List<CartItem> cart, double total, int count) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"count\":").append(count).append(",");
        json.append("\"total\":").append(String.format("%.2f", total)).append(",");
        json.append("\"items\":[");
        
        for (int i = 0; i < cart.size(); i++) {
            CartItem item = cart.get(i);
            json.append("{");
            json.append("\"productId\":\"").append(item.getProductId()).append("\",");
            json.append("\"productName\":\"").append(item.getProductName()).append("\",");
            json.append("\"icon\":\"").append(item.getIcon()).append("\",");
            json.append("\"price\":").append(item.getPrice()).append(",");
            json.append("\"quantity\":").append(item.getQuantity()).append(",");
            json.append("\"subtotal\":").append(String.format("%.2f", item.getSubtotal()));
            json.append("}");
            if (i < cart.size() - 1) json.append(",");
        }
        
        json.append("]}");
        return json.toString();
    }
}
