package common.example.model;

import java.util.Date;
import java.util.List;

public class Order {
    private String orderId;
    private String username;
    private List<OrderItem> items;
    private double totalAmount;
    private Date orderTime;
    private String status;
    
    public Order() {
    }
    
    public Order(String orderId, String username, List<OrderItem> items, double totalAmount, Date orderTime, String status) {
        this.orderId = orderId;
        this.username = username;
        this.items = items;
        this.totalAmount = totalAmount;
        this.orderTime = orderTime;
        this.status = status;
    }
    
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
