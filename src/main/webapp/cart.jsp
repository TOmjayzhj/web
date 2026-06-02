<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    // 检查用户是否已登录
    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // 如果是管理员，跳转到管理员页面
    String cartRole = (String) session.getAttribute("role");
    if ("admin".equals(cartRole)) {
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
    <title>我的购物车</title>
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
        
        .header {
            background-color: #ffffff;
            padding: 20px 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .back-btn {
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.2s;
        }
        
        .back-btn:hover {
            background-color: #2980b9;
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .cart-header {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .cart-header h2 {
            color: #2c3e50;
            font-size: 24px;
        }
        
        .cart-items {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .cart-item {
            display: grid;
            grid-template-columns: 80px 1fr 120px 150px 100px 50px;
            gap: 20px;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.2s;
        }
        
        .cart-item:hover {
            background-color: #f9f9f9;
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .item-icon {
            font-size: 48px;
            text-align: center;
        }
        
        .item-name {
            font-size: 16px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .item-price {
            color: #e74c3c;
            font-size: 18px;
            font-weight: bold;
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quantity-control button {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background-color: white;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
            transition: all 0.2s;
        }
        
        .quantity-control button:hover {
            background-color: #3498db;
            color: white;
            border-color: #3498db;
        }
        
        .quantity-control input {
            width: 50px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px;
        }
        
        .item-subtotal {
            color: #e74c3c;
            font-size: 18px;
            font-weight: bold;
        }
        
        .delete-btn {
            background: none;
            border: none;
            color: #e74c3c;
            cursor: pointer;
            font-size: 20px;
            transition: transform 0.2s;
        }
        
        .delete-btn:hover {
            transform: scale(1.2);
        }
        
        .cart-summary {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: right;
        }
        
        .total-price {
            font-size: 24px;
            color: #e74c3c;
            font-weight: bold;
            margin-bottom: 15px;
        }
        
        .clear-btn {
            padding: 12px 30px;
            background-color: #e74c3c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.2s;
        }
        
        .clear-btn:hover {
            background-color: #c0392b;
        }
        
        .checkout-btn {
            padding: 12px 40px;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: background-color 0.2s;
            margin-right: 10px;
        }
        
        .checkout-btn:hover {
            background-color: #229954;
        }
        
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            font-size: 18px;
        }
        
        .empty-cart-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="logo">🛒 我的购物车</div>
        <a href="${pageContext.request.contextPath}/shop.jsp" class="back-btn">继续购物</a>
    </header>
    
    <div class="container">
        <div class="cart-header">
            <h2>购物车商品</h2>
        </div>
        
        <div class="cart-items" id="cartItems">
            <!-- 购物车商品会动态加载 -->
        </div>
        
        <div class="cart-summary" id="cartSummary" style="display: none;">
            <div class="total-price">
                总计：<span id="totalPrice">¥0.00</span>
            </div>
            <button class="checkout-btn" onclick="checkout()">💳 结算</button>
            <button class="clear-btn" onclick="clearCart()">清空购物车</button>
        </div>
    </div>
    
    <script>
        // 加载购物车数据
        function loadCart() {
            var contextPath = '${pageContext.request.contextPath}';
            fetch(contextPath + '/cart?action=view')
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('加载失败');
                    }
                    return response.json();
                })
                .then(function(data) {
                    renderCart(data);
                })
                .catch(function(error) {
                    console.error('加载购物车失败:', error);
                    document.getElementById('cartItems').innerHTML = 
                        '<div class="empty-cart">加载失败</div>';
                });
        }
        
        // 渲染购物车
        function renderCart(data) {
            var cartItems = document.getElementById('cartItems');
            var cartSummary = document.getElementById('cartSummary');
            
            if (!data.items || data.items.length === 0) {
                cartItems.innerHTML = 
                    '<div class="empty-cart">' +
                    '<div class="empty-cart-icon">🛒</div>' +
                    '<div>购物车是空的</div>' +
                    '</div>';
                cartSummary.style.display = 'none';
                return;
            }
            
            var html = '';
            for (var i = 0; i < data.items.length; i++) {
                var item = data.items[i];
                html += '<div class="cart-item" data-product-id="' + item.productId + '">';
                html += '  <div class="item-icon">' + item.icon + '</div>';
                html += '  <div class="item-name">' + item.productName + '</div>';
                html += '  <div class="item-price">¥' + item.price.toFixed(2) + '</div>';
                html += '  <div class="quantity-control">';
                html += '    <button onclick="updateQuantity(\'' + item.productId + '\', ' + (item.quantity - 1) + ')">-</button>';
                html += '    <input type="text" value="' + item.quantity + '" readonly>';
                html += '    <button onclick="updateQuantity(\'' + item.productId + '\', ' + (item.quantity + 1) + ')">+</button>';
                html += '  </div>';
                html += '  <div class="item-subtotal">¥' + item.subtotal + '</div>';
                html += '  <button class="delete-btn" onclick="removeItem(\'' + item.productId + '\')">🗑️</button>';
                html += '</div>';
            }
            
            cartItems.innerHTML = html;
            document.getElementById('totalPrice').textContent = '¥' + data.total;
            cartSummary.style.display = 'block';
        }
        
        // 更新商品数量
        function updateQuantity(productId, quantity) {
            if (quantity <= 0) {
                removeItem(productId);
                return;
            }
            
            var contextPath = '${pageContext.request.contextPath}';
            var params = new URLSearchParams();
            params.append('action', 'update');
            params.append('productId', productId);
            params.append('quantity', quantity);
            
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
                    loadCart(); // 重新加载购物车
                }
            })
            .catch(function(error) {
                console.error('更新失败:', error);
            });
        }
        
        // 删除商品
        function removeItem(productId) {
            if (!confirm('确定要删除这个商品吗？')) {
                return;
            }
            
            var contextPath = '${pageContext.request.contextPath}';
            var params = new URLSearchParams();
            params.append('action', 'remove');
            params.append('productId', productId);
            
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
                    loadCart(); // 重新加载购物车
                }
            })
            .catch(function(error) {
                console.error('删除失败:', error);
            });
        }
        
        // 清空购物车
        function clearCart() {
            if (!confirm('确定要清空购物车吗？')) {
                return;
            }
            
            var contextPath = '${pageContext.request.contextPath}';
            var params = new URLSearchParams();
            params.append('action', 'clear');
            
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
                    loadCart(); // 重新加载购物车
                    updateCartCount(0); // 更新顶部购物车数量
                }
            })
            .catch(function(error) {
                console.error('清空失败:', error);
            });
        }
        
        // 结算
        function checkout() {
            if (!confirm('确定要结算这些商品吗？')) {
                return;
            }
            
            var contextPath = '${pageContext.request.contextPath}';
            var params = new URLSearchParams();
            params.append('action', 'checkout');
            
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
                    alert('订单创建成功！订单号：' + data.orderId);
                    // 跳转到订单页面
                    window.location.href = contextPath + '/order.jsp';
                } else {
                    alert('结算失败：' + data.error);
                }
            })
            .catch(function(error) {
                console.error('结算失败:', error);
                alert('结算失败，请重试');
            });
        }
        
        // 更新顶部购物车数量（如果需要）
        function updateCartCount(count) {
            var cartCount = document.querySelector('.cart-count');
            if (cartCount) {
                cartCount.textContent = count;
            }
        }
        
        // 页面加载时加载购物车
        window.onload = function() {
            loadCart();
        };
    </script>
</body>
</html>
