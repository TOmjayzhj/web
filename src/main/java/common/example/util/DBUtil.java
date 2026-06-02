package common.example.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 数据库连接工具类
 */
public class DBUtil {
    
    // 数据库连接配置
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/ecommerce_db?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "123456"; // MySQL密码
    
    // 静态加载驱动
    static {
        try {
            Class.forName(DRIVER);
            System.out.println("[DBUtil] MySQL驱动加载成功");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBUtil] MySQL驱动加载失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 获取数据库连接
     * @return Connection对象
     * @throws SQLException
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            // 只在第一次连接时输出日志，避免日志过多
            // System.out.println("[DBUtil] 数据库连接成功: " + URL);
            return conn;
        } catch (SQLException e) {
            System.err.println("[DBUtil] 数据库连接失败！");
            System.err.println("[DBUtil] URL: " + URL);
            System.err.println("[DBUtil] 用户名: " + USERNAME);
            System.err.println("[DBUtil] 错误信息: " + e.getMessage());
            System.err.println("[DBUtil] 请检查:");
            System.err.println("[DBUtil]   1. MySQL服务是否已启动？");
            System.err.println("[DBUtil]   2. 数据库密码是否正确？（当前密码: " + PASSWORD + "）");
            System.err.println("[DBUtil]   3. 数据库 ecommerce_db 是否存在？");
            throw e;
        }
    }
    
    /**
     * 关闭数据库连接
     * @param conn Connection对象
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * 测试数据库连接
     */
    public static void main(String[] args) {
        Connection conn = null;
        try {
            conn = getConnection();
            System.out.println("✅ 数据库连接测试成功！");
        } catch (SQLException e) {
            System.err.println("❌ 数据库连接测试失败: " + e.getMessage());
            e.printStackTrace();
        } finally {
            close(conn);
        }
    }
    
}
