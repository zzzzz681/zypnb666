# AI 简历分析与优化系统

本项目为前后端分离的全栈工程，包含：
- 用户前台（Vue3 + Vite + Element Plus）
- 管理后台（Vue3 + Vite + Element Plus）
- 后端服务（Spring Boot + MyBatis-Plus + MySQL）
- 数据库脚本、接口文档、部署文档

## 目录结构
```text
frontend/
  user-portal/
  admin-portal/
backend/
  resume-service/
database/
docs/
```

## 快速开始
### 用户前台
```bash
cd frontend/user-portal
npm install
npm run dev
```

### 管理后台
```bash
cd frontend/admin-portal
npm install
npm run dev
```

### 后端服务
```bash
cd backend/resume-service
mvn spring-boot:run
```
默认端口为 `8081`，如需修改可设置环境变量 `SERVER_PORT`。

### 数据库
先执行：
```bash
mysql -uroot -p aijianli < database/schema.sql
mysql -uroot -p aijianli < database/init-data.sql
```

## 文档入口
- [部署文档](docs/deploy.md)
- [接口文档](docs/api.md)
