<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="data:,">
    <title>用户登录</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 300px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
        .success-message {
            color: #4CAF50;
            text-align: center;
            margin-bottom: 15px;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .toggle-link {
            text-align: center;
            margin-top: 15px;
            color: #666;
            font-size: 14px;
        }
        .toggle-link a {
            color: #4CAF50;
            text-decoration: none;
            cursor: pointer;
        }
        .toggle-link a:hover {
            text-decoration: underline;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2 id="formTitle">用户登录</h2>
        
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
        
        <p id="accountInfo" style="text-align: center; margin-top: 15px; color: #666; font-size: 12px;">
            客户账号: admin / 123456<br>
            管理员账号: admin2 / 123456
        </p>
    </div>
    
    <script>
        function showRegister() {
            document.getElementById('loginForm').classList.add('hidden');
            document.getElementById('registerForm').classList.remove('hidden');
            document.getElementById('formTitle').textContent = '用户注册';
            document.getElementById('loginLink').classList.add('hidden');
            document.getElementById('registerLink').classList.remove('hidden');
            document.getElementById('accountInfo').classList.add('hidden');
        }
        
        function showLogin() {
            document.getElementById('loginForm').classList.remove('hidden');
            document.getElementById('registerForm').classList.add('hidden');
            document.getElementById('formTitle').textContent = '用户登录';
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
