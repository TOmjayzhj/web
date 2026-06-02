-- ====================================
-- 电商系统数据库初始化脚本
-- 数据库: ecommerce_db
-- 密码: 123456
-- ====================================

-- 1. 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS ecommerce_db 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 2. 使用数据库
USE ecommerce_db;

-- 3. 创建用户表
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    role VARCHAR(20) NOT NULL DEFAULT 'customer' COMMENT '角色: customer或admin',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 4. 创建商品表
CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(50) PRIMARY KEY COMMENT '商品ID',
    name VARCHAR(100) NOT NULL COMMENT '商品名称',
    category VARCHAR(50) NOT NULL COMMENT '商品分类',
    icon VARCHAR(10) COMMENT '商品图标(Emoji)',
    price DECIMAL(10, 2) NOT NULL COMMENT '商品价格',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 5. 创建购物车表
CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
    product_name VARCHAR(100) NOT NULL COMMENT '商品名称',
    icon VARCHAR(10) COMMENT '商品图标',
    price DECIMAL(10, 2) NOT NULL COMMENT '商品单价',
    quantity INT NOT NULL DEFAULT 1 COMMENT '购买数量',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
    UNIQUE KEY uk_user_product (username, product_id) COMMENT '用户+商品唯一',
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- 6. 创建订单表
CREATE TABLE IF NOT EXISTS orders (
    id VARCHAR(100) PRIMARY KEY COMMENT '订单ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    total_amount DECIMAL(10, 2) NOT NULL COMMENT '订单总金额',
    status VARCHAR(20) DEFAULT '待发货' COMMENT '订单状态',
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
    INDEX idx_username (username),
    INDEX idx_order_time (order_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 7. 创建订单详情表
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '自增ID',
    order_id VARCHAR(100) NOT NULL COMMENT '订单ID',
    product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
    product_name VARCHAR(100) NOT NULL COMMENT '商品名称',
    icon VARCHAR(10) COMMENT '商品图标',
    price DECIMAL(10, 2) NOT NULL COMMENT '商品单价',
    quantity INT NOT NULL COMMENT '购买数量',
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单详情表';

-- 8. 创建商品评价表
CREATE TABLE IF NOT EXISTS product_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '评价ID',
    product_id VARCHAR(50) NOT NULL COMMENT '商品ID',
    username VARCHAR(50) NOT NULL COMMENT '评价用户名',
    rating INT NOT NULL COMMENT '评分(1-5星)',
    content TEXT COMMENT '评价内容',
    review_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品评价表';

-- 9. 插入示例用户数据
INSERT INTO users (username, password, role) VALUES
('admin', '123456', 'customer'),
('admin2', '123456', 'admin');

-- 10. 插入示例商品数据
INSERT INTO products (id, name, category, icon, price) VALUES
-- 手机数码
('P001', '智能手机', 'phone', '', 2999.00),
('P002', '5G手机', 'phone', '📲', 3599.00),
('P003', '充电宝', 'phone', '🔋', 99.00),
-- 电脑办公
('C001', '笔记本电脑', 'computer', '💻', 4599.00),
('C002', '27寸4K显示器', 'computer', '🖥️', 1899.00),
('C003', '机械键盘', 'computer', '⌨️', 399.00),
-- 家居家装
('H001', '沙发', 'home', '🛋️', 2899.00),
('H002', '床垫', 'home', '🛏️', 1599.00),
('H003', '智能灯', 'home', '💡', 199.00),
-- 服饰鞋包
('CL001', 'T恤', 'clothes', '👕', 99.00),
('CL002', '牛仔裤', 'clothes', '👖', 199.00),
('CL003', '运动鞋', 'clothes', '👟', 399.00),
-- 食品饮料
('F001', '苹果', 'food', '🍎', 29.00),
('F002', '面包', 'food', '🍞', 15.00),
('F003', '咖啡', 'food', '☕', 68.00),
-- 图书文具
('B001', '编程书籍', 'book', '📚', 79.00),
('B002', '小说', 'book', '📖', 45.00),
('B003', '文具套装', 'book', '✏️', 39.00),
-- 运动户外
('S001', '足球', 'sport', '⚽', 129.00),
('S002', '篮球', 'sport', '', 149.00),
('S003', '哑铃', 'sport', '🏋️', 199.00),
-- 美妆个护
('BE001', '口红', 'beauty', '💄', 199.00),
('BE002', '护肤品', 'beauty', '🧴', 299.00),
('BE003', '指甲油', 'beauty', '💅', 59.00),
-- 母婴玩具
('BA001', '玩具熊', 'baby', '🧸', 89.00),
('BA002', '奶瓶', 'baby', '🍼', 69.00),
('BA003', '婴儿服装', 'baby', '👶', 99.00),
-- 五金工具
('HW001', '扳手套装', 'hardware', '', 129.00),
('HW002', '电钻', 'hardware', '🪚', 399.00),
('HW003', '锤子', 'hardware', '🔨', 49.00);

-- 11. 验证数据
SELECT '数据库初始化完成！' AS message;
SELECT COUNT(*) AS total_users FROM users;
SELECT COUNT(*) AS total_products FROM products;
SELECT * FROM users;
SELECT * FROM products LIMIT 5;
