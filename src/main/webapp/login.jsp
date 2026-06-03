<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="data:,">
    <title>用户登录</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: url('${pageContext.request.contextPath}/images/25815908_002835219086_2.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        /* 背景遮罩层，让表单更易阅读 */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(44, 62, 80, 0.45);
            z-index: 0;
        }
        
        .login-container {
            position: relative;
            z-index: 1;
            background-color: rgba(255, 255, 255, 0.97);
            padding: 40px 35px 30px;
            border-radius: 8px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
            width: 380px;
            transition: box-shadow 0.2s;
        }
        
        .login-container:hover {
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4);
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .login-header .logo-icon {
            font-size: 48px;
            margin-bottom: 10px;
        }
        
        h2 {
            text-align: center;
            color: #2c3e50;
            font-size: 24px;
            margin-bottom: 5px;
        }
        
        .login-subtitle {
            text-align: center;
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 18px;
        }
        
        label {
            display: block;
            margin-bottom: 6px;
            color: #2c3e50;
            font-size: 14px;
            font-weight: 600;
        }
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
            font-family: inherit;
            outline: none;
            transition: border-color 0.3s;
        }
        
        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #3498db;
        }
        
        .error-message {
            color: #e74c3c;
            background-color: #ffeaea;
            text-align: center;
            margin-bottom: 18px;
            padding: 10px 15px;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .success-message {
            color: #27ae60;
            background-color: #eafff1;
            text-align: center;
            margin-bottom: 18px;
            padding: 10px 15px;
            border-radius: 6px;
            font-size: 14px;
        }
        
        button {
            width: 100%;
            padding: 12px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-family: inherit;
            font-weight: 600;
            transition: background-color 0.2s;
            margin-top: 5px;
        }
        
        button:hover {
            background-color: #2980b9;
        }
        
        .toggle-link {
            text-align: center;
            margin-top: 20px;
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .toggle-link a {
            color: #3498db;
            text-decoration: none;
            cursor: pointer;
            font-weight: 600;
        }
        
        .toggle-link a:hover {
            color: #2980b9;
            text-decoration: underline;
        }
        
        .hidden {
            display: none;
        }
        
        .account-info {
            text-align: center;
            margin-top: 20px;
            padding-top: 18px;
            border-top: 1px solid #e0e0e0;
            color: #7f8c8d;
            font-size: 12px;
            line-height: 1.8;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="logo-icon">🛒</div>
        </div>
        <h2 id="formTitle">用户登录</h2>
        <p class="login-subtitle" id="formSubtitle">欢迎回来，请登录您的账号</p>
        
        <% 
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="error-message"><%= error %></div>
        <% 
            } 
        %>
        
        <% 
            String registerSuccess = request.getParameter("register");
            if ("success".equals(registerSuccess)) {
        %>
            <div class="success-message">注册成功！请登录</div>
        <% 
            } 
        %>
        
        <!-- 登录表单 -->
        <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="loginUsername">用户名:</label>
                <input type="text" id="loginUsername" name="username" required>
            </div>
            <div class="form-group">
                <label for="loginPassword">密码:</label>
                <input type="password" id="loginPassword" name="password" required>
            </div>
            <button type="submit">登录</button>
        </form>
        
        <!-- 注册表单 -->
        <form id="registerForm" class="hidden" action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="regUsername">用户名:</label>
                <input type="text" id="regUsername" name="username" required>
            </div>
            <div class="form-group">
                <label for="regPassword">密码:</label>
                <input type="password" id="regPassword" name="password" required>
            </div>
            <div class="form-group">
                <label for="regConfirmPassword">确认密码:</label>
                <input type="password" id="regConfirmPassword" name="confirmPassword" required>
            </div>
            <button type="submit">注册</button>
        </form>
        
        <div class="toggle-link">
            <span id="loginLink">还没有账号？<a onclick="showRegister()">立即注册</a></span>
            <span id="registerLink" class="hidden">已有账号？<a onclick="showLogin()">立即登录</a></span>
        </div>
        

    </div>
    
    <script>
        function showRegister() {
            document.getElementById('loginForm').classList.add('hidden');
            document.getElementById('registerForm').classList.remove('hidden');
            document.getElementById('formTitle').textContent = '用户注册';
            document.getElementById('formSubtitle').textContent = '创建新账号，开始您的购物之旅';
            document.getElementById('loginLink').classList.add('hidden');
            document.getElementById('registerLink').classList.remove('hidden');
            document.getElementById('accountInfo').classList.add('hidden');
        }
        
        function showLogin() {
            document.getElementById('loginForm').classList.remove('hidden');
            document.getElementById('registerForm').classList.add('hidden');
            document.getElementById('formTitle').textContent = '用户登录';
            document.getElementById('formSubtitle').textContent = '欢迎回来，请登录您的账号';
            document.getElementById('loginLink').classList.remove('hidden');
            document.getElementById('registerLink').classList.add('hidden');
            document.getElementById('accountInfo').classList.remove('hidden');
        }
        
        // 如果有注册相关错误，自动显示注册表单
        <% if ("true".equals(String.valueOf(request.getAttribute("showRegister")))) { %>
            showRegister();
        <% } %>
    </script>
</body>
</html>
