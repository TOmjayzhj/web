package common.example.model;

import java.util.Date;

public class ProductReview {
    private int id;
    private String productId;
    private String username;
    private int rating;
    private String content;
    private Date reviewTime;
    
    public ProductReview() {
    }
    
    public ProductReview(int id, String productId, String username, int rating, String content, Date reviewTime) {
        this.id = id;
        this.productId = productId;
        this.username = username;
        this.rating = rating;
        this.content = content;
        this.reviewTime = reviewTime;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getProductId() {
        return productId;
    }
    
    public void setProductId(String productId) {
        this.productId = productId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Date getReviewTime() {
        return reviewTime;
    }
    
    public void setReviewTime(Date reviewTime) {
        this.reviewTime = reviewTime;
    }
    
    @Override
    public String toString() {
        return "ProductReview{" +
                "id=" + id +
                ", productId='" + productId + '\'' +
                ", username='" + username + '\'' +
                ", rating=" + rating +
                ", content='" + content + '\'' +
                ", reviewTime=" + reviewTime +
                '}';
    }
}
