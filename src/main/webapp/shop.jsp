<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    // 检查用户是否已登录
    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // 如果是管理员，跳转到管理员页面
    String role = (String) session.getAttribute("role");
    if ("admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/admin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="data:,">
    <title>商品商城</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e8e8e8;
        }
        
        .container {
            display: grid;
            grid-template-columns: 250px 1fr;
            grid-template-rows: 80px 1fr;
            min-height: 100vh;
            gap: 0;
        }
        
        /* 顶部搜索区域 */
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
            background-color: #e8e8e8;
        }
        
        .content-header {
            margin-bottom: 25px;
        }
        
        .content-header h2 {
            color: #2c3e50;
            font-size: 24px;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
        }
        
        .product-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.15);
        }
        
        .product-image {
            height: 200px;
            background-color: #ecf0f1;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #7f8c8d;
            font-size: 48px;
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
        
        .product-price {
            color: #e74c3c;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .add-to-cart {
            width: 100%;
            padding: 10px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
            margin-bottom: 8px;
        }
        
        .add-to-cart:hover {
            background-color: #2980b9;
        }
        
        .view-detail {
            width: 100%;
            padding: 10px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
            margin-bottom: 8px;
        }
        
        .view-detail:hover {
            background-color: #2980b9;
        }
        
        /* 右下角购物车悬浮按钮 */
        .cart-float {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            background-color: #e74c3c;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            z-index: 1000;
            transition: transform 0.2s;
        }
        
        .cart-float:hover {
            transform: scale(1.1);
        }
        
        .cart-count {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: #f39c12;
            color: white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            font-size: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: bold;
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
        
        .user-info {
            flex: 1;
        }
        
        .user-name {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 4px;
        }
        
        .user-role {
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
    </style>
</head>
<body>
    <!-- 提示消息容器 -->
    <div id="toast" class="toast"></div>
    
    <div class="container">
        <!-- 顶部搜索栏 -->
        <header class="header">
            <div class="logo">商品商城</div>
            <div class="search-container">
                <input type="text" id="searchBox" class="search-box" placeholder="搜索商品...">
                <button class="search-btn" onclick="searchProducts()">🔍</button>
            </div>
            <div class="header-icons">
                <a href="${pageContext.request.contextPath}/order.jsp" class="icon-btn">
                    <span>📦</span>
                    <span>订单</span>
                    <span class="badge" id="orderBadge">0</span>
                </a>
                <div class="icon-btn user-dropdown" onclick="toggleUserMenu()">
                    <span>👤</span>
                    <span>${sessionScope.username}</span>
                    <!-- 用户下拉菜单 -->
                    <div id="userMenu" class="user-menu">
                        <div class="user-menu-header">
                            <div class="user-avatar">👤</div>
                            <div class="user-info">
                                <div class="user-name">${sessionScope.username}</div>
                                <div class="user-role" id="userRole">${sessionScope.role == 'admin' ? '管理员' : '普通用户'}</div>
                            </div>
                        </div>
                        <div class="user-menu-divider"></div>
                        <a href="${pageContext.request.contextPath}/logout" class="user-menu-item logout-item">
                            <span>🚪</span> 退出登录
                        </a>
                    </div>
                </div>
            </div>
        </header>
        
        <!-- 左侧分类导航 -->
        <nav class="sidebar">
            <div class="nav-title">商品分类</div>
            <a href="#" class="nav-item active" data-category="phone"><span>📱</span> 手机数码</a>
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
            <div class="content-header">
                <h2>热门商品</h2>
            </div>
            <div class="product-grid" id="productGrid">
                <!-- 商品会通过JavaScript动态加载 -->
            </div>
        </main>
    </div>
    
    <!-- 右下角悬浮购物车按钮 -->
    <div class="cart-float" onclick="window.location.href='${pageContext.request.contextPath}/cart.jsp'">
        🛒
        <span class="cart-count">0</span>
    </div>
    
    <script>
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
        
        // 从后端加载商品数据
        let products = {};
        let currentCategory = 'phone'; // 记录当前分类
        
        // 搜索商品功能
        function searchProducts() {
            var searchBox = document.getElementById('searchBox');
            var keyword = searchBox.value.trim();
            
            if (!keyword) {
                showToast('请输入搜索关键词', 'error');
                return;
            }
            
            // 调用后端搜索API
            var contextPath = '${pageContext.request.contextPath}';
            var url = contextPath + '/products?keyword=' + encodeURIComponent(keyword);
            
            fetch(url)
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('网络响应失败');
                    }
                    return response.json();
                })
                .then(function(data) {
                    if (data.found && data.products.length > 0) {
                        // 找到商品，获取第一个商品的分类
                        var firstProduct = data.products[0];
                        var category = firstProduct.category;
                        
                        // 转换商品数据格式
                        var searchResults = data.products.map(function(p) {
                            return {
                                id: p.id,
                                name: p.name,
                                icon: p.icon,
                                price: '￥' + p.price.toFixed(2)
                            };
                        });
                        
                        // 存储搜索结果
                        products['search'] = searchResults;
                        
                        // 切换到对应分类
                        switchCategory(category);
                        
                        // 显示搜索结果
                        renderProducts('search');
                        
                        // 更新标题
                        document.querySelector('.content-header h2').textContent = 
                            '搜索结果（找到 ' + data.products.length + ' 件商品）';
                        
                        showToast('✓ 找到 ' + data.products.length + ' 件商品', 'success');
                    } else {
                        // 未找到商品
                        document.querySelector('.content-header h2').textContent = '搜索结果';
                        var grid = document.getElementById('productGrid');
                        grid.innerHTML = '<p style="text-align: center; color: #999; padding: 50px; font-size: 18px;">😔 未找到包含“' + keyword + '”的商品</p>';
                        showToast('✗ 未找到该商品', 'error');
                    }
                })
                .catch(function(error) {
                    console.error('搜索失败:', error);
                    var grid = document.getElementById('productGrid');
                    if (grid) {
                        grid.innerHTML = '<p style="text-align: center; color: red; padding: 50px;">搜索失败，请重试</p>';
                    }
                    showToast('✗ 搜索失败', 'error');
                });
        }
        
        // 切换到指定分类
        function switchCategory(category) {
            // 更新当前分类
            currentCategory = category;
            
            // 更新导航栏高亮
            document.querySelectorAll('.nav-item').forEach(function(item) {
                item.classList.remove('active');
                if (item.getAttribute('data-category') === category) {
                    item.classList.add('active');
                }
            });
            
            // 更新URL
            var newUrl = window.location.pathname + '?category=' + category;
            window.history.pushState({}, '', newUrl);
        }
        
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
        
        // 查看商品详情
        function viewProductDetail(productId) {
            console.log('跳转到商品详情:', productId);
            window.location.href = 'product_detail.jsp?id=' + productId;
        }
        
        // 显示提示消息
        function showToast(message, type) {
            type = type || 'success';
            var toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast ' + type;
            
            // 显示提示
            setTimeout(function() {
                toast.classList.add('show');
            }, 10);
            
            // 2秒后自动隐藏
            setTimeout(function() {
                toast.classList.remove('show');
            }, 2000);
        }
        
        // 加载商品数据函数
        function loadProducts(category) {
            currentCategory = category; // 记录当前分类
            var contextPath = '${pageContext.request.contextPath}';
            var url = contextPath + '/products?category=' + category;
            
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
                            price: '¥' + p.price.toFixed(2)
                        };
                    });
                    renderProducts(category);
                })
                .catch(function(error) {
                    console.error('加载商品数据失败:', error);
                    var grid = document.getElementById('productGrid');
                    if (grid) {
                        grid.innerHTML = '<p style="text-align: center; color: red; padding: 50px;">加载失败，请检查控制台</p>';
                    }
                });
        }
        
        // 渲染商品函数
        function renderProducts(category) {
            const grid = document.getElementById('productGrid');
            
            if (!grid) {
                return;
            }
            
            const categoryProducts = products[category];
            
            if (!categoryProducts || categoryProducts.length === 0) {
                grid.innerHTML = '<p style="text-align: center; color: #999; padding: 50px;">暂无商品</p>';
                return;
            }
            
            // 使用字符串拼接生成HTML
            let html = '';
            for (let i = 0; i < categoryProducts.length; i++) {
                const product = categoryProducts[i];
                html += '<div class="product-card">';
                html += '  <div class="product-image" onclick="viewProductDetail(\'' + product.id + '\')" style="cursor:pointer">' + product.icon + '</div>';
                html += '  <div class="product-info">';
                html += '    <div class="product-name" onclick="viewProductDetail(\'' + product.id + '\')" style="cursor:pointer">' + product.name + '</div>';
                html += '    <div class="product-price">' + product.price + '</div>';
                html += '    <button class="view-detail" onclick="viewProductDetail(\'' + product.id + '\')">查看评价</button>';
                html += '    <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(\'' + product.id + '\')">加入购物车</button>';
                html += '  </div>';
                html += '</div>';
            }
            
            grid.innerHTML = html;
        }
        
        // 加载购物车数量
        function loadCartCount() {
            var contextPath = '${pageContext.request.contextPath}';
            fetch(contextPath + '/cart?action=view')
                .then(function(response) {
                    if (!response.ok) {
                        return;
                    }
                    return response.json();
                })
                .then(function(data) {
                    if (data && data.count !== undefined) {
                        var cartCount = document.querySelector('.cart-count');
                        if (cartCount) {
                            cartCount.textContent = data.count;
                        }
                    }
                })
                .catch(function(error) {
                    console.error('加载购物车数量失败:', error);
                });
        }
        
        // 加载订单数量
        function loadOrderCount() {
            var contextPath = '${pageContext.request.contextPath}';
            fetch(contextPath + '/order?action=count')
                .then(function(response) {
                    if (!response.ok) {
                        return;
                    }
                    return response.json();
                })
                .then(function(data) {
                    if (data && data.count !== undefined) {
                        var orderBadge = document.getElementById('orderBadge');
                        if (orderBadge) {
                            orderBadge.textContent = data.count;
                            // 如果订单数为0，隐藏badge
                            if (data.count === 0) {
                                orderBadge.style.display = 'none';
                            } else {
                                orderBadge.style.display = 'flex';
                            }
                        }
                    }
                })
                .catch(function(error) {
                    console.error('加载订单数量失败:', error);
                });
        }
        
        // 添加到购物车
        function addToCart(productId) {
            console.log('准备添加商品到购物车，ProductId:', productId);
            
            var contextPath = '${pageContext.request.contextPath}';
            
            // 使用 URLSearchParams 而不是 FormData
            var params = new URLSearchParams();
            params.append('action', 'add');
            params.append('productId', productId);
            params.append('quantity', '1');
            
            console.log('请求URL:', contextPath + '/cart');
            console.log('请求数据:', params.toString());
            
            fetch(contextPath + '/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(function(response) {
                console.log('响应状态:', response.status);
                console.log('响应OK:', response.ok);
                return response.json();
            })
            .then(function(data) {
                console.log('响应数据:', data);
                if (data.success) {
                    // 显示成功提示
                    showToast('✓ 已添加到购物车！！！！', 'success');
                    // 更新购物车数量
                    var cartCount = document.querySelector('.cart-count');
                    if (cartCount) {
                        cartCount.textContent = data.itemCount;
                    }
                } else {
                    showToast('✗ ' + data.error, 'error');
                }
            })
            .catch(function(error) {
                console.error('添加失败:', error);
                showToast('✗ 添加失败，请重试', 'error');
            });
        }

        // 页面加载时根据URL参数高亮对应分类并显示商品
        window.onload = function() {
            console.log('页面加载完成');
            
            // 加载购物车数量
            loadCartCount();
            
            // 加载订单数量
            loadOrderCount();
            
            // 为搜索框添加回车键事件
            var searchBox = document.getElementById('searchBox');
            if (searchBox) {
                searchBox.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        searchProducts();
                    }
                });
            }
            
            const urlParams = new URLSearchParams(window.location.search);
            const currentCategory = urlParams.get('category') || 'phone';
            console.log('当前分类:', currentCategory);
            
            // 移除所有active类
            document.querySelectorAll('.nav-item').forEach(item => {
                item.classList.remove('active');
            });
            
            // 为当前分类添加active类
            const activeItem = document.querySelector(`.nav-item[data-category="${currentCategory}"]`);
            if (activeItem) {
                activeItem.classList.add('active');
            }
            
            // 更新页面标题
            document.querySelector('.content-header h2').textContent = getCategoryName(currentCategory);
            
            // 从后端加载商品数据
            loadProducts(currentCategory);
            
            // 为所有导航项添加点击事件
            document.querySelectorAll('.nav-item').forEach(item => {
                item.addEventListener('click', function(e) {
                    e.preventDefault(); // 阻止默认链接行为
                    
                    // 确保获取到的是 <a> 元素的 data-category
                    const target = e.target.closest('.nav-item');
                    if (!target) {
                        console.error('未找到导航项');
                        return;
                    }
                    
                    const category = target.getAttribute('data-category');
                    console.log('点击分类:', category);
                    
                    // 清空搜索框
                    var searchBox = document.getElementById('searchBox');
                    if (searchBox) {
                        searchBox.value = '';
                    }
                    
                    // 更新URL（不刷新页面）
                    const newUrl = window.location.pathname + '?category=' + category;
                    console.log('新URL:', newUrl);
                    window.history.pushState({}, '', newUrl);
                    
                    // 更新active状态
                    document.querySelectorAll('.nav-item').forEach(nav => {
                        nav.classList.remove('active');
                    });
                    target.classList.add('active');
                    
                    // 更新标题
                    document.querySelector('.content-header h2').textContent = getCategoryName(category);
                    
                    // 从后端加载商品
                    loadProducts(category);
                });
            });
        };
    </script>
</body>
</html>
