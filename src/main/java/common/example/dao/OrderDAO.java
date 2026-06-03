package common.example.dao;

import common.example.model.CartItem;
import common.example.model.Order;
import common.example.model.OrderItem;
import common.example.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderDAO {
    
    /** 创建订单 */
    public static Order createOrder(String username, List<CartItem> cartItems) {
        if (cartItems == null || cartItems.isEmpty()) {
            return null;
        }
        
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            // 生成订单ID
            String orderId = "ORD" + System.currentTimeMillis();
            
            double totalAmount = 0.0;
            for (CartItem item : cartItems) {
                totalAmount += item.getPrice() * item.getQuantity();
            }
            
            // 插入订单
            String orderSql = "INSERT INTO orders (id, username, total_amount, status) VALUES (?, ?, ?, ?)";
            try (PreparedStatement orderPstmt = conn.prepareStatement(orderSql)) {
                orderPstmt.setString(1, orderId);
                orderPstmt.setString(2, username);
                orderPstmt.setDouble(3, totalAmount);
                orderPstmt.setString(4, "待发货");
                orderPstmt.executeUpdate();
            }
            
            // 插入订单详情
            String itemSql = "INSERT INTO order_items (order_id, product_id, product_name, icon, price, quantity) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement itemPstmt = conn.prepareStatement(itemSql)) {
                for (CartItem cartItem : cartItems) {
                    itemPstmt.setString(1, orderId);
                    itemPstmt.setString(2, cartItem.getProductId());
                    itemPstmt.setString(3, cartItem.getProductName());
                    itemPstmt.setString(4, cartItem.getIcon());
                    itemPstmt.setDouble(5, cartItem.getPrice());
                    itemPstmt.setInt(6, cartItem.getQuantity());
                    itemPstmt.addBatch();
                }
                itemPstmt.executeBatch();
            }
            
            CartDAO.clearCart(username);
            
            conn.commit();
            
            Order order = new Order();
            order.setOrderId(orderId);
            order.setUsername(username);
            order.setTotalAmount(totalAmount);
            order.setOrderTime(new Date());
            order.setStatus("待发货");
            
            List<OrderItem> orderItems = new ArrayList<>();
            for (CartItem cartItem : cartItems) {
                OrderItem orderItem = new OrderItem(
                    cartItem.getProductId(),
                    cartItem.getProductName(),
                    cartItem.getIcon(),
                    cartItem.getPrice(),
                    cartItem.getQuantity()
                );
                orderItems.add(orderItem);
            }
            order.setItems(orderItems);
            
            return order;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            System.err.println("[OrderDAO] 创建订单失败: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /** 获取用户订单列表 */
    public static List<Order> getUserOrders(String username) {
        List<Order> orders = new ArrayList<>();
        String orderSql = "SELECT id, username, total_amount, status, order_time FROM orders WHERE username = ? ORDER BY order_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement orderPstmt = conn.prepareStatement(orderSql)) {
            
            orderPstmt.setString(1, username);
            
            try (ResultSet orderRs = orderPstmt.executeQuery()) {
                while (orderRs.next()) {
                    Order order = new Order();
                    order.setOrderId(orderRs.getString("id"));
                    order.setUsername(orderRs.getString("username"));
                    order.setTotalAmount(orderRs.getDouble("total_amount"));
                    order.setStatus(orderRs.getString("status"));
                    order.setOrderTime(orderRs.getTimestamp("order_time"));
                    
                    // 获取订单详情
                    order.setItems(getOrderItems(order.getOrderId()));
                    
                    orders.add(order);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[OrderDAO] 获取用户订单失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /** 获取订单详情 */
    private static List<OrderItem> getOrderItems(String orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT product_id, product_name, icon, price, quantity FROM order_items WHERE order_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, orderId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem(
                        rs.getString("product_id"),
                        rs.getString("product_name"),
                        rs.getString("icon"),
                        rs.getDouble("price"),
                        rs.getInt("quantity")
                    );
                    items.add(item);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[OrderDAO] 获取订单详情失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return items;
    }
    
    /** 更新订单状态 */
    public static void updateOrderStatus(String orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newStatus);
            pstmt.setString(2, orderId);
            
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("[OrderDAO] 更新订单状态失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /** 获取所有订单 */
    public static List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String orderSql = "SELECT id, username, total_amount, status, order_time FROM orders ORDER BY order_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement orderPstmt = conn.prepareStatement(orderSql);
             ResultSet orderRs = orderPstmt.executeQuery()) {
            
            while (orderRs.next()) {
                Order order = new Order();
                order.setOrderId(orderRs.getString("id"));
                order.setUsername(orderRs.getString("username"));
                order.setTotalAmount(orderRs.getDouble("total_amount"));
                order.setStatus(orderRs.getString("status"));
                order.setOrderTime(orderRs.getTimestamp("order_time"));
                
                // 获取订单详情
                order.setItems(getOrderItems(order.getOrderId()));
                
                orders.add(order);
            }
            
        } catch (SQLException e) {
            System.err.println("[OrderDAO] 获取所有订单失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return orders;
    }
    
}
