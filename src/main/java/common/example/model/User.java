package common.example.model;

public class User {
    public static final String ROLE_CUSTOMER = "customer";
    public static final String ROLE_ADMIN = "admin";
    
    private String username;
    private String password;
    private String role;
    
    public User() {
    }
    
    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }
    
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
    
    public boolean isAdmin() {
        return ROLE_ADMIN.equals(this.role);
    }
    
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
