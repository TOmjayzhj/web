package common.example.dao;

import common.example.model.ProductReview;
import common.example.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductReviewDAO {
    
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
            e.printStackTrace();
            return false;
        }
    }
    
    // 按商品ID查评价
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
            e.printStackTrace();
        }
        return reviews;
    }
    
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
            e.printStackTrace();
        }
        return 0.0;
    }
    
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
            e.printStackTrace();
        }
        return 0;
    }
    
    // 判断该用户是否买过这个商品（查订单关联表）
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
            e.printStackTrace();
        }
        return false;
    }
    
    // 查某用户所有评价
    public static List<ProductReview> getReviewsByUsername(String username) {
        List<ProductReview> reviews = new ArrayList<>();
        String sql = "SELECT id, product_id, username, rating, content, review_time FROM product_reviews WHERE username = ? ORDER BY review_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
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
            e.printStackTrace();
        }
        return reviews;
    }
    
    public static boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM product_reviews WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
