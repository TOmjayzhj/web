<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    // 检查用户是否已登录且是管理员
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="data:,">
    <title>商品管理后台</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
        }
        
        .container {
            display: grid;
            grid-template-columns: 250px 1fr;
            grid-template-rows: 80px 1fr;
            min-height: 100vh;
            gap: 0;
        }
        
        /* 顶部栏 */
        .header {
            grid-column: 1 / 3;
            background-color: #ffffff;
            padding: 20px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            z-index: 100;
        }
        
        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .search-container {
            flex: 1;
            max-width: 500px;
            margin: 0 30px;
            position: relative;
        }
        
        .search-box {
            width: 100%;
            padding: 12px 50px 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.3s;
        }
        
        .search-box:focus {
            border-color: #3498db;
        }
        
        .search-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.2s;
        }
        
        .search-btn:hover {
            background-color: #2980b9;
        }
        
        .header-icons {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .icon-btn {
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none;
            color: #333;
            font-size: 14px;
            cursor: pointer;
        }
        
        .icon-btn i {
            font-size: 20px;
            margin-bottom: 5px;
        }
        
        .badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: #e74c3c;
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 10px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        /* 用户下拉菜单样式 */
        .user-dropdown {
            position: relative;
            cursor: pointer;
        }
        
        .user-menu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 10px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            min-width: 220px;
            z-index: 10000;
            overflow: hidden;
        }
        
        .user-menu.show {
            display: block;
        }
        
        .user-menu-header {
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .user-avatar {
            font-size: 32px;
            width: 50px;
            height: 50px;
            background-color: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .user-menu-info {
            flex: 1;
        }
        
        .user-menu-name {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 4px;
        }
        
        .user-menu-role {
            font-size: 12px;
            opacity: 0.9;
        }
        
        .user-menu-divider {
            height: 1px;
            background-color: #e0e0e0;
            margin: 8px 0;
        }
        
        .user-menu-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 15px;
            color: #333;
            text-decoration: none;
            transition: background-color 0.2s;
            font-size: 14px;
        }
        
        .user-menu-item:hover {
            background-color: #e8e8e8;
        }
        
        .user-menu-item span {
            font-size: 18px;
        }
        
        .logout-item {
            color: #e74c3c;
        }
        
        .logout-item:hover {
            background-color: #ffeaea;
        }
        
        .admin-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            margin-left: 15px;
        }
        
        /* 左侧导航栏 */
        .sidebar {
            background-color: #2c3e50;
            color: white;
            padding: 20px 0;
            overflow-y: auto;
        }
        
        .nav-title {
            padding: 0 20px 15px;
            font-size: 18px;
            font-weight: bold;
            border-bottom: 1px solid #34495e;
            margin-bottom: 15px;
        }
        
        .nav-item {
            padding: 12px 20px;
            cursor: pointer;
            transition: background-color 0.2s;
            border-left: 3px solid transparent;
            text-decoration: none;
            color: white;
            display: block;
        }
        
        .nav-item:hover {
            background-color: #34495e;
        }
        
        .nav-item.active {
            background-color: #34495e;
            border-left: 3px solid #3498db;
        }
        
        .nav-item i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        /* 主内容区域 */
        .main-content {
            padding: 30px;
            background-color: #f5f5f5;
        }
        
        .content-header {
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .content-header h2 {
            color: #2c3e50;
            font-size: 24px;
        }
        
        .add-product-btn {
            padding: 10px 20px;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
        }
        
        .add-product-btn:hover {
            background-color: #229954;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }
        
        .product-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.15);
        }
        
        .product-image {
            height: 150px;
            background-color: #ecf0f1;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #7f8c8d;
            font-size: 64px;
        }
        
        .product-info {
            padding: 15px;
        }
        
        .product-name {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 8px;
            color: #2c3e50;
        }
        
        .product-id {
            font-size: 12px;
            color: #95a5a6;
            margin-bottom: 8px;
        }
        
        .product-price {
            color: #e74c3c;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        
        .product-orders {
            font-size: 13px;
            color: #3498db;
            margin-bottom: 10px;
        }
        
        .product-actions {
            display: flex;
            gap: 8px;
        }
        
        .btn-edit, .btn-delete, .btn-reviews {
            flex: 1;
            padding: 8px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            transition: background-color 0.2s;
        }
        
        .btn-edit {
            background-color: #3498db;
            color: white;
        }
        
        .btn-edit:hover {
            background-color: #2980b9;
        }
        
        .btn-delete {
            background-color: #e74c3c;
            color: white;
        }
        
        .btn-delete:hover {
            background-color: #c0392b;
        }
        
        .btn-reviews {
            background-color: #f39c12;
            color: white;
        }
        
        .btn-reviews:hover {
            background-color: #e67e22;
        }
        
        /* 模态框样式 */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 10000;
            justify-content: center;
            align-items: center;
        }
        
        .modal.show {
            display: flex;
        }
        
        .modal-content {
            background-color: white;
            border-radius: 8px;
            padding: 30px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
        }
        
        .modal-header {
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h3 {
            color: #2c3e50;
            font-size: 20px;
            margin: 0;
        }
        
        .modal-close {
            font-size: 28px;
            font-weight: bold;
            color: #95a5a6;
            cursor: pointer;
            line-height: 1;
            padding: 0 5px;
            transition: color 0.2s;
        }
        
        .modal-close:hover {
            color: #e74c3c;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-size: 14px;
        }
        
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .modal-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        
        .btn-save, .btn-cancel {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
        }
        
        .btn-save {
            background-color: #27ae60;
            color: white;
        }
        
        .btn-save:hover {
            background-color: #229954;
        }
        
        .btn-cancel {
            background-color: #95a5a6;
            color: white;
        }
        
        .btn-cancel:hover {
            background-color: #7f8c8d;
        }
        
        /* 提示消息样式 */
        .toast {
            position: fixed;
            top: 100px;
            right: 30px;
            background-color: #27ae60;
            color: white;
            padding: 15px 25px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            z-index: 10000;
            font-size: 14px;
            opacity: 0;
            transform: translateX(400px);
            transition: all 0.3s ease;
        }
        
        .toast.show {
            opacity: 1;
            transform: translateX(0);
        }
        
        .toast.error {
            background-color: #e74c3c;
        }
        
        /* 评价模态框样式 */
        .review-item {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            border-left: 4px solid #3498db;
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .review-user {
            font-weight: bold;
            color: #2c3e50;
            font-size: 14px;
        }
        
        .review-time {
            font-size: 12px;
            color: #95a5a6;
        }
        
        .review-rating {
            color: #f39c12;
            font-size: 16px;
            margin-bottom: 8px;
        }
        
        .review-content {
            color: #555;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 10px;
        }
        
        .review-delete-btn {
            padding: 6px 12px;
            background-color: #e74c3c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: background-color 0.2s;
        }
        
        .review-delete-btn:hover {
            background-color: #c0392b;
        }
        
        .no-reviews {
            text-align: center;
            color: #999;
            padding: 40px;
            font-size: 16px;
        }
        
        .review-summary {
            background-color: #fff3cd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-around;
            align-items: center;
        }
        
        .summary-item {
            text-align: center;
        }
        
        .summary-label {
            font-size: 12px;
            color: #856404;
            margin-bottom: 5px;
        }
        
        .summary-value {
            font-size: 24px;
            font-weight: bold;
            color: #856404;
        }
        
        /* 订单管理样式 */
        .order-management {
            display: none;
        }
        
        .order-management.active {
            display: block;
        }
        
        .product-management {
            display: block;
        }
        
        .product-management.hidden {
            display: none;
        }
        
        .order-summary {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .order-summary h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 18px;
        }
        
        .order-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }
        
        .stat-card {
            background-color: #f8f9fa;
            border-radius: 6px;
            padding: 15px;
            text-align: center;
            border-left: 4px solid #3498db;
        }
        
        .stat-card.pending {
            border-left-color: #f39c12;
        }
        
        .stat-card.shipped {
            border-left-color: #3498db;
        }
        
        .stat-card.completed {
            border-left-color: #27ae60;
        }
        
        .stat-card.revenue {
            border-left-color: #e74c3c;
        }
        
        .stat-number {
            font-size: 28px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 13px;
            color: #7f8c8d;
        }
        
        .order-table {
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .order-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .order-table th {
            background-color: #34495e;
            color: white;
            padding: 12px 15px;
            text-align: left;
            font-size: 14px;
            font-weight: 600;
        }
        
        .order-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ecf0f1;
            font-size: 13px;
            color: #2c3e50;
        }
        
        .order-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .order-table tr:last-child td {
            border-bottom: none;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-shipped {
            background-color: #cce5ff;
            color: #004085;
        }
        
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        
        .ship-btn {
            padding: 6px 14px;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: background-color 0.2s;
        }
        
        .ship-btn:hover {
            background-color: #229954;
        }
        
        .ship-btn:disabled {
            background-color: #95a5a6;
            cursor: not-allowed;
        }
        
        .order-items-detail {
            font-size: 12px;
            color: #7f8c8d;
            max-width: 250px;
        }
        
        .no-orders {
            text-align: center;
            color: #999;
            padding: 50px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <!-- 提示消息容器 -->
    <div id="toast" class="toast"></div>
    
    <div class="container">
        <!-- 顶部搜索栏 -->
        <header class="header">
            <div class="logo">商品管理后台</div>
            <div class="search-container">
                <input type="text" id="searchBox" class="search-box" placeholder="搜索商品..." onkeypress="if(event.keyCode==13) searchProducts()">
                <button class="search-btn" onclick="searchProducts()">🔍</button>
            </div>
            <div class="header-icons">
                <span class="admin-badge">管理员模式</span>
                <div class="icon-btn user-dropdown" onclick="toggleUserMenu()">
                    <span>👤</span>
                    <span>${sessionScope.username}</span>
                    <!-- 用户下拉菜单 -->
                    <div id="userMenu" class="user-menu">
                        <div class="user-menu-header">
                            <div class="user-avatar">👤</div>
                            <div class="user-menu-info">
                                <div class="user-menu-name">${sessionScope.username}</div>
                                <div class="user-menu-role">管理员</div>
                            </div>
                        </div>
                        <div class="user-menu-divider"></div>
                        <a href="${pageContext.request.contextPath}/logout" class="user-menu-item logout-item">
                            <span></span> 退出登录
                        </a>
                    </div>
                </div>
            </div>
        </header>
        
        <!-- 左侧分类导航 -->
        <nav class="sidebar">
            <div class="nav-title">管理菜单</div>
            <a href="#" class="nav-item active" data-section="product"><span>📦</span> 商品管理</a>
            <a href="#" class="nav-item" data-section="order"><span>🛒</span> 订单管理</a>
            <div style="margin-top: 20px; padding: 0 20px; font-size: 14px; color: #95a5a6;">商品分类</div>
            <a href="#" class="nav-item" data-category="phone"><span>📱</span> 手机数码</a>
            <a href="#" class="nav-item" data-category="computer"><span>💻</span> 电脑办公</a>
            <a href="#" class="nav-item" data-category="home"><span>🏠</span> 家居家装</a>
            <a href="#" class="nav-item" data-category="clothes"><span>👕</span> 服饰鞋包</a>
            <a href="#" class="nav-item" data-category="food"><span>🍎</span> 食品饮料</a>
            <a href="#" class="nav-item" data-category="book"><span>📚</span> 图书文具</a>
            <a href="#" class="nav-item" data-category="sport"><span>⚽</span> 运动户外</a>
            <a href="#" class="nav-item" data-category="beauty"><span>💄</span> 美妆个护</a>
            <a href="#" class="nav-item" data-category="baby"><span>🧸</span> 母婴玩具</a>
            <a href="#" class="nav-item" data-category="hardware"><span>🔧</span> 五金工具</a>
        </nav>
        
        <!-- 主内容区 -->
        <main class="main-content">
            <!-- 商品管理区域 -->
            <div class="product-management" id="productManagement">
                <div class="content-header">
                    <h2 id="categoryTitle">手机数码</h2>
                    <button class="add-product-btn" onclick="showAddModal()">➕ 添加商品</button>
                </div>
                <div class="product-grid" id="productGrid">
                    <!-- 商品会通过JavaScript动态加载 -->
                </div>
            </div>
            
            <!-- 订单管理区域 -->
            <div class="order-management" id="orderManagement">
                <div class="content-header">
                    <h2>订单管理</h2>
                </div>
                
                <!-- 订单汇总 -->
                <div class="order-summary">
                    <h3>📊 订单汇总</h3>
                    <div class="order-stats">
                        <div class="stat-card">
                            <div class="stat-number" id="totalOrders">0</div>
                            <div class="stat-label">总订单数</div>
                        </div>
                        <div class="stat-card pending">
                            <div class="stat-number" id="pendingOrders">0</div>
                            <div class="stat-label">待发货</div>
                        </div>
                        <div class="stat-card shipped">
                            <div class="stat-number" id="shippedOrders">0</div>
                            <div class="stat-label">已发货</div>
                        </div>
                        <div class="stat-card completed">
                            <div class="stat-number" id="completedOrders">0</div>
                            <div class="stat-label">已完成</div>
                        </div>
                        <div class="stat-card revenue">
                            <div class="stat-number" id="totalRevenue" style="font-size: 22px;">￥0.00</div>
                            <div class="stat-label">已发货订单金额</div>
                        </div>
                    </div>
                </div>
                
                <!-- 订单列表 -->
                <div class="order-table">
                    <table>
                        <thead>
                            <tr>
                                <th>订单号</th>
                                <th>用户名</th>
                                <th>下单时间</th>
                                <th>订单金额</th>
                                <th>状态</th>
                                <th>商品明细</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody id="orderTableBody">
                            <!-- 订单会通过JavaScript动态加载 -->
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
    
    <!-- 添加/编辑商品模态框 -->
    <div id="productModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">添加商品</h3>
            </div>
            <form id="productForm">
                <input type="hidden" id="editProductId">
                <div class="form-group">
                    <label for="productId">商品ID *</label>
                    <input type="text" id="productId" required>
                </div>
                <div class="form-group">
                    <label for="productName">商品名称 *</label>
                    <input type="text" id="productName" required>
                </div>
                <div class="form-group">
                    <label for="productCategory">商品分类 *</label>
                    <select id="productCategory" required>
                        <option value="phone">手机数码</option>
                        <option value="computer">电脑办公</option>
                        <option value="home">家居家装</option>
                        <option value="clothes">服饰鞋包</option>
                        <option value="food">食品饮料</option>
                        <option value="book">图书文具</option>
                        <option value="sport">运动户外</option>
                        <option value="beauty">美妆个护</option>
                        <option value="baby">母婴玩具</option>
                        <option value="hardware">五金工具</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="productIcon">商品图标 (Emoji) *</label>
                    <input type="text" id="productIcon" placeholder="例如: 📱" required>
                </div>
                <div class="form-group">
                    <label for="productPrice">商品价格 *</label>
                    <input type="number" id="productPrice" step="0.01" min="0" required>
                </div>
                <div class="modal-actions">
                    <button type="submit" class="btn-save">保存</button>
                    <button type="button" class="btn-cancel" onclick="closeModal()">取消</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- 查看评价模态框 -->
    <div id="reviewModal" class="modal">
        <div class="modal-content" style="max-width: 700px;">
            <div class="modal-header">
                <h3 id="reviewModalTitle">商品评价</h3>
                <span class="modal-close" onclick="closeReviewModal()">&times;</span>
            </div>
            <div id="reviewSummary" class="review-summary">
                <div class="summary-item">
                    <div class="summary-label">平均评分</div>
                    <div class="summary-value" id="avgRating">0.0</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">评价总数</div>
                    <div class="summary-value" id="reviewCount">0</div>
                </div>
            </div>
            <div id="reviewList" style="max-height: 500px; overflow-y: auto;">
                <!-- 评价会通过JavaScript动态加载 -->
            </div>
        </div>
    </div>
    
    <script>
        let products = {};
        let currentCategory = 'phone';
        let currentSection = 'product'; // 'product' 或 'order'
        
        // 获取分类名称
        function getCategoryName(category) {
            var categoryNames = {
                'phone': '手机数码',
                'computer': '电脑办公',
                'home': '家居家装',
                'clothes': '服饰鞋包',
                'food': '食品饮料',
                'book': '图书文具',
                'sport': '运动户外',
                'beauty': '美妆个护',
                'baby': '母婴玩具',
                'hardware': '五金工具'
            };
            return categoryNames[category] || '热门商品';
        }
        
        // 显示提示消息
        function showToast(message, type) {
            type = type || 'success';
            var toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast ' + type;
            
            setTimeout(function() {
                toast.classList.add('show');
            }, 10);
            
            setTimeout(function() {
                toast.classList.remove('show');
            }, 2000);
        }
        
        // 加载商品数据
        function loadProducts(category) {
            currentCategory = category;
            var contextPath = '${pageContext.request.contextPath}';
            var url = contextPath + '/products?action=admin_data&category=' + category;
            
            fetch(url)
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('网络响应失败');
                    }
                    return response.json();
                })
                .then(function(data) {
                    products[category] = data.products.map(function(p) {
                        return {
                            id: p.id,
                            name: p.name,
                            icon: p.icon,
                            price: p.price,
                            orderCount: p.orderCount || 0
                        };
                    });
                    renderProducts(category);
                })
                .catch(function(error) {
                    console.error('加载商品数据失败:', error);
                    showToast('✗ 加载失败', 'error');
                });
        }
        
        // 切换到指定分类
        function switchCategory(category) {
            // 更新当前分类
            currentCategory = category;
            
            // 更新导航栏高亮
            document.querySelectorAll('.nav-item[data-category]').forEach(function(item) {
                item.classList.remove('active');
                if (item.getAttribute('data-category') === category) {
                    item.classList.add('active');
                }
            });
            
            // 加载商品数据
            loadProducts(category);
            
            // 更新标题
            document.getElementById('categoryTitle').textContent = getCategoryName(category);
        }
        
        // 渲染商品
        function renderProducts(category) {
            const grid = document.getElementById('productGrid');
            const categoryProducts = products[category];
            
            if (!categoryProducts || categoryProducts.length === 0) {
                grid.innerHTML = '<p style="text-align: center; color: #999; padding: 50px;">暂无商品</p>';
                return;
            }
            
            let html = '';
            for (let i = 0; i < categoryProducts.length; i++) {
                const product = categoryProducts[i];
                html += '<div class="product-card">';
                html += '  <div class="product-image">' + product.icon + '</div>';
                html += '  <div class="product-info">';
                html += '    <div class="product-id">ID: ' + product.id + '</div>';
                html += '    <div class="product-name">' + product.name + '</div>';
                html += '    <div class="product-price">¥' + product.price.toFixed(2) + '</div>';
                html += '    <div class="product-orders">📦 已订购: ' + product.orderCount + ' 件</div>';
                html += '    <div class="product-actions">';
                html += '      <button class="btn-reviews" onclick="showReviewsModal(\'' + product.id + '\', \'' + product.name + '\')">查看评价</button>';
                html += '      <button class="btn-edit" onclick="showEditModal(\'' + product.id + '\')">编辑</button>';
                html += '      <button class="btn-delete" onclick="deleteProduct(\'' + product.id + '\')">删除</button>';
                html += '    </div>';
                html += '  </div>';
                html += '</div>';
            }
            
            grid.innerHTML = html;
        }
        
        // 显示添加模态框
        function showAddModal() {
            document.getElementById('modalTitle').textContent = '添加商品';
            document.getElementById('productForm').reset();
            document.getElementById('editProductId').value = '';
            document.getElementById('productId').disabled = false;
            document.getElementById('productCategory').value = currentCategory;
            document.getElementById('productModal').classList.add('show');
        }
        
        // 显示编辑模态框
        function showEditModal(productId) {
            const product = products[currentCategory].find(p => p.id === productId);
            if (!product) return;
            
            document.getElementById('modalTitle').textContent = '编辑商品';
            document.getElementById('editProductId').value = productId;
            document.getElementById('productId').value = productId;
            document.getElementById('productId').disabled = true;
            document.getElementById('productName').value = product.name;
            document.getElementById('productCategory').value = currentCategory;
            document.getElementById('productIcon').value = product.icon;
            document.getElementById('productPrice').value = product.price;
            document.getElementById('productModal').classList.add('show');
        }
        
        // 关闭模态框
        function closeModal() {
            document.getElementById('productModal').classList.remove('show');
        }
        
        // 表单提交
        document.getElementById('productForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const editId = document.getElementById('editProductId').value;
            const contextPath = '${pageContext.request.contextPath}';
            
            let url, params;
            
            if (editId) {
                // 编辑模式
                url = contextPath + '/products';
                params = new URLSearchParams();
                params.append('action', 'update');
                params.append('productId', editId);
                params.append('name', document.getElementById('productName').value);
                params.append('price', document.getElementById('productPrice').value);
                params.append('icon', document.getElementById('productIcon').value);
            } else {
                // 添加模式
                url = contextPath + '/products';
                params = new URLSearchParams();
                params.append('action', 'add');
                params.append('id', document.getElementById('productId').value);
                params.append('name', document.getElementById('productName').value);
                params.append('category', document.getElementById('productCategory').value);
                params.append('icon', document.getElementById('productIcon').value);
                params.append('price', document.getElementById('productPrice').value);
            }
            
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    showToast('✓ ' + data.message, 'success');
                    closeModal();
                    loadProducts(currentCategory);
                } else {
                    showToast('✗ ' + data.error, 'error');
                }
            })
            .catch(function(error) {
                console.error('操作失败:', error);
                showToast('✗ 操作失败', 'error');
            });
        });
        
        // 删除商品
        function deleteProduct(productId) {
            if (!confirm('确定要删除该商品吗？')) {
                return;
            }
            
            const contextPath = '${pageContext.request.contextPath}';
            const params = new URLSearchParams();
            params.append('action', 'delete');
            params.append('productId', productId);
            
            fetch(contextPath + '/products', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    showToast('✓ ' + data.message, 'success');
                    loadProducts(currentCategory);
                } else {
                    showToast('✗ ' + data.error, 'error');
                }
            })
            .catch(function(error) {
                console.error('删除失败:', error);
                showToast('✗ 删除失败', 'error');
            });
        }
        
        // 显示评价模态框
        function showReviewsModal(productId, productName) {
            document.getElementById('reviewModalTitle').textContent = '商品评价 - ' + productName;
            document.getElementById('reviewModal').classList.add('show');
            loadReviews(productId);
        }
        
        // 关闭评价模态框
        function closeReviewModal() {
            document.getElementById('reviewModal').classList.remove('show');
        }
        
        // 加载评价数据
        function loadReviews(productId) {
            const contextPath = '${pageContext.request.contextPath}';
            fetch(contextPath + '/review?productId=' + encodeURIComponent(productId))
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    if (data.success) {
                        // 更新评价摘要
                        document.getElementById('avgRating').textContent = data.avgRating.toFixed(1);
                        document.getElementById('reviewCount').textContent = data.reviewCount;
                        
                        // 渲染评价列表
                        renderReviews(data.reviews, productId);
                    } else {
                        showToast('✗ 加载评价失败', 'error');
                    }
                })
                .catch(function(error) {
                    console.error('加载评价失败:', error);
                    showToast('✗ 加载评价失败', 'error');
                });
        }
        
        // 渲染评价列表
        function renderReviews(reviews, productId) {
            const reviewList = document.getElementById('reviewList');
            
            if (!reviews || reviews.length === 0) {
                reviewList.innerHTML = '<div class="no-reviews">暂无评价</div>';
                return;
            }
            
            let html = '';
            for (let i = 0; i < reviews.length; i++) {
                const review = reviews[i];
                const stars = '★'.repeat(review.rating) + '☆'.repeat(5 - review.rating);
                
                html += '<div class="review-item">';
                html += '  <div class="review-header">';
                html += '    <span class="review-user">👤 ' + escapeHtml(review.username) + '</span>';
                html += '    <span class="review-time">' + review.reviewTime + '</span>';
                html += '  </div>';
                html += '  <div class="review-rating">' + stars + '</div>';
                html += '  <div class="review-content">' + escapeHtml(review.content) + '</div>';
                html += '  <div style="text-align: right;">';
                html += '    <button class="review-delete-btn" onclick="deleteReview(' + review.id + ', \'' + productId + '\')">删除评价</button>';
                html += '  </div>';
                html += '</div>';
            }
            
            reviewList.innerHTML = html;
        }
        
        // 删除评价
        function deleteReview(reviewId, productId) {
            if (!confirm('确定要删除该评价吗？')) {
                return;
            }
            
            const contextPath = '${pageContext.request.contextPath}';
            const params = new URLSearchParams();
            params.append('action', 'delete');
            params.append('reviewId', reviewId);
            
            fetch(contextPath + '/review', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    showToast('✓ ' + data.message, 'success');
                    // 重新加载评价
                    loadReviews(productId);
                } else {
                    showToast('✗ ' + data.message, 'error');
                }
            })
            .catch(function(error) {
                console.error('删除评价失败:', error);
                showToast('✗ 删除评价失败', 'error');
            });
        }
        
        // HTML转义函数
        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.appendChild(document.createTextNode(text));
            return div.innerHTML;
        }
        
        // 加载订单数据
        function loadOrders() {
            const contextPath = '${pageContext.request.contextPath}';
            fetch(contextPath + '/order?action=list')
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('网络响应失败');
                    }
                    return response.json();
                })
                .then(function(data) {
                    renderOrderSummary(data.orders);
                    renderOrderTable(data.orders);
                })
                .catch(function(error) {
                    console.error('加载订单数据失败:', error);
                    showToast('✗ 加载订单失败', 'error');
                });
        }
        
        // 渲染订单汇总
        function renderOrderSummary(orders) {
            let total = orders.length;
            let pending = 0;
            let shipped = 0;
            let completed = 0;
            let shippedRevenue = 0;
            
            for (let i = 0; i < orders.length; i++) {
                const status = orders[i].status;
                if (status === '待发货') {
                    pending++;
                } else if (status === '已发货') {
                    shipped++;
                    shippedRevenue += parseFloat(orders[i].totalAmount) || 0;
                } else if (status === '已完成') {
                    completed++;
                }
            }
            
            document.getElementById('totalOrders').textContent = total;
            document.getElementById('pendingOrders').textContent = pending;
            document.getElementById('shippedOrders').textContent = shipped;
            document.getElementById('completedOrders').textContent = completed;
            document.getElementById('totalRevenue').textContent = '￥' + shippedRevenue.toFixed(2);
        }
        
        // 渲染订单表格
        function renderOrderTable(orders) {
            const tbody = document.getElementById('orderTableBody');
            
            if (!orders || orders.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="no-orders">暂无订单</td></tr>';
                return;
            }
            
            let html = '';
            for (let i = 0; i < orders.length; i++) {
                const order = orders[i];
                const statusClass = order.status === '待发货' ? 'status-pending' : 
                                   order.status === '已发货' ? 'status-shipped' : 'status-completed';
                
                // 商品明细
                let itemsText = '';
                if (order.items && order.items.length > 0) {
                    const itemNames = order.items.map(function(item) {
                        return item.productName + ' x' + item.quantity;
                    });
                    itemsText = itemNames.join(', ');
                }
                
                // 发货按钮
                let shipButton = '';
                if (order.status === '待发货') {
                    shipButton = '<button class="ship-btn" onclick="shipOrder(\'' + order.orderId + '\')">发货</button>';
                } else if (order.status === '已发货') {
                    shipButton = '<button class="ship-btn" onclick="completeOrder(\'' + order.orderId + '\')">完成</button>';
                } else {
                    shipButton = '<span style="color: #95a5a6;">已完成</span>';
                }
                
                html += '<tr>';
                html += '  <td>' + order.orderId + '</td>';
                html += '  <td>' + escapeHtml(order.username) + '</td>';
                html += '  <td>' + order.orderTime + '</td>';
                html += '  <td>￥' + parseFloat(order.totalAmount).toFixed(2) + '</td>';
                html += '  <td><span class="status-badge ' + statusClass + '">' + order.status + '</span></td>';
                html += '  <td class="order-items-detail">' + escapeHtml(itemsText) + '</td>';
                html += '  <td>' + shipButton + '</td>';
                html += '</tr>';
            }
            
            tbody.innerHTML = html;
        }
        
        // 发货
        function shipOrder(orderId) {
            if (!confirm('确定要发货该订单吗？')) {
                return;
            }
            
            const contextPath = '${pageContext.request.contextPath}';
            const params = new URLSearchParams();
            params.append('action', 'ship');
            params.append('orderId', orderId);
            
            fetch(contextPath + '/order', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    showToast('✓ ' + data.message, 'success');
                    // 重新加载订单
                    loadOrders();
                } else {
                    showToast('✗ ' + data.error, 'error');
                }
            })
            .catch(function(error) {
                console.error('发货失败:', error);
                showToast('✗ 发货失败', 'error');
            });
        }
        
        // 完成订单
        function completeOrder(orderId) {
            if (!confirm('确定要完成该订单吗？')) {
                return;
            }
            
            const contextPath = '${pageContext.request.contextPath}';
            const params = new URLSearchParams();
            params.append('action', 'complete');
            params.append('orderId', orderId);
            
            fetch(contextPath + '/order', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    showToast('✓ ' + data.message, 'success');
                    // 重新加载订单
                    loadOrders();
                } else {
                    showToast('✗ ' + data.error, 'error');
                }
            })
            .catch(function(error) {
                console.error('完成订单失败:', error);
                showToast('✗ 完成订单失败', 'error');
            });
        }
        
        // 切换管理区域
        function switchSection(section) {
            currentSection = section;
            
            if (section === 'product') {
                document.getElementById('productManagement').classList.remove('hidden');
                document.getElementById('orderManagement').classList.remove('active');
            } else if (section === 'order') {
                document.getElementById('productManagement').classList.add('hidden');
                document.getElementById('orderManagement').classList.add('active');
                // 加载订单数据
                loadOrders();
            }
        }
        
        // 切换用户菜单显示/隐藏
        function toggleUserMenu() {
            var userMenu = document.getElementById('userMenu');
            if (userMenu) {
                userMenu.classList.toggle('show');
            }
        }
        
        // 点击其他地方关闭用户菜单
        document.addEventListener('click', function(e) {
            var userDropdown = document.querySelector('.user-dropdown');
            var userMenu = document.getElementById('userMenu');
            
            if (userDropdown && userMenu && !userDropdown.contains(e.target)) {
                userMenu.classList.remove('show');
            }
        });
        
        // 搜索商品功能
        function searchProducts() {
            var searchBox = document.getElementById('searchBox');
            var keyword = searchBox.value.trim();
            
            if (!keyword) {
                showToast('请输入搜索关键词', 'error');
                return;
            }
            
            console.log('开始搜索:', keyword);
            
            // 切换到商品管理区域
            switchSection('product');
            
            // 调用后端搜索API
            var contextPath = '${pageContext.request.contextPath}';
            var url = contextPath + '/products?keyword=' + encodeURIComponent(keyword);
            
            console.log('请求URL:', url);
            
            fetch(url)
                .then(function(response) {
                    console.log('响应状态:', response.status);
                    if (!response.ok) {
                        throw new Error('网络响应失败: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('搜索返回数据:', data);
                    if (data.found && data.products.length > 0) {
                        // 转换搜索结果格式
                        var searchResults = data.products.map(function(p) {
                            return {
                                id: p.id,
                                name: p.name,
                                icon: p.icon,
                                price: p.price,
                                orderCount: p.orderCount || 0
                            };
                        });
                        
                        // 存储搜索结果
                        products['search'] = searchResults;
                        
                        // 更新标题
                        document.getElementById('categoryTitle').textContent = 
                            '搜索结果（找到 ' + data.products.length + ' 件商品）';
                        
                        // 清除分类导航的激活状态
                        document.querySelectorAll('.nav-item[data-category]').forEach(nav => {
                            nav.classList.remove('active');
                        });
                        
                        // 显示搜索结果
                        renderProducts('search');
                        
                        showToast('✓ 找到 ' + data.products.length + ' 件商品', 'success');
                    } else {
                        // 未找到商品
                        document.getElementById('categoryTitle').textContent = '搜索结果';
                        var grid = document.getElementById('productGrid');
                        grid.innerHTML = '<p style="text-align: center; color: #999; padding: 50px; font-size: 18px;">😔 未找到包含"' + keyword + '"的商品</p>';
                        showToast(' 未找到该商品', 'error');
                    }
                })
                .catch(function(error) {
                    console.error('搜索失败:', error);
                    var grid = document.getElementById('productGrid');
                    if (grid) {
                        grid.innerHTML = '<p style="text-align: center; color: red; padding: 50px;">搜索失败: ' + error.message + '</p>';
                    }
                    showToast('✗ 搜索失败', 'error');
                });
        }
        
        // 页面加载
        window.onload = function() {
            // 初始化显示商品管理
            switchSection('product');
            
            // 加载初始分类
            const urlParams = new URLSearchParams(window.location.search);
            const category = urlParams.get('category') || 'phone';
            
            // 设置分类导航激活状态
            document.querySelectorAll('.nav-item[data-category]').forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('data-category') === category) {
                    item.classList.add('active');
                }
            });
            
            document.getElementById('categoryTitle').textContent = getCategoryName(category);
            loadProducts(category);
            
            // 管理菜单点击事件（商品管理、订单管理）
            document.querySelectorAll('.nav-item[data-section]').forEach(item => {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    const target = e.target.closest('.nav-item');
                    if (!target) return;
                    
                    const section = target.getAttribute('data-section');
                    
                    // 更新激活状态
                    document.querySelectorAll('.nav-item[data-section]').forEach(nav => {
                        nav.classList.remove('active');
                    });
                    target.classList.add('active');
                    
                    // 切换区域
                    switchSection(section);
                });
            });
            
            // 分类导航点击事件
            document.querySelectorAll('.nav-item[data-category]').forEach(item => {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    const target = e.target.closest('.nav-item');
                    if (!target) return;
                    
                    const category = target.getAttribute('data-category');
                    
                    // 切换到商品管理
                    switchSection('product');
                    
                    // 更新激活状态
                    document.querySelectorAll('.nav-item[data-category]').forEach(nav => {
                        nav.classList.remove('active');
                    });
                    target.classList.add('active');
                    
                    document.getElementById('categoryTitle').textContent = getCategoryName(category);
                    loadProducts(category);
                });
            });
        };
    </script>
</body>
</html>
