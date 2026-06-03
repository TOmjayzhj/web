package common.example.model;

public class CartItem {
    private String productId;
    private String productName;
    private String icon;
    private double price;
    private int quantity;
    
    public CartItem() {
    }
    
    public CartItem(String productId, String productName, String icon, double price, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.icon = icon;
        this.price = price;
        this.quantity = quantity;
    }
    
    public double getSubtotal() {
        return price * quantity;
    }
    
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
        return "CartItem{" +
                "productId='" + productId + '\'' +
                ", productName='" + productName + '\'' +
                ", icon='" + icon + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                '}';
    }
}
