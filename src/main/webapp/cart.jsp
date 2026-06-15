<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <title>我的购物车</title>
    <style>
        .container {
            display: block;
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .back-btn {
            padding: 9px 18px;
            background-color: #4a90d9;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: background-color 0.15s;
            font-size: 13px;
        }
        .back-btn:hover { background-color: #357abd; }
        .cart-header {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
        }
        .cart-header h2 { color: #2d3436; font-size: 22px; font-weight: 600; }
        .cart-items {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
            overflow: hidden;
        }
        .cart-item {
            display: grid;
            grid-template-columns: 80px 1fr 120px 150px 100px 50px;
            gap: 20px;
            align-items: center;
            padding: 18px 20px;
            border-bottom: 1px solid #f1f2f6;
            transition: background-color 0.15s;
        }
        .cart-item:hover { background-color: #f5f8fb; }
        .cart-item:last-child { border-bottom: none; }
        .item-icon { font-size: 42px; text-align: center; }
        .item-name { font-size: 15px; font-weight: 600; color: #2d3436; }
        .item-price { color: #e74c3c; font-size: 16px; font-weight: 700; }
        .quantity-control { display: flex; align-items: center; gap: 8px; }
        .quantity-control button {
            width: 30px; height: 30px;
            border: 1px solid #e2e8f0;
            background-color: white;
            cursor: pointer;
            border-radius: 6px;
            font-size: 16px;
            transition: all 0.15s;
        }
        .quantity-control button:hover {
            background-color: #4a90d9;
            color: white;
            border-color: #4a90d9;
        }
        .quantity-control input {
            width: 50px; text-align: center;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 5px;
        }
        .item-subtotal { color: #e74c3c; font-size: 16px; font-weight: 700; }
        .delete-btn {
            background: none; border: none;
            color: #e74c3c; cursor: pointer;
            font-size: 18px; transition: transform 0.15s;
        }
        .delete-btn:hover { transform: scale(1.2); color: #c0392b; }
        .cart-summary {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
            text-align: right;
        }
        .total-price { font-size: 22px; color: #e74c3c; font-weight: 700; margin-bottom: 15px; }
        .clear-btn {
            padding: 10px 24px;
            background-color: #e74c3c;
            color: white; border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: background-color 0.15s;
        }
        .clear-btn:hover { background-color: #c0392b; }
        .clear-btn:active { background-color: #a93226; transform: scale(0.97); }
        .checkout-btn {
            padding: 10px 32px;
            background-color: #27ae60;
            color: white; border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: background-color 0.15s, transform 0.1s;
            margin-right: 10px;
        }
        .checkout-btn:hover { background-color: #219a52; }
        .checkout-btn:active { background-color: #1b8a47; transform: scale(0.97); }
        .empty-cart { text-align: center; padding: 60px 20px; color: #b2bec3; font-size: 16px; }
        .empty-cart-icon { font-size: 64px; margin-bottom: 16px; opacity: 0.6; }
    </style>
</head>
<body>
    <div id="toast" class="toast"></div>
    
    <header class="header">
        <div class="logo">我的购物车</div>
        <a href="${pageContext.request.contextPath}/shop.jsp" class="back-btn">继续购物</a>
    </header>
    
    <div class="container">
        <div class="cart-header">
            <h2>购物车商品</h2>
        </div>
        
        <div class="cart-items" id="cartItems">
        </div>
        
        <div class="cart-summary" id="cartSummary" style="display: none;">
            <div class="total-price">
                总计：<span id="totalPrice">¥0.00</span>
            </div>
            <button class="checkout-btn" onclick="checkout()">结算</button>
            <button class="clear-btn" onclick="clearCart()">清空购物车</button>
        </div>
    </div>
    
    <script>
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
                    loadCart();
                }
            })
            .catch(function(error) {
                console.error('更新失败:', error);
            });
        }

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
                    loadCart();
                }
            })
            .catch(function(error) {
                console.error('删除失败:', error);
            });
        }

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
                    loadCart();
                    updateCartCount(0);
                }
            })
            .catch(function(error) {
                console.error('清空失败:', error);
            });
        }

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
                    window.location.href = contextPath + '/order.jsp';
                } else {
                    showToast('结算失败：' + data.error, 'error');
                }
            })
            .catch(function(error) {
                console.error('结算失败:', error);
                showToast('结算失败，请重试', 'error');
            });
        }

        function updateCartCount(count) {
            var cartCount = document.querySelector('.cart-count');
            if (cartCount) {
                cartCount.textContent = count;
            }
        }

        function showToast(message, type) {
            type = type || 'success';
            var toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast ' + type;
            setTimeout(function() { toast.classList.add('show'); }, 10);
            setTimeout(function() { toast.classList.remove('show'); }, 2000);
        }

        window.onload = function() {
            loadCart();
        };
    </script>
</body>
</html>
