package common.example.model;

import java.util.Date;
import java.util.List;

/**
 * 订单实体类
 */
public class Order {
    private String orderId;           // 订单ID
    private String username;          // 用户名
    private List<OrderItem> items;    // 订单商品列表
    private double totalAmount;       // 订单总金额
    private Date orderTime;           // 下单时间
    private String status;            // 订单状态：待发货、已发货、已完成
    
    // 无参构造函数
    public Order() {
    }
    
    // 全参构造函数
    public Order(String orderId, String username, List<OrderItem> items, double totalAmount, Date orderTime, String status) {
        this.orderId = orderId;
        this.username = username;
        this.items = items;
        this.totalAmount = totalAmount;
        this.orderTime = orderTime;
        this.status = status;
    }
    
    // Getter 和 Setter 方法
    public String getOrderId() {
        return orderId;
    }
    
    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public List<OrderItem> getItems() {
        return items;
    }
    
    public void setItems(List<OrderItem> items) {
        this.items = items;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public Date getOrderTime() {
        return orderTime;
    }
    
    public void setOrderTime(Date orderTime) {
        this.orderTime = orderTime;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    @Override
    public String toString() {
        return "Order{" +
                "orderId='" + orderId + '\'' +
                ", username='" + username + '\'' +
                ", totalAmount=" + totalAmount +
                ", orderTime=" + orderTime +
                ", status='" + status + '\'' +
                '}';
    }
}
