<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 防护：禁止直接访问 login.jsp，必须通过 /login Servlet 统一入口
    if (request.getAttribute("jakarta.servlet.forward.servlet_path") == null
        && request.getAttribute("jakarta.servlet.include.servlet_path") == null) {
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <title>用户登录</title>
    <style>
        /* 登录页特有样式 - 全屏背景 */
        body {
            background: url('${pageContext.request.contextPath}/images/25815908_002835219086_2.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background-color: rgba(30, 41, 59, 0.45);
            z-index: 0;
        }
        .login-container {
            position: relative;
            z-index: 1;
            background-color: rgba(255, 255, 255, 0.97);
            padding: 36px 32px 28px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
            width: 380px;
            transition: box-shadow 0.2s;
        }
        .login-container:hover {
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.3);
        }
        .login-header { text-align: center; margin-bottom: 24px; }
        .login-header .logo-icon { font-size: 42px; margin-bottom: 8px; }
        h2 { text-align: center; color: #2d3436; font-size: 22px; margin-bottom: 4px; font-weight: 600; }
        .login-subtitle { text-align: center; color: #636e72; font-size: 13px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 5px; color: #2d3436; font-size: 13px; font-weight: 600; }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #4a90d9;
            box-shadow: 0 0 0 3px rgba(74,144,217,0.1);
        }
        .error-message {
            color: #e74c3c;
            background-color: #fef2f2;
            text-align: center;
            margin-bottom: 14px;
            padding: 9px 14px;
            border-radius: 8px;
            font-size: 13px;
        }
        .success-message {
            color: #27ae60;
            background-color: #f0fdf4;
            text-align: center;
            margin-bottom: 14px;
            padding: 9px 14px;
            border-radius: 8px;
            font-size: 13px;
        }
        button {
            width: 100%;
            padding: 11px;
            background-color: #4a90d9;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-family: inherit;
            font-weight: 600;
            transition: background-color 0.15s;
            margin-top: 4px;
        }
        button:hover { background-color: #357abd; }
        .toggle-link { text-align: center; margin-top: 18px; color: #636e72; font-size: 13px; }
        .toggle-link a { color: #4a90d9; text-decoration: none; cursor: pointer; font-weight: 600; }
        .toggle-link a:hover { color: #357abd; text-decoration: underline; }
        .hidden { display: none; }
        .account-info {
            text-align: center;
            margin-top: 18px;
            padding-top: 16px;
            border-top: 1px solid #f1f2f6;
            color: #636e72;
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
            var accountInfo = document.getElementById('accountInfo');
            if (accountInfo) accountInfo.classList.add('hidden');
        }
        
        function showLogin() {
            document.getElementById('loginForm').classList.remove('hidden');
            document.getElementById('registerForm').classList.add('hidden');
            document.getElementById('formTitle').textContent = '用户登录';
            document.getElementById('formSubtitle').textContent = '欢迎回来，请登录您的账号';
            document.getElementById('loginLink').classList.remove('hidden');
            document.getElementById('registerLink').classList.add('hidden');
            var accountInfo = document.getElementById('accountInfo');
            if (accountInfo) accountInfo.classList.remove('hidden');
        }
        
        // 如果有注册相关错误，自动显示注册表单
        <% if ("true".equals(String.valueOf(request.getAttribute("showRegister")))) { %>
            showRegister();
        <% } %>
    </script>
</body>
</html>
