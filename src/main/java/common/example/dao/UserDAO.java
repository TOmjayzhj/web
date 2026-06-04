package common.example.dao;

import common.example.model.User;
import common.example.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    /** 用户登录验证 */
    public static User authenticate(String username, String password) {
        String sql = "SELECT username, password, role FROM users WHERE username = ? AND password = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] 用户验证失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /** 根据用户名查询用户 */
    public static User getUserByUsername(String username) {
        String sql = "SELECT username, password, role FROM users WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] 查询用户失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /** 获取所有用户列表 */
    public static List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT username, password, role FROM users ORDER BY username";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                User user = new User();
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                users.add(user);
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] 获取所有用户失败: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    /** 修改用户权限 */
    public static boolean updateUserRole(String username, String newRole) {
        String sql = "UPDATE users SET role = ? WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newRole);
            pstmt.setString(2, username);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("[UserDAO] 修改用户权限失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /** 获取用户订单数量 */
    public static int getUserOrderCount(String username) {
        String sql = "SELECT COUNT(*) as cnt FROM orders WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] 获取用户订单数失败: " + e.getMessage());
        }
        return 0;
    }
    
    /** 获取用户消费总金额 */
    public static double getUserTotalSpending(String username) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) as total FROM orders WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getDouble("total");
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] 获取用户消费金额失败: " + e.getMessage());
        }
        return 0.0;
    }
    
    /** 获取用户评价数量 */
    public static int getUserReviewCount(String username) {
        String sql = "SELECT COUNT(*) as cnt FROM product_reviews WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] 获取用户评价数失败: " + e.getMessage());
        }
        return 0;
    }
    
    /** 注册新用户 */
    public static boolean registerUser(String username, String password, String role) {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, role);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            // 用户名已存在
            if (e.getMessage().contains("Duplicate entry")) {
                System.err.println("[UserDAO] 用户名已存在: " + username);
            } else {
                System.err.println("[UserDAO] 注册用户失败: " + e.getMessage());
                e.printStackTrace();
            }
            return false;
        }
    }
}
