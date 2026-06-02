<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    // 检查用户是否已登录
    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // 如果是管理员，跳转到管理员页面
    String orderRole = (String) session.getAttribute("role");
    if ("admin".equals(orderRole)) {
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
    <title>我的订单</title>
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
        
        .header-actions {
            display: flex;
            gap: 10px;
        }
        
        .header-btn {
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .header-btn:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .header-btn.primary {
            background-color: #27ae60;
        }
        
        .header-btn.primary:hover {
            background-color: #229954;
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .order-header {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .order-header h2 {
            color: #2c3e50;
            font-size: 24px;
        }
        
        .order-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .order-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .order-info {
            padding: 20px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .order-meta {
            display: flex;
            gap: 30px;
        }
        
        .meta-item {
            display: flex;
            flex-direction: column;
        }
        
        .meta-label {
            font-size: 12px;
            color: #999;
            margin-bottom: 5px;
        }
        
        .meta-value {
            font-size: 14px;
            color: #333;
            font-weight: bold;
        }
        
        .order-status {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }
        
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-shipped {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        
        .order-items {
            padding: 20px;
        }
        
        .order-item {
            display: grid;
            grid-template-columns: 60px 1fr 100px 80px 100px;
            gap: 15px;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .item-icon {
            font-size: 36px;
            text-align: center;
        }
        
        .item-name {
            font-size: 14px;
            color: #333;
        }
        
        .item-price {
            color: #e74c3c;
            font-weight: bold;
        }
        
        .item-quantity {
            text-align: center;
            color: #666;
        }
        
        .item-subtotal {
            color: #e74c3c;
            font-weight: bold;
            text-align: right;
        }
        
        .order-total {
            padding: 20px;
            background-color: #f8f9fa;
            text-align: right;
            font-size: 18px;
            font-weight: bold;
            color: #e74c3c;
        }
        
        .empty-orders {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            font-size: 18px;
        }
        
        .empty-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="logo">📦 我的订单</div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/shop.jsp" class="header-btn primary">
                <span>🏠</span>
                <span>返回商城</span>
            </a>
            <a href="${pageContext.request.contextPath}/cart.jsp" class="header-btn">
                <span>🛒</span>
                <span>购物车</span>
            </a>
        </div>
    </header>
    
    <div class="container">
        <div class="order-header">
            <h2>订单列表</h2>
        </div>
        
        <div class="order-list" id="orderList">
            <!-- 订单会动态加载 -->
        </div>
    </div>
    
    <script>
        // 加载订单数据
        function loadOrders() {
            var contextPath = '${pageContext.request.contextPath}';
            fetch(contextPath + '/order?action=list')
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('加载失败');
                    }
                    return response.json();
                })
                .then(function(data) {
                    renderOrders(data);
                })
                .catch(function(error) {
                    console.error('加载订单失败:', error);
                    document.getElementById('orderList').innerHTML = 
                        '<div class="empty-orders">加载失败</div>';
                });
        }
        
        // 渲染订单列表
        function renderOrders(data) {
            var orderList = document.getElementById('orderList');
            
            if (!data.orders || data.orders.length === 0) {
                orderList.innerHTML = 
                    '<div class="empty-orders">' +
                    '<div class="empty-icon">📦</div>' +
                    '<div>暂无订单</div>' +
                    '</div>';
                return;
            }
            
            var html = '';
            for (var i = 0; i < data.orders.length; i++) {
                var order = data.orders[i];
                
                // 确定状态样式
                var statusClass = 'status-pending';
                if (order.status === '已发货') {
                    statusClass = 'status-shipped';
                } else if (order.status === '已完成') {
                    statusClass = 'status-completed';
                }
                
                html += '<div class="order-card">';
                html += '  <div class="order-info">';
                html += '    <div class="order-meta">';
                html += '      <div class="meta-item">';
                html += '        <span class="meta-label">订单号</span>';
                html += '        <span class="meta-value">' + order.orderId + '</span>';
                html += '      </div>';
                html += '      <div class="meta-item">';
                html += '        <span class="meta-label">下单时间</span>';
                html += '        <span class="meta-value">' + order.orderTime + '</span>';
                html += '      </div>';
                html += '      <div class="meta-item">';
                html += '        <span class="meta-label">商品数量</span>';
                html += '        <span class="meta-value">' + order.items.length + ' 件</span>';
                html += '      </div>';
                html += '    </div>';
                html += '    <div class="order-status ' + statusClass + '">' + order.status + '</div>';
                html += '  </div>';
                
                html += '  <div class="order-items">';
                for (var j = 0; j < order.items.length; j++) {
                    var item = order.items[j];
                    html += '    <div class="order-item">';
                    html += '      <div class="item-icon">' + item.icon + '</div>';
                    html += '      <div class="item-name">' + item.productName + '</div>';
                    html += '      <div class="item-price">¥' + item.price.toFixed(2) + '</div>';
                    html += '      <div class="item-quantity">x' + item.quantity + '</div>';
                    html += '      <div class="item-subtotal">¥' + item.subtotal + '</div>';
                    html += '    </div>';
                }
                html += '  </div>';
                
                html += '  <div class="order-total">';
                html += '    订单总额：¥' + order.totalAmount;
                html += '  </div>';
                html += '</div>';
            }
            
            orderList.innerHTML = html;
        }
        
        // 页面加载时加载订单
        window.onload = function() {
            loadOrders();
        };
    </script>
</body>
</html>
