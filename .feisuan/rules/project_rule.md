
# 开发规范指南

为保证代码质量、可维护性、安全性与可扩展性，请在开发过程中严格遵循以下规范。

## 一、项目基础信息

- **作者**：94293
- **工作目录**：`D:\学习资料\web应用开发\untitled2`
- **操作系统**：Windows 11
- **当前时间**：2026-06-06 10:55:29
- **构建工具**：Maven
- **SDK 版本**：JDK 21.0.5
- **项目类型**：Java Web (Servlet/JSP 传统架构)

## 二、目录结构规范

项目遵循标准的 Maven 目录结构，具体层级如下：

```text
untitled2
├── .smarttomcat          # IDE 运行配置目录 (无需提交至版本控制)
├── lib                   # 第三方依赖库本地存放 (可选，推荐由 Maven 管理)
└── src
    └── main
        ├── java
        │   └── common
        │       └── example
        │           ├── dao       # 数据访问层 (DAO)
        │           ├── filter    # 过滤器 (Filter)
        │           ├── model     # 实体模型 (Model/Entity)
        │           ├── servlet   # 控制层 (Servlet)
        │           └── util      # 工具类 (Utils)
        └── webapp
            ├── css               # 静态资源：样式表
            ├── images            # 静态资源：图片
            └── WEB-INF
                └── lib           # WEB-INF 下的库目录 (如需手动加载 jar)
```

### 包结构约束

- **根包名**：统一使用 `common.example`
- **分层映射**：
  - `servlet` 包：存放 `HttpServlet` 实现类，负责请求分发。
  - `dao` 包：存放数据访问接口及实现，直接操作数据库。
  - `model` 包：存放与数据库表映射的实体类 (POJO/Entity)。
  - `filter` 包：存放 `javax.servlet.Filter` 实现，用于拦截请求（如登录校验、编码设置）。
  - `util` 包：存放静态工具方法类。

## 三、技术栈与依赖规范

- **JDK 版本**：必须使用 **JDK 21.0.5** 或更高版本进行编译和运行。
- **构建工具**：使用 **Maven** 进行依赖管理和项目构建。
- **核心依赖**：
  - `javax.servlet-api` (或 `jakarta.servlet-api`，视 Servlet 规范版本而定，JDK 21 通常搭配较新版本)
  - `mysql-connector-j` (或其他数据库驱动)
  - `junit` (用于单元测试)

> **注意**：由于项目为传统 Java Web 架构，请确保 `pom.xml` 中正确配置了 `<packaging>war</packaging>` 以及 Servlet API 的作用域为 `provided`。

## 四、分层架构与职责规范

| 层级        | 职责说明                         | 开发约束与注意事项                                               |
|-------------|----------------------------------|----------------------------------------------------------------|
| **Servlet**  | 处理 HTTP 请求与响应，定义 API 接口 | 保持逻辑轻量，仅负责参数解析和调用 Service/DAO；禁止直接编写 SQL |
| **DAO**      | 数据库访问与持久化操作             | 封装 JDBC 操作或 ORM 框架调用；返回 `List<Model>` 或单个 `Model` |
| **Model**    | 映射数据库表结构                   | 必须实现 `Serializable` 接口；包含标准的 getter/setter         |
| **Filter**   | 请求预处理与后处理                 | 用于统一字符编码、权限校验、日志记录等横切关注点               |
| **Util**     | 通用工具方法                     | 类名以 `Utils` 结尾；所有方法应为 `static`，无状态             |

### 接口与实现分离

- **DAO 层**：建议定义 `IXxxDao` 接口，实现类命名为 `XxxDaoImpl`，存放在 `dao` 包下。
- **Servlet 层**：每个业务模块可对应一个 Servlet，或通过统一控制器分发。

## 五、安全与性能规范

### 输入校验与安全

- **SQL 注入防范**：在 `dao` 层执行数据库操作时，**必须**使用 `PreparedStatement` 预编译语句，严禁手动拼接 SQL 字符串。
- **XSS 防范**：在 `servlet` 输出数据到 JSP/HTML 前，对特殊字符进行转义或使用安全库过滤。
- **敏感信息**：密码、密钥等敏感信息不得硬编码在代码中，应通过配置文件或环境变量读取。

### 事务管理

- 在 `dao` 层实现类中管理数据库连接和事务。
- 多个 DAO 操作涉及事务一致性时，应在 Service 层或 Servlet 层统一控制事务提交/回滚。

### 资源管理

- 确保 JDBC 连接、Statement、ResultSet 在 `finally` 块或 try-with-resources 语句中正确关闭，防止资源泄漏。

## 六、代码风格规范

### 命名规范

| 类型       | 命名方式             | 示例                  |
|------------|----------------------|-----------------------|
| 类名       | UpperCamelCase       | `UserDaoImpl`, `LoginServlet` |
| 方法/变量  | lowerCamelCase       | `findById()`, `userName` |
| 常量       | UPPER_SNAKE_CASE     | `MAX_RETRY_COUNT`     |
| 包名       | 全小写               | `common.example.dao`  |

### 注释规范

- **第一语言**：所有代码注释必须使用 **中文**。
- **Javadoc**：所有公共类、公共方法必须添加标准的 Javadoc 注释，说明功能、参数、返回值及异常。
- **行内注释**：复杂逻辑需添加单行注释解释意图。

### 实体类规范

- `model` 包下的类应包含：
  - 私有字段 (private fields)
  - 公共 getter 和 setter 方法
  - `toString()` 方法 (便于调试)
  - `equals()` 和 `hashCode()` 方法 (基于业务主键)

## 七、扩展性与日志规范

### 日志记录

- 推荐使用 `java.util.logging` 或 `SLF4J + Logback` (若引入依赖)。
- 禁止使用 `System.out.println` 进行调试或生产日志输出。
- 日志级别使用规范：
  - `INFO`：关键业务流程节点
  - `WARN`：潜在风险或异常但不影响主流程
  - `ERROR`：严重错误，需立即处理

### 接口优先原则

- 尽量通过接口定义 DAO 和 Service，便于后续替换实现或进行单元测试 Mock。

## 八、编码原则总结

| 原则       | 说明                                       |
|------------|--------------------------------------------|
| **SOLID**  | 高内聚、低耦合，增强可维护性与可扩展性     |
| **DRY**    | 避免重复代码，提高复用性                   |
| **KISS**   | 保持代码简洁易懂，避免过度设计             |
| **YAGNI**  | 不实现当前不需要的功能                     |
| **OWASP**  | 防范常见安全漏洞，如 SQL 注入、XSS 等      |
