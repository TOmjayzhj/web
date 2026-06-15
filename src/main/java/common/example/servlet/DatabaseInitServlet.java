package common.example.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet(name = "DatabaseInitServlet", loadOnStartup = 0)
public class DatabaseInitServlet extends HttpServlet {
    
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String BASE_URL = "jdbc:mysql://localhost:3306/?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "123456";
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("开始初始化数据库...");
        
        try {
            Class.forName(DRIVER);
            initializeDatabase();
            System.out.println("数据库初始化完成");
        } catch (Exception e) {
            System.out.println("数据库初始化失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void initializeDatabase() {
        Connection conn = null;
        Statement stmt = null;
        try {
            conn = DriverManager.getConnection(BASE_URL, USERNAME, PASSWORD);
            stmt = conn.createStatement();
            
            // 创建数据库
            stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS ecommerce_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            stmt.executeUpdate("USE ecommerce_db");
            
            // 建表
            createTables(stmt);
            // 插入初始数据
            insertInitialData(stmt);
            // 验证
            verifyData(stmt);
            
        } catch (SQLException e) {
            System.out.println("数据库初始化异常: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void createTables(Statement stmt) throws SQLException {
        // 用户表
        stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users (" +
                "id INT AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID'," +
                "username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名'," +
                "password VARCHAR(100) NOT NULL COMMENT '密码'," +
                "role VARCHAR(20) NOT NULL DEFAULT 'customer' COMMENT '角色: customer或admin'," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'," +
                "INDEX idx_username (username)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表'");
        
        // 商品表
        stmt.executeUpdate("CREATE TABLE IF NOT EXISTS products (" +
                "id VARCHAR(50) PRIMARY KEY COMMENT '商品ID'," +
                "name VARCHAR(100) NOT NULL COMMENT '商品名称'," +
                "category VARCHAR(50) NOT NULL COMMENT '商品分类'," +
                "icon VARCHAR(10) COMMENT '商品图标(Emoji)'," +
                "price DECIMAL(10, 2) NOT NULL COMMENT '商品价格'," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'," +
                "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'," +
                "INDEX idx_category (category)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表'");
        
        // 购物车表
        stmt.executeUpdate("CREATE TABLE IF NOT EXISTS cart (" +
                "id INT AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID'," +
                "username VARCHAR(50) NOT NULL COMMENT '用户名'," +
                "product_id VARCHAR(50) NOT NULL COMMENT '商品ID'," +
                "product_name VARCHAR(100) NOT NULL COMMENT '商品名称'," +
                "icon VARCHAR(10) COMMENT '商品图标'," +
                "price DECIMAL(10, 2) NOT NULL COMMENT '商品单价'," +
                "quantity INT NOT NULL DEFAULT 1 COMMENT '购买数量'," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间'," +
                "UNIQUE KEY uk_user_product (username, product_id) COMMENT '用户+商品唯一'," +
                "INDEX idx_username (username)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表'");
        
        // 订单表
        stmt.executeUpdate("CREATE TABLE IF NOT EXISTS orders (" +
                "id VARCHAR(100) PRIMARY KEY COMMENT '订单ID'," +
                "username VARCHAR(50) NOT NULL COMMENT '用户名'," +
                "total_amount DECIMAL(10, 2) NOT NULL COMMENT '订单总金额'," +
                "status VARCHAR(20) DEFAULT '待发货' COMMENT '订单状态'," +
                "order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间'," +
                "INDEX idx_username (username)," +
                "INDEX idx_order_time (order_time)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表'");
        
        // 订单详情表
        stmt.executeUpdate("CREATE TABLE IF NOT EXISTS order_items (" +
                "id INT AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID'," +
                "order_id VARCHAR(100) NOT NULL COMMENT '订单ID'," +
                "product_id VARCHAR(50) NOT NULL COMMENT '商品ID'," +
                "product_name VARCHAR(100) NOT NULL COMMENT '商品名称'," +
                "icon VARCHAR(10) COMMENT '商品图标'," +
                "price DECIMAL(10, 2) NOT NULL COMMENT '商品单价'," +
                "quantity INT NOT NULL COMMENT '购买数量'," +
                "FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE," +
                "INDEX idx_order_id (order_id)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单详情表'");
        
        // 评价表
        stmt.executeUpdate("CREATE TABLE IF NOT EXISTS product_reviews (" +
                "id INT AUTO_INCREMENT PRIMARY KEY COMMENT '评价ID'," +
                "product_id VARCHAR(50) NOT NULL COMMENT '商品ID'," +
                "username VARCHAR(50) NOT NULL COMMENT '评价用户名'," +
                "rating INT NOT NULL COMMENT '评分(1-5星)'," +
                "content TEXT COMMENT '评价内容'," +
                "review_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间'," +
                "FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE," +
                "INDEX idx_product_id (product_id)," +
                "INDEX idx_username (username)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品评价表'");
    }
    
    private void insertInitialData(Statement stmt) throws SQLException {
        // 判断是否需要插入用户
        java.sql.ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
        rs.next();
        int userCount = rs.getInt(1);
        rs.close();
        
        if (userCount == 0) {
            stmt.executeUpdate("INSERT INTO users (username, password, role) VALUES " +
                    "('admin', '123456', 'customer')," +
                    "('admin2', '123456', 'admin')");
        }
        
        // 判断是否需要插入商品
        rs = stmt.executeQuery("SELECT COUNT(*) FROM products");
        rs.next();
        int productCount = rs.getInt(1);
        rs.close();
        
        if (productCount == 0) {
            stmt.executeUpdate("INSERT INTO products (id, name, category, icon, price) VALUES " +
                    "('P001', '智能手机', 'phone', '📱', 2999.00)," +
                    "('P002', '5G手机', 'phone', '📲', 3599.00)," +
                    "('P003', '充电宝', 'phone', '🔋', 99.00)," +
                    "('C001', '笔记本电脑', 'computer', '💻', 4599.00)," +
                    "('C002', '27寸4K显示器', 'computer', '🖥️', 1899.00)," +
                    "('C003', '机械键盘', 'computer', '⌨️', 399.00)," +
                    "('H001', '沙发', 'home', '🛋️', 2899.00)," +
                    "('H002', '床垫', 'home', '🛏️', 1599.00)," +
                    "('H003', '智能灯', 'home', '💡', 199.00)," +
                    "('CL001', 'T恤', 'clothes', '👕', 99.00)," +
                    "('CL002', '牛仔裤', 'clothes', '👖', 199.00)," +
                    "('CL003', '运动鞋', 'clothes', '👟', 399.00)," +
                    "('F001', '苹果', 'food', '🍎', 29.00)," +
                    "('F002', '面包', 'food', '🍞', 15.00)," +
                    "('F003', '咖啡', 'food', '☕', 68.00)," +
                    "('B001', '编程书籍', 'book', '📚', 79.00)," +
                    "('B002', '小说', 'book', '📖', 45.00)," +
                    "('B003', '文具套装', 'book', '✏️', 39.00)," +
                    "('S001', '足球', 'sport', '⚽', 129.00)," +
                    "('S002', '篮球', 'sport', '🏀', 149.00)," +
                    "('S003', '哑铃', 'sport', '🏋️', 199.00)," +
                    "('BE001', '口红', 'beauty', '💄', 199.00)," +
                    "('BE002', '护肤品', 'beauty', '🧴', 299.00)," +
                    "('BE003', '指甲油', 'beauty', '💅', 59.00)," +
                    "('BA001', '玩具熊', 'baby', '🧸', 89.00)," +
                    "('BA002', '奶瓶', 'baby', '🍼', 69.00)," +
                    "('BA003', '婴儿服装', 'baby', '👶', 99.00)," +
                    "('HW001', '扳手套装', 'hardware', '🔧', 129.00)," +
                    "('HW002', '电钻', 'hardware', '🪚', 399.00)," +
                    "('HW003', '锤子', 'hardware', '🔨', 49.00)");
        }
    }
    
    private void verifyData(Statement stmt) throws SQLException {
        java.sql.ResultSet rs;
        rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
        rs.next();
        System.out.println("用户数: " + rs.getInt(1));
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM products");
        rs.next();
        System.out.println("商品数: " + rs.getInt(1));
        rs.close();
    }
}
