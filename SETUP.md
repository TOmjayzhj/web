# 电商系统 - 快速启动指南

## 📋 环境要求

- **JDK**: Java 11 或更高版本（推荐 Java 21）
- **IDE**: IntelliJ IDEA 专业版
- **数据库**: MySQL 5.7 或更高版本
- **服务器**: Apache Tomcat 10.1.x（通过 SmartTomcat 插件）

## 🚀 一键启动步骤

### 1️⃣ 准备MySQL数据库

确保MySQL服务已启动，并确认以下信息：
- **用户名**: `root`
- **密码**: `123456`（如果不是，需要修改代码）

#### 如果MySQL密码不是123456

修改以下文件中的密码：

**文件1**: `src/main/java/common/example/util/DBUtil.java`
```java
private static final String PASSWORD = "你的密码"; // 第16行
```

**文件2**: `src/main/java/common/example/servlet/DatabaseInitServlet.java`
```java
private static final String PASSWORD = "你的密码"; // 第22行
```

### 2️⃣ 在IDEA中配置项目

1. **打开项目**
   - File → Open → 选择项目文件夹

2. **配置MySQL驱动**
   - 确保 `lib/mysql-connector-j-8.0.33.jar` 已存在
   - File → Project Structure → Libraries
   - 添加 `lib/mysql-connector-j-8.0.33.jar`

3. **配置SmartTomcat**
   - Run → Edit Configurations
   - 点击 `+` → 选择 `Smart Tomcat`
   - 配置项：
     - **Name**: `Tomcat`
     - **Tomcat Server**: 选择你的Tomcat路径
     - **Deployment Directory**: 选择 `src/main/webapp`
     - **Context Path**: `/shop`（或你喜欢的路径）
     - **Server Port**: `8080`

4. **保存配置并启动**
   - 点击 Run 按钮

### 3️⃣ 自动初始化（自动完成）

项目启动时，`DatabaseInitServlet` 会自动执行：

```
========================================
[DatabaseInit] 开始初始化数据库...
========================================
[DatabaseInit] MySQL驱动加载成功
[DatabaseInit] 步骤1: 创建数据库 ecommerce_db...
[DatabaseInit] ✓ 数据库创建成功
[DatabaseInit] 步骤2: 创建数据表...
  ✓ 创建 users 表
  ✓ 创建 products 表
  ✓ 创建 cart 表
  ✓ 创建 orders 表
  ✓ 创建 order_items 表
  ✓ 创建 product_reviews 表
[DatabaseInit] ✓ 数据表创建成功
[DatabaseInit] 步骤3: 插入初始数据...
  插入用户数据...
  ✓ 插入 2 个用户
  插入商品数据...
  ✓ 插入 30 个商品
[DatabaseInit] ✓ 初始数据插入成功
[DatabaseInit] 步骤4: 验证数据...
  用户总数: 2
  商品总数: 30
========================================
[DatabaseInit] ✅ 数据库初始化完成！
========================================
```

### 4️⃣ 访问系统

启动成功后，访问：
```
http://localhost:8080/shop/
```

系统会自动跳转到登录页面。

## 👥 测试账号

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| admin | 123456 | 普通用户 | 可以购物、下单、评价 |
| admin2 | 123456 | 管理员 | 可以管理商品、订单、评价 |

## 📁 项目结构

```
untitled2/
├── src/main/
│   ├── java/common/example/
│   │   ├── dao/              # 数据访问层
│   │   ├── model/            # 数据模型
│   │   ├── servlet/          # 控制器
│   │   │   └── DatabaseInitServlet.java  # ⭐ 自动初始化
│   │   └── util/
│   │       └── DBUtil.java   # 数据库工具
│   └── webapp/
│       ├── WEB-INF/
│       │   └── web.xml       # ⭐ 配置文件
│       ├── login.jsp         # 登录页面
│       ├── shop.jsp          # 商城主页
│       ├── cart.jsp          # 购物车
│       ├── order.jsp         # 订单页
│       ├── product_detail.jsp # 商品详情
│       └── admin.jsp         # 管理后台
├── lib/
│   └── mysql-connector-j-8.0.33.jar
└── init_database.sql         # 手动初始化脚本（备用）
```

## 🔧 常见问题

### Q1: 数据库连接失败
**错误信息**: `Communications link failure`

**解决方案**:
1. 检查MySQL服务是否启动
2. 确认密码是否为 `123456`
3. 修改 `DBUtil.java` 和 `DatabaseInitServlet.java` 中的密码

### Q2: 端口8080被占用
**错误信息**: `Address already in use`

**解决方案**:
- 修改SmartTomcat配置中的端口（如改为8081）
- 或关闭占用8080端口的程序

### Q3: 找不到MySQL驱动
**错误信息**: `ClassNotFoundException: com.mysql.cj.jdbc.Driver`

**解决方案**:
1. File → Project Structure → Libraries
2. 添加 `lib/mysql-connector-j-8.0.33.jar`
3. 重新构建项目

### Q4: 中文乱码
**解决方案**:
- 确保MySQL使用 `utf8mb4` 字符集
- 确保IDEA文件编码为 `UTF-8`

## 📝 手动初始化数据库（可选）

如果自动初始化失败，可以手动执行SQL脚本：

```bash
mysql -u root -p123456 < init_database.sql
```

或在MySQL命令行中：
```sql
source D:/学习资料/web应用开发/untitled2/init_database.sql
```

## 🎯 功能清单

- ✅ 用户注册/登录
- ✅ 商品浏览（按分类）
- ✅ 商品搜索
- ✅ 购物车管理
- ✅ 订单管理
- ✅ 商品评价（支持追加评价）
- ✅ 管理员后台
- ✅ 自动数据库初始化

## 💡 提示

- 首次启动时，初始化过程可能需要几秒钟
- 控制台会显示详细的初始化日志
- 如果数据库已存在，不会重复插入数据
- 所有密码都是明文存储，仅用于学习目的

---

**祝你使用愉快！** 🎉
