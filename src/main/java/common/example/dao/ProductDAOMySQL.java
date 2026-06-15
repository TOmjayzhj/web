package common.example.dao;

import common.example.model.Product;
import common.example.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductDAOMySQL {
    
    public static List<Product> getProductsByCategory(String category) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, name, category, icon, price FROM products WHERE category = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getString("id"));
                product.setName(rs.getString("name"));
                product.setCategory(rs.getString("category"));
                product.setIcon(rs.getString("icon"));
                product.setPrice(rs.getDouble("price"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn);
            closeResource(pstmt, rs);
        }
        return products;
    }
    
    public static Product getProductById(String productId) {
        String sql = "SELECT id, name, category, icon, price FROM products WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                Product product = new Product();
                product.setId(rs.getString("id"));
                product.setName(rs.getString("name"));
                product.setCategory(rs.getString("category"));
                product.setIcon(rs.getString("icon"));
                product.setPrice(rs.getDouble("price"));
                return product;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn);
            closeResource(pstmt, rs);
        }
        return null;
    }
    
    public static boolean addProduct(Product product) {
        String sql = "INSERT INTO products (id, name, category, icon, price) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, product.getId());
            pstmt.setString(2, product.getName());
            pstmt.setString(3, product.getCategory());
            pstmt.setString(4, product.getIcon());
            pstmt.setDouble(5, product.getPrice());
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn);
            closeResource(pstmt, null);
        }
    }
    
    // 动态拼SQL更新商品字段
    public static boolean updateProduct(String productId, String name, Double price, String icon) {
        StringBuilder sql = new StringBuilder("UPDATE products SET ");
        List<Object> params = new ArrayList<>();
        
        if (name != null) {
            sql.append("name = ?, ");
            params.add(name);
        }
        if (price != null && price > 0) {
            sql.append("price = ?, ");
            params.add(price);
        }
        if (icon != null) {
            sql.append("icon = ?, ");
            params.add(icon);
        }
        if (params.isEmpty()) {
            return false;
        }
        
        sql.setLength(sql.length() - 2); // 去掉末尾逗号
        sql.append(" WHERE id = ?");
        params.add(productId);
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn);
            closeResource(pstmt, null);
        }
    }
    
    public static boolean deleteProduct(String productId) {
        String sql = "DELETE FROM products WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn);
            closeResource(pstmt, null);
        }
    }
    
    // 按关键字模糊搜索
    public static List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, name, category, icon, price FROM products WHERE name LIKE ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getString("id"));
                product.setName(rs.getString("name"));
                product.setCategory(rs.getString("category"));
                product.setIcon(rs.getString("icon"));
                product.setPrice(rs.getDouble("price"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn);
            closeResource(pstmt, rs);
        }
        return products;
    }
    
    // 搜索并封装成Map返回
    public static Map<String, Object> searchProductsWithResult(String keyword) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> foundProducts = new ArrayList<>();
        
        if (keyword == null || keyword.trim().isEmpty()) {
            result.put("found", false);
            result.put("products", foundProducts);
            return result;
        }
        
        List<Product> products = searchProducts(keyword);
        for (Product product : products) {
            Map<String, Object> productInfo = new HashMap<>();
            productInfo.put("id", product.getId());
            productInfo.put("name", product.getName());
            productInfo.put("icon", product.getIcon());
            productInfo.put("price", product.getPrice());
            productInfo.put("category", product.getCategory());
            foundProducts.add(productInfo);
        }
        
        result.put("found", !foundProducts.isEmpty());
        result.put("products", foundProducts);
        return result;
    }
    
    // 统计某商品被买了多少次
    public static int getProductOrderCount(String productId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) as total FROM order_items WHERE product_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn);
            closeResource(pstmt, rs);
        }
        return 0;
    }
    
    // 关资源
    private static void closeResource(PreparedStatement pstmt, ResultSet rs) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (pstmt != null) {
            try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
