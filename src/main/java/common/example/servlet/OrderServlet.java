package common.example.servlet;

import common.example.dao.CartDAO;
import common.example.dao.OrderDAO;
import common.example.model.CartItem;
import common.example.model.Order;
import common.example.model.OrderItem;
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

/**
 * 订单Servlet - 处理订单相关的HTTP请求
 */
@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    
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
        String username = (String) session.getAttribute("username");
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list"; // 默认查看订单列表
        }
        
        PrintWriter out = response.getWriter();
        
        // 管理员订单管理
        if ("admin".equals(role)) {
            switch (action) {
                case "list":
                    // 获取所有订单
                    List<Order> allOrders = OrderDAO.getAllOrders();
                    out.print(convertOrdersToJson(allOrders));
                    break;
                    
                case "count":
                    // 获取订单总数
                    int allOrderCount = OrderDAO.getAllOrders().size();
                    out.print("{\"count\":" + allOrderCount + "}");
                    break;
                    
                default:
                    response.setStatus(400);
                    out.print("{\"error\":\"未知操作\"}");
                    break;
            }
            out.flush();
            return;
        }
        
        // 普通用户订单查询
        if (action.equals("list")) {
            // 获取订单列表
            List<Order> orders = OrderDAO.getUserOrders(username);
            out.print(convertOrdersToJson(orders));
        } else if (action.equals("count")) {
            // 获取订单数量
            int orderCount = OrderDAO.getUserOrders(username).size();
            out.print("{\"count\":" + orderCount + "}");
        } else {
            response.setStatus(400);
            out.print("{\"error\":\"未知操作\"}");
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
        String username = (String) session.getAttribute("username");
        String action = request.getParameter("action");
        
        if (action == null) {
            response.setStatus(400);
            response.getWriter().write("{\"error\":\"缺少操作参数\"}");
            return;
        }
        
        PrintWriter out = response.getWriter();
        
        // 管理员订单操作
        if ("admin".equals(role)) {
            switch (action) {
                case "ship":
                    // 发货
                    String orderId = request.getParameter("orderId");
                    if (orderId == null || orderId.isEmpty()) {
                        response.setStatus(400);
                        out.print("{\"error\":\"缺少订单ID\"}");
                        break;
                    }
                    
                    // 更新订单状态为已发货
                    OrderDAO.updateOrderStatus(orderId, "已发货");
                    out.print("{\"success\":true,\"message\":\"发货成功\"}");
                    break;
                    
                case "complete":
                    // 完成订单
                    String completeOrderId = request.getParameter("orderId");
                    if (completeOrderId == null || completeOrderId.isEmpty()) {
                        response.setStatus(400);
                        out.print("{\"error\":\"缺少订单ID\"}");
                        break;
                    }
                    
                    // 更新订单状态为已完成
                    OrderDAO.updateOrderStatus(completeOrderId, "已完成");
                    out.print("{\"success\":true,\"message\":\"订单已完成\"}");
                    break;
                    
                default:
                    response.setStatus(400);
                    out.print("{\"error\":\"未知操作\"}");
                    break;
            }
            out.flush();
            return;
        }
        
        // 普通用户订单操作
        switch (action) {
            case "checkout":
                // 结算：将购物车商品转为订单
                List<CartItem> cartItems = CartDAO.getCart(username);
                
                if (cartItems == null || cartItems.isEmpty()) {
                    response.setStatus(400);
                    out.print("{\"error\":\"购物车为空\"}");
                    break;
                }
                
                // 创建订单
                Order order = OrderDAO.createOrder(username, cartItems);
                
                if (order != null) {
                    // 清空购物车
                    CartDAO.clearCart(username);
                    
                    out.print("{\"success\":true,\"message\":\"订单创建成功\",\"orderId\":\"" + order.getOrderId() + "\"}");
                } else {
                    response.setStatus(500);
                    out.print("{\"error\":\"订单创建失败\"}");
                }
                break;
                
            default:
                response.setStatus(400);
                out.print("{\"error\":\"未知操作\"}");
                break;
        }
        
        out.flush();
    }
    
    /**
     * 将订单列表转换为JSON
     */
    private String convertOrdersToJson(List<Order> orders) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"count\":").append(orders.size()).append(",");
        json.append("\"orders\":[");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        for (int i = 0; i < orders.size(); i++) {
            Order order = orders.get(i);
            json.append("{");
            json.append("\"orderId\":\"").append(order.getOrderId()).append("\",");
            json.append("\"username\":\"").append(order.getUsername()).append("\",");
            json.append("\"totalAmount\":").append(String.format("%.2f", order.getTotalAmount())).append(",");
            json.append("\"orderTime\":\"").append(dateFormat.format(order.getOrderTime())).append("\",");
            json.append("\"status\":\"").append(order.getStatus()).append("\",");
            json.append("\"items\":[");
            
            List<OrderItem> items = order.getItems();
            for (int j = 0; j < items.size(); j++) {
                OrderItem item = items.get(j);
                json.append("{");
                json.append("\"productId\":\"").append(item.getProductId()).append("\",");
                json.append("\"productName\":\"").append(item.getProductName()).append("\",");
                json.append("\"icon\":\"").append(item.getIcon()).append("\",");
                json.append("\"price\":").append(item.getPrice()).append(",");
                json.append("\"quantity\":").append(item.getQuantity()).append(",");
                json.append("\"subtotal\":").append(String.format("%.2f", item.getSubtotal()));
                json.append("}");
                
                if (j < items.size() - 1) {
                    json.append(",");
                }
            }
            
            json.append("]");
            json.append("}");
            
            if (i < orders.size() - 1) {
                json.append(",");
            }
        }
        
        json.append("]");
        json.append("}");
        
        return json.toString();
    }
}
