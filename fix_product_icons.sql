-- ====================================
-- 修复商品图标缺失问题
-- 更新缺少emoji图标的商品记录
-- ====================================

USE ecommerce_db;

-- 查看当前缺少图标的商品
SELECT id, name, category, icon, price 
FROM products 
WHERE icon IS NULL OR icon = '' OR icon = ' ';

-- 更新缺少图标的商品
UPDATE products SET icon = '📱' WHERE id = 'P001' AND (icon IS NULL OR icon = '' OR icon = ' ');
UPDATE products SET icon = '🏀' WHERE id = 'S002' AND (icon IS NULL OR icon = '' OR icon = ' ');
UPDATE products SET icon = '🔧' WHERE id = 'HW001' AND (icon IS NULL OR icon = '' OR icon = ' ');

-- 验证修复结果
SELECT id, name, category, icon, price 
FROM products 
ORDER BY category, id;

SELECT '商品图标修复完成!' AS message;
