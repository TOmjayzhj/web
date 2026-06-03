package common.example.model;

public class Product {
    private String id;
    private String name;
    private String category;
    private String icon;
    private double price;
    
    public Product() {
    }
    
    public Product(String id, String name, String category, String icon, double price) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.icon = icon;
        this.price = price;
    }
    
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
