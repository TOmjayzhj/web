package common.example.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * 修复商品图标工具类
 */
public class FixProductIcons {
    
    public static void main(String[] args) {
        System.out.println("开始修复商品图标...");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            // 查询所有缺少icon或icon为问号的商品
            String selectSql = "SELECT id, name, icon FROM products WHERE icon IS NULL OR icon = '' OR icon = '?' OR icon = '??'";
            pstmt = conn.prepareStatement(selectSql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String id = rs.getString("id");
                String name = rs.getString("name");
                String currentIcon = rs.getString("icon");
                
                System.out.println("发现需要修复的商品: " + id + " - " + name + " (当前icon: " + currentIcon + ")");
            }
            
            // 根据商品分类和ID设置默认图标
            String[][] iconMappings = {
                // 手机数码
                {"P001", "📱"}, // 智能手机
                {"P002", "📲"}, // 5G手机
                {"P003", "🔋"}, // 充电宝
                
                // 电脑办公
                {"C001", "💻"}, // 笔记本电脑
                {"C002", "🖥️"}, // 27寸4K显示器
                {"C003", "⌨️"}, // 机械键盘
                
                // 家居家装
                {"H001", "🛋️"}, // 沙发
                {"H002", "🛏️"}, // 床垫
                {"H003", "💡"}, // 智能灯
                
                // 服饰鞋包
                {"CL001", "👕"}, // T恤
                {"CL002", "👖"}, // 牛仔裤
                {"CL003", "👟"}, // 运动鞋
                
                // 食品饮料
                {"F001", "🍎"}, // 苹果
                {"F002", "🍞"}, // 面包
                {"F003", "☕"}, // 咖啡
                
                // 图书文具
                {"B001", "📚"}, // 编程书籍
                {"B002", "📖"}, // 小说
                {"B003", "✏️"}, // 文具套装
                
                // 运动户外
                {"S001", "⚽"}, // 足球
                {"S002", "🏀"}, // 篮球
                {"S003", "🏋️"}, // 哑铃
                
                // 美妆个护
                {"BE001", "💄"}, // 口红
                {"BE002", "🧴"}, // 护肤品
                {"BE003", "💅"}, // 指甲油
                
                // 母婴玩具
                {"BA001", "🧸"}, // 玩具熊
                {"BA002", "🍼"}, // 奶瓶
                {"BA003", "👶"}, // 婴儿服装
                
                // 五金工具
                {"HW001", "🔧"}, // 扳手套装
                {"HW002", "🪚"}, // 电钻
                {"HW003", "🔨"}  // 锤子
            };
            
            // 更新所有商品的icon
            String updateSql = "UPDATE products SET icon = ? WHERE id = ?";
            pstmt = conn.prepareStatement(updateSql);
            
            int updatedCount = 0;
            for (String[] mapping : iconMappings) {
                String productId = mapping[0];
                String icon = mapping[1];
                
                pstmt.setString(1, icon);
                pstmt.setString(2, productId);
                int rows = pstmt.executeUpdate();
                
                if (rows > 0) {
                    updatedCount++;
                    System.out.println("✓ 已更新: " + productId + " -> " + icon);
                }
            }
            
            System.out.println("\n修复完成！共更新 " + updatedCount + " 个商品图标。");
            
        } catch (Exception e) {
            System.err.println("修复失败: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
