package common.example.dao;

import common.example.model.User;
import common.example.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 用户数据访问对象 - 从数据库操作用户
 */
public class UserDAO {
    
    /**
     * 根据用户名和密码验证用户登录
     * @param username 用户名
     * @param password 密码
     * @return 验证成功返回User对象，失败返回null
     */
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
    
    /**
     * 根据用户名查询用户
     * @param username 用户名
     * @return 用户对象，不存在返回null
     */
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
    
    /**
     * 注册新用户
     * @param username 用户名
     * @param password 密码
     * @param role 角色
     * @return 是否注册成功
     */
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
            // 如果是唯一键冲突（用户名已存在）
            if (e.getMessage().contains("Duplicate entry")) {
                System.err.println("[UserDAO] 用户名已存在: " + username);
            } else {
                System.err.println("[UserDAO] 注册用户失败: " + e.getMessage());
                e.printStackTrace();
            }
            return false;
        }
    }
    
    /**
     * 修改用户密码
     * @param username 用户名
     * @param newPassword 新密码
     * @return 是否修改成功
     */
    public static boolean updatePassword(String username, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newPassword);
            pstmt.setString(2, username);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("[UserDAO] 修改密码失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
