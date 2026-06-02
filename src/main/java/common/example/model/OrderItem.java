package common.example.model;

/**
 * 订单项实体类
 */
public class OrderItem {
    private String productId;    // 商品ID
    private String productName;  // 商品名称
    private String icon;         // 商品图标
    private double price;        // 商品单价
    private int quantity;        // 购买数量
    
    // 无参构造函数
    public OrderItem() {
    }
    
    // 全参构造函数
    public OrderItem(String productId, String productName, String icon, double price, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.icon = icon;
        this.price = price;
        this.quantity = quantity;
    }
    
    // 计算小计
    public double getSubtotal() {
        return price * quantity;
    }
    
    // Getter 和 Setter 方法
    public String getProductId() {
        return productId;
    }
    
    public void setProductId(String productId) {
        this.productId = productId;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public String getIcon() {
        return icon;
    }
    
    public void setIcon(String icon) {
        this.icon = icon;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    @Override
    public String toString() {
        return "OrderItem{" +
                "productId='" + productId + '\'' +
                ", productName='" + productName + '\'' +
                ", icon='" + icon + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                '}';
    }
}
