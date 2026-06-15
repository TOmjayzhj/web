<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <title>我的订单</title>
    <style>
        .container {
            display: block;
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .header-actions { display: flex; gap: 10px; }
        .header-btn {
            padding: 9px 18px;
            background-color: #4a90d9;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.15s;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .header-btn:hover {
            background-color: #357abd;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }
        .header-btn.primary { background-color: #27ae60; }
        .header-btn.primary:hover { background-color: #219a52; }
        .order-header {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
        }
        .order-header h2 { color: #2d3436; font-size: 22px; font-weight: 600; }
        .order-tabs {
            display: flex;
            gap: 0;
            background: white;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
            overflow: hidden;
        }
        .order-tab {
            flex: 1;
            padding: 13px 10px;
            text-align: center;
            font-size: 14px;
            color: #636e72;
            cursor: pointer;
            transition: all 0.15s;
            border-bottom: 2px solid transparent;
            background: none;
            border-top: none;
            border-left: none;
            border-right: none;
            font-weight: 500;
        }
        .order-tab:hover {
            background-color: #f8fafc;
            color: #2d3436;
        }
        .order-tab.active {
            color: #4a90d9;
            border-bottom-color: #4a90d9;
            background-color: #f8fafc;
        }
        .order-list { display: flex; flex-direction: column; gap: 16px; }
        .order-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
            overflow: hidden;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .order-card:hover {
            box-shadow: 0 4px 14px rgba(0,0,0,0.09);
            transform: translateY(-2px);
        }
        .order-info {
            padding: 18px 20px;
            background-color: #f8fafc;
            border-bottom: 1px solid #f1f2f6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .order-meta { display: flex; gap: 28px; }
        .meta-item { display: flex; flex-direction: column; }
        .meta-label { font-size: 12px; color: #b2bec3; margin-bottom: 4px; }
        .meta-value { font-size: 14px; color: #2d3436; font-weight: 600; }
        .order-status {
            padding: 6px 14px;
            border-radius: 16px;
            font-size: 13px;
            font-weight: 600;
        }
        .status-unpaid { background-color: #fff3cd; color: #856404; }
        .status-pending { background-color: #fef3cd; color: #856404; }
        .status-shipped { background-color: #d1ecf1; color: #0c5460; }
        .status-received { background-color: #cce5ff; color: #004085; }
        .status-completed { background-color: #d4edda; color: #155724; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
        .order-items { padding: 18px 20px; }
        .order-item {
            display: grid;
            grid-template-columns: 60px 1fr 100px 80px 100px;
            gap: 14px;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f1f2f6;
        }
        .order-item:last-child { border-bottom: none; }
        .item-icon { font-size: 32px; text-align: center; }
        .item-name { font-size: 14px; color: #2d3436; }
        .item-price { color: #e74c3c; font-weight: 600; }
        .item-quantity { text-align: center; color: #636e72; }
        .item-subtotal { color: #e74c3c; font-weight: 600; text-align: right; }
        .order-footer {
            padding: 14px 20px;
            background-color: #f8fafc;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .order-total {
            font-size: 17px;
            font-weight: 700;
            color: #e74c3c;
        }
        .cancel-order-btn {
            padding: 7px 16px;
            background-color: #e74c3c;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            transition: opacity 0.15s;
        }
        .cancel-order-btn:hover { opacity: 0.85; }
        .empty-orders { text-align: center; padding: 60px 20px; color: #b2bec3; font-size: 16px; }
        .empty-icon { font-size: 64px; margin-bottom: 16px; opacity: 0.6; }
    </style>
</head>
<body>
    <div id="toast" class="toast"></div>
    <header class="header">
        <div class="logo">我的订单</div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/shop.jsp" class="header-btn primary">
                <span>返回商城</span>
            </a>
            <a href="${pageContext.request.contextPath}/cart.jsp" class="header-btn">
                <span>购物车</span>
            </a>
        </div>
    </header>
    
    <div class="container">
        <div class="order-header">
            <h2>订单列表</h2>
        </div>
        
        <div class="order-tabs">
            <button class="order-tab active" data-status="all">全部订单</button>
            <button class="order-tab" data-status="待发货">待发货</button>
            <button class="order-tab" data-status="已发货">待收货</button>
            <button class="order-tab" data-status="已完成">已完成</button>
        </div>
        
        <div class="order-list" id="orderList">
        </div>
    </div>
    
    <script>
        var currentStatus = 'all';
        var allOrdersCache = [];

        function showToast(message, type) {
            type = type || 'success';
            var toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast ' + type;
            setTimeout(function() { toast.classList.add('show'); }, 10);
            setTimeout(function() { toast.classList.remove('show'); }, 2000);
        }

        function loadOrders(status) {
            currentStatus = status || 'all';
            var contextPath = '${pageContext.request.contextPath}';
            var url = contextPath + '/order?action=list';
            if (currentStatus !== 'all') {
                url += '&status=' + encodeURIComponent(currentStatus);
            }
            fetch(url)
                .then(function(response) {
                    if (!response.ok) throw new Error('加载失败');
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

        function getStatusLabel(status) {
            var map = {
                '待付款': '待付款',
                '待发货': '待发货',
                '已发货': '待收货',
                '已收货': '已收货',
                '已完成': '已完成',
                '已取消': '已取消',
                '已退款': '已退款',
                '已关闭': '已关闭'
            };
            return map[status] || status;
        }

        function getStatusClass(status) {
            var map = {
                '待付款': 'status-unpaid',
                '待发货': 'status-pending',
                '已发货': 'status-shipped',
                '已收货': 'status-received',
                '已完成': 'status-completed',
                '已取消': 'status-cancelled',
                '已退款': 'status-cancelled',
                '已关闭': 'status-cancelled'
            };
            return map[status] || 'status-pending';
        }

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
                var statusClass = getStatusClass(order.status);
                var statusLabel = getStatusLabel(order.status);
                
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
                html += '    <div class="order-status ' + statusClass + '">' + statusLabel + '</div>';
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
                
                html += '  <div class="order-footer">';
                html += '    <div class="order-total">订单总额：¥' + order.totalAmount + '</div>';
                if (order.status === '待付款' || order.status === '待发货') {
                    html += '    <button class="cancel-order-btn" onclick="cancelOrder(\'' + order.orderId + '\')">取消订单</button>';
                }
                html += '  </div>';
                html += '</div>';
            }
            
            orderList.innerHTML = html;
        }

        function cancelOrder(orderId) {
            if (!confirm('确定要取消该订单吗？')) return;
            
            var contextPath = '${pageContext.request.contextPath}';
            var params = new URLSearchParams();
            params.append('action', 'cancel');
            params.append('orderId', orderId);
            
            fetch(contextPath + '/order', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    showToast(data.message, 'success');
                    loadOrders(currentStatus);
                } else {
                    showToast(data.error || '取消失败', 'error');
                }
            })
            .catch(function(error) {
                console.error('取消订单失败:', error);
                showToast('取消订单失败', 'error');
            });
        }

        // tab切换
        document.querySelectorAll('.order-tab').forEach(function(tab) {
            tab.addEventListener('click', function() {
                document.querySelectorAll('.order-tab').forEach(function(t) {
                    t.classList.remove('active');
                });
                this.classList.add('active');
                var status = this.getAttribute('data-status');
                loadOrders(status);
            });
        });

        window.onload = function() {
            loadOrders('all');
        };
    </script>
</body>
</html>
