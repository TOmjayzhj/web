package common.example.util;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;

public class InsertReviews {
    public static void main(String[] args) {
        Connection conn = null;
        Statement stmt = null;
        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            
            // 先插入商品数据（如果不存在）
            String[] products = {
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('P001', '智能手机', 'phone', '', 2999.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('P002', '5G手机', 'phone', '📲', 3599.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('P003', '充电宝', 'phone', '🔋', 99.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('C001', '笔记本电脑', 'computer', '💻', 4599.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('C002', '27寸4K显示器', 'computer', '🖥️', 1899.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('C003', '机械键盘', 'computer', '⌨️', 399.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('H001', '沙发', 'home', '🛋️', 2899.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('H002', '床垫', 'home', '🛏️', 1599.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('H003', '智能灯', 'home', '💡', 199.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('CL001', 'T恤', 'clothes', '👕', 99.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('CL002', '牛仔裤', 'clothes', '👖', 199.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('CL003', '运动鞋', 'clothes', '👟', 399.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('F001', '苹果', 'food', '🍎', 29.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('F002', '面包', 'food', '🍞', 15.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('F003', '咖啡', 'food', '☕', 68.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('B001', '编程书籍', 'book', '📚', 79.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('B002', '小说', 'book', '📖', 45.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('B003', '文具套装', 'book', '✏️', 39.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('S001', '足球', 'sport', '⚽', 129.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('S002', '篮球', 'sport', '', 149.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('S003', '哑铃', 'sport', '🏋️', 199.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('BE001', '口红', 'beauty', '💄', 199.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('BE002', '护肤品', 'beauty', '🧴', 299.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('BE003', '指甲油', 'beauty', '💅', 59.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('BA001', '玩具熊', 'baby', '🧸', 89.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('BA002', '奶瓶', 'baby', '🍼', 69.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('BA003', '婴儿服装', 'baby', '👶', 99.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('HW001', '扳手套装', 'hardware', '', 129.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('HW002', '电钻', 'hardware', '🪚', 399.00)",
                "INSERT IGNORE INTO products (id, name, category, icon, price) VALUES ('HW003', '锤子', 'hardware', '🔨', 49.00)"
            };
            
            for (String sql : products) {
                stmt.executeUpdate(sql);
            }
            System.out.println("✅ 商品数据插入完成");
            
            // 插入评价数据
            String[] reviews = {
                // P001-P003, C001已插入，跳过
                // C002-C003
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('C002', 'user1', 5, '画质清晰，色彩还原度高，设计办公都很棒！', DATE_SUB(NOW(), INTERVAL 5 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('C002', 'user3', 4, '尺寸合适，显示效果好，就是支架有点简陋', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('C003', 'admin', 5, '手感极佳，打字舒服，RGB灯效很漂亮！', DATE_SUB(NOW(), INTERVAL 7 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('C003', 'user2', 5, '轴体手感好，做工精细，值得拥有！', DATE_SUB(NOW(), INTERVAL 4 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('C003', 'user1', 4, '敲击声音适中，适合办公使用', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                // H001-H003
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('H001', 'admin', 5, '很舒服的沙发，质量很好，物流也快！', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('H001', 'user3', 4, '款式好看，坐着舒适，就是味道有点大', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('H002', 'user1', 5, '软硬适中，睡眠质量提高了很多！', DATE_SUB(NOW(), INTERVAL 6 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('H002', 'admin2', 5, '质量很好，没有异味，睡得很舒服', DATE_SUB(NOW(), INTERVAL 3 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('H002', 'user2', 4, '支撑性好，就是价格稍贵', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('H003', 'user3', 5, '智能控制很方便，可以调节亮度和色温！', DATE_SUB(NOW(), INTERVAL 4 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('H003', 'user1', 4, '连接稳定，APP操作简单，性价比高', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                // CL001-CL003
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('CL001', 'admin', 5, '面料舒适，版型好看，洗了不变形！', DATE_SUB(NOW(), INTERVAL 5 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('CL001', 'user2', 4, '颜色正，穿着舒服，就是尺码偏大', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('CL001', 'user3', 5, '物美价廉，已经回购了！', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('CL002', 'user1', 4, '版型好，面料有弹性，穿着舒适', DATE_SUB(NOW(), INTERVAL 6 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('CL002', 'admin2', 5, '质量很好，做工精细，值得购买！', DATE_SUB(NOW(), INTERVAL 3 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('CL003', 'user3', 5, '轻便舒适，跑步很合适，防滑效果好！', DATE_SUB(NOW(), INTERVAL 4 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('CL003', 'user2', 4, '外观时尚，穿着舒服，就是码数偏小', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('CL003', 'admin', 5, '减震效果好，运动必备！', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                // F001-F003
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('F001', 'admin', 4, '苹果很新鲜，甜度适中，就是数量有点少', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('F001', 'admin2', 5, '非常好吃，物美价廉！', DATE_SUB(NOW(), INTERVAL 4 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('F001', 'user1', 5, '口感脆甜，物流快，包装好！', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('F002', 'user3', 5, '新鲜好吃，早餐必备，口感松软！', DATE_SUB(NOW(), INTERVAL 3 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('F002', 'user2', 4, '味道不错，就是保质期有点短', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('F003', 'admin', 5, '香浓可口，提神醒脑，品质很好！', DATE_SUB(NOW(), INTERVAL 5 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('F003', 'user1', 4, '味道纯正，性价比不错', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('F003', 'admin2', 5, '每天早上必喝，非常满意！', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                // B001-B003
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('B001', 'admin', 5, '内容很实用，讲解详细，适合初学者', DATE_SUB(NOW(), INTERVAL 6 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('B001', 'user3', 4, '知识点全面，案例丰富，值得学习', DATE_SUB(NOW(), INTERVAL 3 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('B002', 'user2', 5, '情节精彩，文笔优美，一看就停不下来！', DATE_SUB(NOW(), INTERVAL 4 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('B002', 'user1', 4, '故事吸引人，就是结局有点仓促', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('B002', 'admin2', 5, '非常好看，已经推荐给朋友了！', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('B003', 'user3', 5, '种类齐全，质量不错，学生必备！', DATE_SUB(NOW(), INTERVAL 5 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('B003', 'user2', 4, '包装精美，实用性强', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                // S001-S003
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('S001', 'admin2', 4, '质量不错，踢起来手感好', DATE_SUB(NOW(), INTERVAL 9 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('S001', 'user1', 5, '弹性好，耐用，适合训练和比赛！', DATE_SUB(NOW(), INTERVAL 4 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('S001', 'user3', 4, '做工精细，就是价格稍贵', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('S002', 'user2', 5, '手感极佳，运球稳定，投篮准确！', DATE_SUB(NOW(), INTERVAL 6 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('S002', 'admin', 4, '质量很好，耐磨性强', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('S003', 'user1', 5, '重量准确，握感舒适，健身必备！', DATE_SUB(NOW(), INTERVAL 5 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('S003', 'user3', 4, '做工精细，就是有点占地方', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('S003', 'admin2', 5, '质量很好，在家锻炼很方便！', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                // BE001-BE003
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BE001', 'user2', 5, '颜色好看，持久不脱色，质地滋润！', DATE_SUB(NOW(), INTERVAL 4 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BE001', 'admin', 4, '包装精美，上色均匀', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BE001', 'user1', 5, '非常满意，已经回购了！', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BE002', 'user3', 5, '补水效果好，皮肤变得水润有光泽！', DATE_SUB(NOW(), INTERVAL 6 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BE002', 'admin2', 4, '温和不刺激，适合敏感肌', DATE_SUB(NOW(), INTERVAL 3 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BE003', 'user1', 4, '颜色漂亮，易涂抹，就是干得有点慢', DATE_SUB(NOW(), INTERVAL 5 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BE003', 'user2', 5, '持久度好，不掉色，很满意！', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BE003', 'user3', 4, '性价比高，颜色选择多', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                // BA001-BA003
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BA001', 'admin', 5, '毛绒柔软，孩子很喜欢，质量不错！', DATE_SUB(NOW(), INTERVAL 7 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BA001', 'user1', 4, '造型可爱，做工精细', DATE_SUB(NOW(), INTERVAL 3 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BA002', 'admin2', 5, '材质安全，防胀气效果好，宝宝喜欢！', DATE_SUB(NOW(), INTERVAL 5 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BA002', 'user3', 4, '清洗方便，刻度清晰', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BA002', 'user2', 5, '质量很好，性价比高！', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BA003', 'user1', 5, '面料柔软舒适，宝宝穿着很合适！', DATE_SUB(NOW(), INTERVAL 6 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('BA003', 'admin', 4, '款式可爱，做工精细，就是尺码偏小', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                // HW001-HW003
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('HW001', 'user3', 5, '种类齐全，质量好，家用必备！', DATE_SUB(NOW(), INTERVAL 4 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('HW001', 'user2', 4, '做工精细，耐用性强', DATE_SUB(NOW(), INTERVAL 1 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('HW001', 'admin2', 5, '性价比很高，非常满意！', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('HW002', 'user1', 5, '动力强劲，操作简单，很实用！', DATE_SUB(NOW(), INTERVAL 5 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('HW002', 'admin', 4, '噪音小，续航时间长', DATE_SUB(NOW(), INTERVAL 2 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('HW003', 'user3', 4, '重量适中，握感舒适，质量好', DATE_SUB(NOW(), INTERVAL 6 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('HW003', 'user2', 5, '结实耐用，性价比不错！', DATE_SUB(NOW(), INTERVAL 3 DAY))",
                "INSERT INTO product_reviews (product_id, username, rating, content, review_time) VALUES ('HW003', 'admin2', 4, '做工精细，家用很合适', DATE_SUB(NOW(), INTERVAL 1 DAY))"
            };
            
            int count = 0;
            for (String sql : reviews) {
                stmt.executeUpdate(sql);
                count++;
            }
            System.out.println("✅ 评价数据插入完成，共插入 " + count + " 条评价");
            
            // 查询统计
            ResultSet rs = stmt.executeQuery("SELECT product_id, COUNT(*) as review_count FROM product_reviews GROUP BY product_id ORDER BY product_id");
            System.out.println("\n📊 各商品评价数量统计：");
            while (rs.next()) {
                System.out.println("  " + rs.getString("product_id") + ": " + rs.getInt("review_count") + " 条评价");
            }
            
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM product_reviews");
            if (rs.next()) {
                System.out.println("\n✨ 总评价数: " + rs.getInt("total"));
            }
            
        } catch (Exception e) {
            System.err.println("❌ 错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                DBUtil.close(conn);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
