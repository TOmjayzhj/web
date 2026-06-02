package common.example.model;

/**
 * 商品实体类
 */
public class Product {
    private String id;          // 商品ID
    private String name;        // 商品名称
    private String category;    // 商品分类
    private String icon;        // 商品图标
    private double price;       // 商品价格
    
    // 无参构造函数
    public Product() {
    }
    
    // 全参构造函数
    public Product(String id, String name, String category, String icon, double price) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.icon = icon;
        this.price = price;
    }
    
    // Getter 和 Setter 方法
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
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
    
    @Override
    public String toString() {
        return "Product{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", category='" + category + '\'' +
                ", icon='" + icon + '\'' +
                ", price=" + price +
                '}';
    }
}
