package common.example.dao;

import common.example.model.CartItem;
import common.example.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    
    /** 添加商品到购物车 */
    public static void addToCart(String username, CartItem item) {
        String sql = "INSERT INTO cart (username, product_id, product_name, icon, price, quantity) " +
                     "VALUES (?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, item.getProductId());
            pstmt.setString(3, item.getProductName());
            pstmt.setString(4, item.getIcon());
            pstmt.setDouble(5, item.getPrice());
            pstmt.setInt(6, item.getQuantity());
            
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("[CartDAO] 添加商品到购物车失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /** 获取购物车列表 */
    public static List<CartItem> getCart(String username) {
        List<CartItem> cart = new ArrayList<>();
        String sql = "SELECT product_id, product_name, icon, price, quantity FROM cart WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem(
                        rs.getString("product_id"),
                        rs.getString("product_name"),
                        rs.getString("icon"),
                        rs.getDouble("price"),
                        rs.getInt("quantity")
                    );
                    cart.add(item);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[CartDAO] 获取购物车失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return cart;
    }
    
    /** 更新商品数量 */
    public static void updateQuantity(String username, String productId, int quantity) {
        if (quantity <= 0) {
            removeFromCart(username, productId);
            return;
        }
        
        String sql = "UPDATE cart SET quantity = ? WHERE username = ? AND product_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quantity);
            pstmt.setString(2, username);
            pstmt.setString(3, productId);
            
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("[CartDAO] 更新商品数量失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /** 删除购物车商品 */
    public static void removeFromCart(String username, String productId) {
        String sql = "DELETE FROM cart WHERE username = ? AND product_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, productId);
            
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("[CartDAO] 删除商品失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /** 清空购物车 */
    public static void clearCart(String username) {
        String sql = "DELETE FROM cart WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("[CartDAO] 清空购物车失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /** 计算购物车总价 */
    public static double getTotalPrice(String username) {
        String sql = "SELECT SUM(price * quantity) as total FROM cart WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[CartDAO] 计算总价失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    /** 获取购物车商品数量 */
    public static int getItemCount(String username) {
        String sql = "SELECT SUM(quantity) as count FROM cart WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[CartDAO] 获取商品数量失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
}
