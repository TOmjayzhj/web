package common.example.servlet;

import common.example.dao.CartDAO;
import common.example.dao.OrderDAO;
import common.example.dao.UserDAO;
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
        if (action == null) action = "list";
        
        PrintWriter out = response.getWriter();
        
        // 管理员看全部订单
        if ("admin".equals(role)) {
            switch (action) {
                case "list":
                    String adminStatus = request.getParameter("status");
                    List<Order> adminOrders;
                    if (adminStatus != null && !adminStatus.isEmpty() && !"all".equals(adminStatus)) {
                        adminOrders = OrderDAO.getAllOrdersByStatus(adminStatus);
                    } else {
                        adminOrders = OrderDAO.getAllOrders();
                    }
                    out.print(convertOrdersToJson(adminOrders));
                    break;
                case "count":
                    out.print("{\"count\":" + OrderDAO.getTotalOrderCount() + "}");
                    break;
                default:
                    response.setStatus(400);
                    out.print("{\"error\":\"未知操作\"}");
                    break;
            }
            out.flush();
            return;
        }
        
        // 普通用户只看自己的
        if (action.equals("list")) {
            String userStatus = request.getParameter("status");
            List<Order> userOrders;
            if (userStatus != null && !userStatus.isEmpty() && !"all".equals(userStatus)) {
                userOrders = OrderDAO.getUserOrdersByStatus(username, userStatus);
            } else {
                userOrders = OrderDAO.getUserOrders(username);
            }
            out.print(convertOrdersToJson(userOrders));
        } else if (action.equals("count")) {
            out.print("{\"count\":" + UserDAO.getUserOrderCount(username) + "}");
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
        
        // 管理员发货/完成/退款/取消订单
        if ("admin".equals(role)) {
            switch (action) {
                case "ship":
                    String orderId = request.getParameter("orderId");
                    if (orderId == null || orderId.isEmpty()) {
                        response.setStatus(400);
                        out.print("{\"error\":\"缺少订单ID\"}");
                        break;
                    }
                    OrderDAO.updateOrderStatus(orderId, "已发货");
                    out.print("{\"success\":true,\"message\":\"发货成功\"}");
                    break;
                case "complete":
                    String completeOrderId = request.getParameter("orderId");
                    if (completeOrderId == null || completeOrderId.isEmpty()) {
                        response.setStatus(400);
                        out.print("{\"error\":\"缺少订单ID\"}");
                        break;
                    }
                    OrderDAO.updateOrderStatus(completeOrderId, "已完成");
                    out.print("{\"success\":true,\"message\":\"订单已完成\"}");
                    break;
                case "receive":
                    String receiveOrderId = request.getParameter("orderId");
                    if (receiveOrderId == null || receiveOrderId.isEmpty()) {
                        response.setStatus(400);
                        out.print("{\"error\":\"缺少订单ID\"}");
                        break;
                    }
                    OrderDAO.updateOrderStatus(receiveOrderId, "已收货");
                    out.print("{\"success\":true,\"message\":\"已确认收货\"}");
                    break;
                case "refund":
                    String refundOrderId = request.getParameter("orderId");
                    if (refundOrderId == null || refundOrderId.isEmpty()) {
                        response.setStatus(400);
                        out.print("{\"error\":\"缺少订单ID\"}");
                        break;
                    }
                    OrderDAO.updateOrderStatus(refundOrderId, "已退款");
                    out.print("{\"success\":true,\"message\":\"已退款\"}");
                    break;
                case "cancel":
                    String cancelOrderId = request.getParameter("orderId");
                    if (cancelOrderId == null || cancelOrderId.isEmpty()) {
                        response.setStatus(400);
                        out.print("{\"error\":\"缺少订单ID\"}");
                        break;
                    }
                    OrderDAO.updateOrderStatus(cancelOrderId, "已取消");
                    out.print("{\"success\":true,\"message\":\"订单已取消\"}");
                    break;
                default:
                    response.setStatus(400);
                    out.print("{\"error\":\"未知操作\"}");
                    break;
            }
            out.flush();
            return;
        }
        
        // 普通用户结账/取消订单
        switch (action) {
            case "checkout":
                List<CartItem> cartItems = CartDAO.getCart(username);
                if (cartItems == null || cartItems.isEmpty()) {
                    response.setStatus(400);
                    out.print("{\"error\":\"购物车为空\"}");
                    break;
                }
                Order order = OrderDAO.createOrder(username, cartItems);
                if (order != null) {
                    out.print("{\"success\":true,\"message\":\"订单创建成功\",\"orderId\":\"" + order.getOrderId() + "\"}");
                } else {
                    response.setStatus(500);
                    out.print("{\"error\":\"订单创建失败\"}");
                }
                break;
            case "cancel":
                String cancelOrderId = request.getParameter("orderId");
                if (cancelOrderId == null || cancelOrderId.isEmpty()) {
                    response.setStatus(400);
                    out.print("{\"error\":\"缺少订单ID\"}");
                    break;
                }
                OrderDAO.updateOrderStatus(cancelOrderId, "已取消");
                out.print("{\"success\":true,\"message\":\"订单已取消\"}");
                break;
            default:
                response.setStatus(400);
                out.print("{\"error\":\"未知操作\"}");
                break;
        }
        out.flush();
    }
    
    // 把订单列表转成JSON
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
                if (j < items.size() - 1) json.append(",");
            }
            
            json.append("]}");
            if (i < orders.size() - 1) json.append(",");
        }
        
        json.append("]}");
        return json.toString();
    }
}
