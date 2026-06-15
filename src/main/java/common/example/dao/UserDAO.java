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
    
    // 登录验证
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
            e.printStackTrace();
        }
        return null;
    }
    
    // 根据用户名查用户
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
            e.printStackTrace();
        }
        return null;
    }
    
    // 查全部用户
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
            e.printStackTrace();
        }
        return users;
    }
    
    // 改权限
    public static boolean updateUserRole(String username, String newRole) {
        String sql = "UPDATE users SET role = ? WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newRole);
            pstmt.setString(2, username);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public static int getUserOrderCount(String username) {
        String sql = "SELECT COUNT(*) as cnt FROM orders WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public static double getUserTotalSpending(String username) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) as total FROM orders WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public static int getUserReviewCount(String username) {
        String sql = "SELECT COUNT(*) as cnt FROM product_reviews WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // 删除用户: 先删购物车，再删未完成订单，最后删用户（事务保证）
    public static boolean deleteUserByUsername(String username) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 删购物车
            String deleteCartSql = "DELETE FROM cart WHERE username = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(deleteCartSql)) {
                pstmt.setString(1, username);
                pstmt.executeUpdate();
            }

            // 删未完成订单，已完成的保留（order_items有级联删除）
            String deleteOrdersSql = "DELETE FROM orders WHERE username = ? AND status != '已完成'";
            try (PreparedStatement pstmt = conn.prepareStatement(deleteOrdersSql)) {
                pstmt.setString(1, username);
                pstmt.executeUpdate();
            }

            // 删用户
            String deleteUserSql = "DELETE FROM users WHERE username = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(deleteUserSql)) {
                pstmt.setString(1, username);
                int rows = pstmt.executeUpdate();
                if (rows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    // 查用户偏好商品类（下单最多的种类）
    public static String getUserFavoriteCategory(String username) {
        String sql = "SELECT p.category, SUM(oi.quantity) AS total " +
                     "FROM order_items oi " +
                     "JOIN orders o ON oi.order_id = o.id " +
                     "JOIN products p ON oi.product_id = p.id " +
                     "WHERE o.username = ? " +
                     "GROUP BY p.category ORDER BY total DESC LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getString("category");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    // 注册
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
            // 用户名重复
            if (e.getMessage().contains("Duplicate entry")) {
                System.out.println("用户名已存在: " + username);
            } else {
                e.printStackTrace();
            }
            return false;
        }
    }
}
