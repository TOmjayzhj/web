<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <title>商品商城</title>
    <style>
        .cart-float {
            position: fixed;
            bottom: 28px;
            right: 28px;
            width: 56px;
            height: 56px;
            background-color: #4a90d9;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 22px;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(74,144,217,0.35);
            z-index: 1000;
            transition: transform 0.2s, box-shadow 0.2s, background-color 0.2s;
        }
        
        .cart-float:hover {
            transform: scale(1.1);
            box-shadow: 0 8px 24px rgba(74,144,217,0.5);
            background-color: #357abd;
        }
        
        .cart-float:active {
            transform: scale(0.95);
        }
        
        .cart-count {
            position: absolute;
            top: -4px;
            right: -4px;
            background-color: #e74c3c;
            color: white;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            font-size: 11px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: 700;
            border: 2px solid #fff;
        }
        
        .nav-item .nav-icon {
            margin-right: 6px;
        }
    </style>
</head>
<body>
    <div id="toast" class="toast"></div>
    
    <div class="container">
        <header class="header">
            <div class="logo">商品商城</div>
            <div class="search-container">
                <input type="text" id="searchBox" class="search-box" placeholder="搜索商品...">
                <button class="search-btn" onclick="searchProducts()">&#128269;</button>
            </div>
            <div class="header-icons">
                <a href="${pageContext.request.contextPath}/order.jsp" class="icon-btn">
                    <span>&#128230;</span>
                    <span>订单</span>
                    <span class="badge" id="orderBadge">0</span>
                </a>
                <div class="icon-btn user-dropdown" onclick="toggleUserMenu()">
                    <span>&#128100;</span>
                    <span>${sessionScope.username}</span>
                    <div id="userMenu" class="user-menu">
                        <div class="user-menu-header">
                            <div class="user-avatar">&#128100;</div>
                            <div class="user-info">
                                <div class="user-name">${sessionScope.username}</div>
                                <div class="user-role" id="userRole">${sessionScope.role == 'admin' ? '管理员' : '普通用户'}</div>
                            </div>
                        </div>
                        <div class="user-menu-divider"></div>
                        <a href="${pageContext.request.contextPath}/logout" class="user-menu-item logout-item">
                            <span>&#128682;</span> 退出登录
                        </a>
                    </div>
                </div>
            </div>
        </header>
        
        <nav class="sidebar">
            <div class="nav-title">商品分类</div>
            <a href="#" class="nav-item active" data-category="phone">手机数码</a>
            <a href="#" class="nav-item" data-category="computer">电脑办公</a>
            <a href="#" class="nav-item" data-category="home">家居家装</a>
            <a href="#" class="nav-item" data-category="clothes">服饰鞋包</a>
            <a href="#" class="nav-item" data-category="food">食品饮料</a>
            <a href="#" class="nav-item" data-category="book">图书文具</a>
            <a href="#" class="nav-item" data-category="sport">运动户外</a>
            <a href="#" class="nav-item" data-category="beauty">美妆个护</a>
            <a href="#" class="nav-item" data-category="baby">母婴玩具</a>
            <a href="#" class="nav-item" data-category="hardware">五金工具</a>
        </nav>
        
        <main class="main-content">
            <div class="content-header">
                <h2>热门商品</h2>
            </div>
            <div class="product-grid" id="productGrid">
            </div>
        </main>
    </div>
    
    <div class="cart-float" onclick="window.location.href='${pageContext.request.contextPath}/cart.jsp'">
        &#128722;
        <span class="cart-count">0</span>
    </div>
    
    <script>
        function toggleUserMenu() {
            var userMenu = document.getElementById('userMenu');
            if (userMenu) {
                userMenu.classList.toggle('show');
            }
        }

        document.addEventListener('click', function(e) {
            var userDropdown = document.querySelector('.user-dropdown');
            var userMenu = document.getElementById('userMenu');
            
            if (userDropdown && userMenu && !userDropdown.contains(e.target)) {
                userMenu.classList.remove('show');
            }
        });
        
        let products = {};
        let currentCategory = 'phone';

        function searchProducts() {
            var searchBox = document.getElementById('searchBox');
            var keyword = searchBox.value.trim();
            
            if (!keyword) {
                showToast('请输入搜索关键词', 'error');
                return;
            }
            
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
                        var firstProduct = data.products[0];
                        var category = firstProduct.category;

                        var searchResults = data.products.map(function(p) {
                            return {
                                id: p.id,
                                name: p.name,
                                icon: p.icon,
                                price: '¥' + p.price.toFixed(2)
                            };
                        });
                        
                        products['search'] = searchResults;
                        switchCategory(category);
                        renderProducts('search');

                        document.querySelector('.content-header h2').textContent = 
                            '搜索结果（找到 ' + data.products.length + ' 件商品）';
                        
                        showToast('找到 ' + data.products.length + ' 件商品', 'success');
                    } else {
                        document.querySelector('.content-header h2').textContent = '搜索结果';
                        var grid = document.getElementById('productGrid');
                        grid.innerHTML = '<p style="text-align: center; color: #888; padding: 50px; font-size: 16px;">未找到包含“' + keyword + '”的商品</p>';
                        showToast('未找到该商品', 'error');
                    }
                })
                .catch(function(error) {
                    console.error('搜索失败:', error);
                    var grid = document.getElementById('productGrid');
                    if (grid) {
                        grid.innerHTML = '<p style="text-align: center; color: red; padding: 50px;">搜索失败，请重试</p>';
                    }
                    showToast('搜索失败', 'error');
                });
        }

        function switchCategory(category) {
            currentCategory = category;

            document.querySelectorAll('.nav-item').forEach(function(item) {
                item.classList.remove('active');
                if (item.getAttribute('data-category') === category) {
                    item.classList.add('active');
                }
            });

            var newUrl = window.location.pathname + '?category=' + category;
            window.history.pushState({}, '', newUrl);
        }

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

        function viewProductDetail(productId) {
            window.location.href = 'product_detail.jsp?id=' + productId;
        }

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

        function loadProducts(category) {
            currentCategory = category;
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

        function addToCart(productId) {
            var contextPath = '${pageContext.request.contextPath}';

            var params = new URLSearchParams();
            params.append('action', 'add');
            params.append('productId', productId);
            params.append('quantity', '1');
            
            fetch(contextPath + '/cart', {
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
                    showToast('已添加到购物车', 'success');
                    var cartCount = document.querySelector('.cart-count');
                    if (cartCount) {
                        cartCount.textContent = data.itemCount;
                    }
                } else {
                    showToast(data.error, 'error');
                }
            })
            .catch(function(error) {
                console.error('添加失败:', error);
                showToast('添加失败，请重试', 'error');
            });
        }

        window.onload = function() {
            loadCartCount();
            loadOrderCount();

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

            document.querySelectorAll('.nav-item').forEach(item => {
                item.classList.remove('active');
            });

            const activeItem = document.querySelector(`.nav-item[data-category="${currentCategory}"]`);
            if (activeItem) {
                activeItem.classList.add('active');
            }

            document.querySelector('.content-header h2').textContent = getCategoryName(currentCategory);
            loadProducts(currentCategory);

            document.querySelectorAll('.nav-item').forEach(item => {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    const target = e.target.closest('.nav-item');
                    if (!target) return;

                    const category = target.getAttribute('data-category');

                    var searchBox = document.getElementById('searchBox');
                    if (searchBox) {
                        searchBox.value = '';
                    }

                    const newUrl = window.location.pathname + '?category=' + category;
                    window.history.pushState({}, '', newUrl);

                    document.querySelectorAll('.nav-item').forEach(nav => {
                        nav.classList.remove('active');
                    });
                    target.classList.add('active');

                    document.querySelector('.content-header h2').textContent = getCategoryName(category);
                    loadProducts(category);
                });
            });
        };
    </script>
</body>
</html>
