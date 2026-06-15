<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="data:,">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <title>商品详情</title>
    <style>
        body { min-height: 100vh; padding: 20px; }
        .container { display: block; max-width: 1000px; margin: 0 auto; }
        .back-btn {
            display: inline-block;
            padding: 9px 18px;
            background-color: #27ae60;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
            font-size: 13px;
            transition: all 0.15s;
        }
        .back-btn:hover {
            background-color: #219a52;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }
        .product-card {
            background: white;
            padding: 28px;
            border-radius: 10px;
            margin-bottom: 18px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
            transition: box-shadow 0.2s;
        }
        .product-card:hover {
            box-shadow: 0 4px 14px rgba(0,0,0,0.09);
        }
        .product-header { display: flex; gap: 28px; align-items: center; }
        .product-icon {
            font-size: 64px;
            width: 110px; height: 110px;
            display: flex; align-items: center; justify-content: center;
            background: #f8fafc;
            border-radius: 10px;
            border: 1px solid #f1f2f6;
        }
        .product-info h1 { font-size: 24px; color: #2d3436; margin-bottom: 10px; font-weight: 600; }
        .product-info .price { font-size: 28px; color: #e74c3c; font-weight: 700; margin-bottom: 10px; }
        .product-info .category { color: #636e72; font-size: 14px; }
        .rating-section {
            background: #f8fafc;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 18px;
            border: 1px solid #f1f2f6;
        }
        .rating-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }
        .rating-summary { display: flex; align-items: center; gap: 14px; }
        .avg-rating { font-size: 42px; font-weight: 700; color: #f39c12; }
        .stars { font-size: 22px; color: #f39c12; }
        .review-count { color: #636e72; font-size: 14px; }
        .reviews-list { margin-top: 18px; }
        .review-item {
            background: white;
            padding: 18px;
            border-radius: 8px;
            margin-bottom: 12px;
            border-left: 3px solid #4a90d9;
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        .review-username { font-weight: 600; color: #2d3436; font-size: 13px; }
        .review-time { color: #b2bec3; font-size: 12px; }
        .review-rating { color: #f39c12; margin-bottom: 6px; font-size: 14px; }
        .review-content { color: #636e72; line-height: 1.6; font-size: 13px; }
        .no-reviews { text-align: center; padding: 36px; color: #b2bec3; font-size: 14px; }
        .review-form {
            background: #f8fafc;
            padding: 20px;
            border-radius: 10px;
            margin-top: 18px;
            border: 1px solid #f1f2f6;
        }
        .review-form h3 { margin-bottom: 16px; color: #2d3436; font-size: 16px; font-weight: 600; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 6px; color: #636e72; font-weight: 500; font-size: 13px; }
        .star-rating { display: flex; gap: 8px; font-size: 28px; }
        .star-rating input { display: none; }
        .star-rating label { cursor: pointer; color: #dfe4ea; transition: color 0.15s, transform 0.15s; }
        .star-rating label:hover {
            color: #f39c12;
            transform: scale(1.15);
        }
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label { color: #f39c12; }
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
            outline: none;
            transition: border-color 0.2s;
        }
        .form-group textarea:focus { border-color: #4a90d9; }
        .submit-btn {
            padding: 9px 24px;
            background: #4a90d9;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.15s, transform 0.1s;
        }
        .submit-btn:hover { background: #357abd; }
        .submit-btn:active { background: #2c6aa0; transform: scale(0.97); }
        .submit-btn:disabled { background: #b2bec3; cursor: not-allowed; }
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            display: none;
            font-size: 14px;
            font-weight: 500;
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
        .alert-show { display: block; }
    </style>
</head>
<body>
    <div id="toast" class="toast"></div>
    
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
            <h2 style="margin-bottom: 20px; color: #2d3436; font-size: 18px; font-weight: 600;">商品评价</h2>
            
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
                <p style="color: #888; margin-bottom: 15px; font-size: 13px;">购买后随时可以追加评价</p>
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
        function getUrlParameter(name) {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get(name);
        }

        function loadProduct() {
            const productId = getUrlParameter('id');
            if (!productId) {
                window.location.href = 'shop.jsp';
                return;
            }
            
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
                        window.location.href = 'shop.jsp';
                    }
                })
                .catch(error => {
                    console.error('加载商品失败:', error);
                    showToast('加载商品失败', 'error');
                });
        }

        function loadReviews() {
            const productId = getUrlParameter('id');
            fetch('review?productId=' + productId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById('avgRating').textContent = data.avgRating > 0 ? data.avgRating.toFixed(1) : '--';
                        document.getElementById('avgStars').textContent = getStars(data.avgRating);
                        document.getElementById('reviewCount').textContent = data.reviewCount > 0 ? data.reviewCount + ' 条评价' : '暂无评价';

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

        document.getElementById('addReviewForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const productId = getUrlParameter('id');
            
            if (!productId) {
                showAlert('商品ID不存在', false);
                return;
            }

            const rating = document.querySelector('input[name="rating"]:checked');
            const content = document.getElementById('content').value;
            
            if (!rating) {
                showAlert('请选择评分', false);
                return;
            }
            
            if (!content || content.trim() === '') {
                showAlert('请输入评价内容', false);
                return;
            }

            const params = new URLSearchParams();
            params.append('productId', productId);
            params.append('rating', rating.value);
            params.append('content', content.trim());
            
            fetch('review', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                showAlert(data.message, data.success);
                if (data.success) {
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

        function showAlert(message, success) {
            const alertBox = document.getElementById('alertBox');
            alertBox.textContent = message;
            alertBox.className = 'alert alert-show ' + (success ? 'alert-success' : 'alert-error');
            setTimeout(() => {
                alertBox.className = 'alert';
            }, 3000);
        }

        function getStars(rating) {
            const fullStars = Math.floor(rating);
            const emptyStars = 5 - fullStars;
            return '★'.repeat(fullStars) + '☆'.repeat(emptyStars);
        }

        function formatTime(timeStr) {
            const date = new Date(timeStr);
            return date.toLocaleString('zh-CN');
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function showToast(message, type) {
            type = type || 'success';
            var toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast ' + type;
            setTimeout(function() { toast.classList.add('show'); }, 10);
            setTimeout(function() { toast.classList.remove('show'); }, 2000);
        }

        loadProduct();
        loadReviews();
    </script>
</body>
</html>
