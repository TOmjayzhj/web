package common.example.model;

/**
 * 用户模型类 - 支持普通用户和管理员两种角色
 */
public class User {
    
    // 用户角色常量
    public static final String ROLE_CUSTOMER = "customer";
    public static final String ROLE_ADMIN = "admin";
    
    private String username;
    private String password;
    private String role; // customer 或 admin
    
    // 构造函数
    public User() {
    }
    
    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }
    
    // Getter 和 Setter
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    /**
     * 判断是否为管理员
     */
    public boolean isAdmin() {
        return ROLE_ADMIN.equals(this.role);
    }
    
    /**
     * 判断是否为普通用户
     */
    public boolean isCustomer() {
        return ROLE_CUSTOMER.equals(this.role);
    }
    
    @Override
    public String toString() {
        return "User{" +
                "username='" + username + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}
