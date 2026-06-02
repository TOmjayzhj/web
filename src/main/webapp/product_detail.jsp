<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="data:,">
    <title>商品详情</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background-color: #e8e8e8;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .back-btn {
            display: inline-block;
            padding: 8px 16px;
            background: #f0f0f0;
            color: #333;
            text-decoration: none;
            border-radius: 4px;
            margin-bottom: 20px;
            font-weight: normal;
            transition: background-color 0.2s;
        }
        
        .back-btn:hover {
            background: #e0e0e0;
        }
        
        .product-card {
            background: white;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .product-header {
            display: flex;
            gap: 30px;
            align-items: center;
        }
        
        .product-icon {
            font-size: 80px;
            width: 120px;
            height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f5f5f5;
            border-radius: 8px;
        }
        
        .product-info h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 10px;
        }
        
        .product-info .price {
            font-size: 32px;
            color: #e74c3c;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .product-info .category {
            color: #666;
            font-size: 16px;
        }
        
        .rating-section {
            background: #f0f0f0;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .rating-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .rating-summary {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .avg-rating {
            font-size: 48px;
            font-weight: bold;
            color: #f39c12;
        }
        
        .stars {
            font-size: 24px;
            color: #f39c12;
        }
        
        .review-count {
            color: #666;
            font-size: 16px;
        }
        
        .reviews-list {
            margin-top: 20px;
        }
        
        .review-item {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #667eea;
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .review-username {
            font-weight: bold;
            color: #333;
        }
        
        .review-time {
            color: #999;
            font-size: 14px;
        }
        
        .review-rating {
            color: #f39c12;
            margin-bottom: 8px;
        }
        
        .review-content {
            color: #555;
            line-height: 1.6;
        }
        
        .no-reviews {
            text-align: center;
            padding: 40px;
            color: #999;
            font-size: 16px;
        }
        
        .review-form {
            background: #f0f0f0;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .review-form h3 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: bold;
        }
        
        .star-rating {
            display: flex;
            gap: 10px;
            font-size: 32px;
        }
        
        .star-rating input {
            display: none;
        }
        
        .star-rating label {
            cursor: pointer;
            color: #ddd;
            transition: color 0.2s;
        }
        
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #f39c12;
        }
        
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }
        
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .submit-btn {
            padding: 10px 30px;
            background: #666;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: normal;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .submit-btn:hover {
            background: #555;
        }
        
        .submit-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert-show {
            display: block;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="shop.jsp" class="back-btn">← 返回商城</a>
        
        <div class="product-card">
            <div class="product-header">
                <div class="product-icon" id="productIcon"></div>
                <div class="product-info">
                    <h1 id="productName"></h1>
                    <div class="price">¥<span id="productPrice"></span></div>
                    <div class="category">分类：<span id="productCategory"></span></div>
                </div>
            </div>
        </div>
        
        <div class="product-card">
            <h2 style="margin-bottom: 20px; color: #333;">商品评价</h2>
            
            <div id="alertBox" class="alert"></div>
            
            <div class="rating-section">
                <div class="rating-header">
                    <div class="rating-summary">
                        <div class="avg-rating" id="avgRating">--</div>
                        <div>
                            <div class="stars" id="avgStars"></div>
                            <div class="review-count" id="reviewCount">暂无评价</div>
                        </div>
                    </div>
                </div>
                
                <div class="reviews-list" id="reviewsList">
                    <div class="no-reviews">暂无评价，快来发表第一条评价吧！</div>
                </div>
            </div>
            
            <div class="review-form" id="reviewForm" style="display: none;">
                <h3>发表评价</h3>
                <p style="color: #666; margin-bottom: 15px; font-size: 14px;">购买后随时可以追加评价</p>
                <form id="addReviewForm">
                    <input type="hidden" id="productId" name="productId">
                    
                    <div class="form-group">
                        <label>评分</label>
                        <div class="star-rating">
                            <input type="radio" name="rating" value="5" id="star5" required>
                            <label for="star5">★</label>
                            <input type="radio" name="rating" value="4" id="star4">
                            <label for="star4">★</label>
                            <input type="radio" name="rating" value="3" id="star3">
                            <label for="star3">★</label>
                            <input type="radio" name="rating" value="2" id="star2">
                            <label for="star2">★</label>
                            <input type="radio" name="rating" value="1" id="star1">
                            <label for="star1">★</label>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="content">评价内容</label>
                        <textarea id="content" name="content" placeholder="分享您对该商品的使用感受..." required></textarea>
                    </div>
                    
                    <button type="submit" class="submit-btn">提交评价</button>
                </form>
            </div>
            
            <div id="cannotReview" style="display: none; text-align: center; padding: 20px; color: #999;">
                您还没有购买过该商品，无法评价
            </div>
        </div>
    </div>
    
    <script>
        // 获取URL参数
        function getUrlParameter(name) {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get(name);
        }
        
        // 加载商品信息
        function loadProduct() {
            const productId = getUrlParameter('id');
            if (!productId) {
                alert('商品ID不存在');
                window.location.href = 'shop.jsp';
                return;
            }
            
            // 从ProductServlet获取商品信息
            fetch('products?action=getDetail&productId=' + productId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const product = data.product;
                        document.getElementById('productIcon').textContent = product.icon || '📦';
                        document.getElementById('productName').textContent = product.name;
                        document.getElementById('productPrice').textContent = product.price.toFixed(2);
                        document.getElementById('productCategory').textContent = product.category;
                        document.getElementById('productId').value = product.id;
                    } else {
                        alert(data.message || '商品不存在');
                        window.location.href = 'shop.jsp';
                    }
                })
                .catch(error => {
                    console.error('加载商品失败:', error);
                    alert('加载商品失败');
                });
        }
        
        // 加载评价
        function loadReviews() {
            const productId = getUrlParameter('id');
            fetch('review?productId=' + productId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // 更新评分统计
                        document.getElementById('avgRating').textContent = data.avgRating > 0 ? data.avgRating.toFixed(1) : '--';
                        document.getElementById('avgStars').textContent = getStars(data.avgRating);
                        document.getElementById('reviewCount').textContent = data.reviewCount > 0 ? data.reviewCount + ' 条评价' : '暂无评价';
                        
                        // 显示评价列表
                        const reviewsList = document.getElementById('reviewsList');
                        if (data.reviews && data.reviews.length > 0) {
                            var html = '';
                            for (var i = 0; i < data.reviews.length; i++) {
                                var review = data.reviews[i];
                                html += '<div class="review-item">';
                                html += '  <div class="review-header">';
                                html += '    <span class="review-username">' + escapeHtml(review.username) + '</span>';
                                html += '    <span class="review-time">' + formatTime(review.reviewTime) + '</span>';
                                html += '  </div>';
                                html += '  <div class="review-rating">' + getStars(review.rating) + '</div>';
                                html += '  <div class="review-content">' + escapeHtml(review.content) + '</div>';
                                html += '</div>';
                            }
                            reviewsList.innerHTML = html;
                        }
                        
                        // 控制评价表单显示
                        if (data.canReview) {
                            document.getElementById('reviewForm').style.display = 'block';
                            document.getElementById('cannotReview').style.display = 'none';
                        } else {
                            document.getElementById('reviewForm').style.display = 'none';
                            document.getElementById('cannotReview').style.display = 'block';
                        }
                    }
                })
                .catch(error => console.error('加载评价失败:', error));
        }
        
        // 提交评价
        document.getElementById('addReviewForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 直接从 URL 获取商品ID
            const productId = getUrlParameter('id');
            console.log('=== 开始提交评价 ===');
            console.log('URL中的商品ID:', productId);
            
            if (!productId) {
                showAlert('商品ID不存在', false);
                return;
            }
            
            // 获取表单数据
            const rating = document.querySelector('input[name="rating"]:checked');
            const content = document.getElementById('content').value;
            
            console.log('评分:', rating ? rating.value : '未选择');
            console.log('评价内容:', content);
            
            if (!rating) {
                showAlert('请选择评分', false);
                return;
            }
            
            if (!content || content.trim() === '') {
                showAlert('请输入评价内容', false);
                return;
            }
            
            // 构建请求数据
            const params = new URLSearchParams();
            params.append('productId', productId);
            params.append('rating', rating.value);
            params.append('content', content.trim());
            
            console.log('发送的数据:', params.toString());
            
            fetch('review', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                console.log('后端返回:', data);
                showAlert(data.message, data.success);
                if (data.success) {
                    // 刷新评价列表
                    setTimeout(() => {
                        loadReviews();
                        this.reset();
                    }, 1000);
                }
            })
            .catch(error => {
                console.error('提交失败:', error);
                showAlert('提交失败，请重试', false);
            });
        });
        
        // 显示提示信息
        function showAlert(message, success) {
            const alertBox = document.getElementById('alertBox');
            alertBox.textContent = message;
            alertBox.className = 'alert alert-show ' + (success ? 'alert-success' : 'alert-error');
            setTimeout(() => {
                alertBox.className = 'alert';
            }, 3000);
        }
        
        // 生成星星
        function getStars(rating) {
            const fullStars = Math.floor(rating);
            const emptyStars = 5 - fullStars;
            return '★'.repeat(fullStars) + '☆'.repeat(emptyStars);
        }
        
        // 格式化时间
        function formatTime(timeStr) {
            const date = new Date(timeStr);
            return date.toLocaleString('zh-CN');
        }
        
        // HTML转义
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        // 页面加载时执行
        loadProduct();
        loadReviews();
    </script>
</body>
</html>
