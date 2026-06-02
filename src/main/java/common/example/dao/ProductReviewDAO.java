package common.example.dao;

import common.example.model.ProductReview;
import common.example.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 商品评价数据访问对象
 */
public class ProductReviewDAO {
    
    /**
     * 添加商品评价
     * @param productId 商品ID
     * @param username 用户名
     * @param rating 评分(1-5)
     * @param content 评价内容
     * @return 是否成功
     */
    public static boolean addReview(String productId, String username, int rating, String content) {
        String sql = "INSERT INTO product_reviews (product_id, username, rating, content) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, productId);
            pstmt.setString(2, username);
            pstmt.setInt(3, rating);
            pstmt.setString(4, content);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("[ProductReviewDAO] 添加评价失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 获取商品的所有评价
     * @param productId 商品ID
     * @return 评价列表
     */
    public static List<ProductReview> getReviewsByProductId(String productId) {
        List<ProductReview> reviews = new ArrayList<>();
        String sql = "SELECT id, product_id, username, rating, content, review_time FROM product_reviews WHERE product_id = ? ORDER BY review_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, productId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ProductReview review = new ProductReview(
                        rs.getInt("id"),
                        rs.getString("product_id"),
                        rs.getString("username"),
                        rs.getInt("rating"),
                        rs.getString("content"),
                        rs.getTimestamp("review_time")
                    );
                    reviews.add(review);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[ProductReviewDAO] 获取评价失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    /**
     * 获取商品的平均评分
     * @param productId 商品ID
     * @return 平均评分
     */
    public static double getAverageRating(String productId) {
        String sql = "SELECT AVG(rating) as avg_rating FROM product_reviews WHERE product_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, productId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avg_rating");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[ProductReviewDAO] 获取平均评分失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    /**
     * 获取商品的评价数量
     * @param productId 商品ID
     * @return 评价数量
     */
    public static int getReviewCount(String productId) {
        String sql = "SELECT COUNT(*) as count FROM product_reviews WHERE product_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, productId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[ProductReviewDAO] 获取评价数量失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * 检查用户是否购买过该商品
     * @param username 用户名
     * @param productId 商品ID
     * @return 是否购买过
     */
    public static boolean hasUserPurchased(String username, String productId) {
        String sql = "SELECT COUNT(*) as count FROM orders o " +
                    "INNER JOIN order_items oi ON o.id = oi.order_id " +
                    "WHERE o.username = ? AND oi.product_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, productId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[ProductReviewDAO] 检查购买记录失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * 检查用户是否已经评价过该商品
     * @param username 用户名
     * @param productId 商品ID
     * @return 是否已评价
     */
    public static boolean hasUserReviewed(String username, String productId) {
        String sql = "SELECT COUNT(*) as count FROM product_reviews WHERE username = ? AND product_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, productId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("[ProductReviewDAO] 检查评价记录失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * 删除评价（管理员功能）
     * @param reviewId 评价ID
     * @return 是否删除成功
     */
    public static boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM product_reviews WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reviewId);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("[ProductReviewDAO] 删除评价失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
