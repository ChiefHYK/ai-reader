# AI听书App

一个基于AI大模型的智能听书应用，支持多种文本格式，提供个性化语音合成和学习计划管理功能。

## 功能特点

- 支持多种文本格式(PDF, EPUB, TXT, RSS)
- AI语音合成朗读
- 自定义学习计划
- 课程进度管理
- 跨平台支持(iOS/Android)

## 环境要求

- Flutter 3.x
- Node.js 16+
- MongoDB 4.4+
- Docker (可选)

## 快速开始

### 安装依赖

1. 克隆项目
   ```bash
   git clone https://github.com/ChiefHYK/ai-reader.git
   cd AI-READER
   ```

2. 安装前端依赖
   ```bash
   cd frontend
   flutter pub get
   ```

3. 安装后端依赖
   ```bash
   cd backend
   npm install
   ```

### 配置环境变量

1. 后端配置
   ```bash
   cp backend/.env.example backend/.env
   ```
   编辑 `.env` 文件:
   ```
   MONGODB_URI=mongodb://localhost:27017/aireading
   JWT_SECRET=your_jwt_secret
   AI_API_KEY=your_ai_api_key
   ```

### 运行项目

1. 启动后端服务
   ```bash
   cd backend
   npm run dev
   ```

2. 运行前端应用
   ```bash
   cd frontend
   flutter run
   ```

## 开发指南

### 目录结构

请参考 design.md 文件了解详细的项目结构。

### 代码规范

前端遵循 Flutter 官方代码规范
后端使用 ESLint + Prettier
提交信息遵循 Conventional Commits 规范

## 测试

### 运行测试

1. 前端测试
   ```bash
   cd frontend
   flutter test
   ```

2. 后端测试
   ```bash
   cd backend
   npm run test
   ```

## 部署

### Docker部署

1. 构建镜像
   ```bash
   docker-compose build
   ```

2. 启动服务
   ```bash
   docker-compose up -d
   ```

3. 访问应用
   ```
   http://localhost:3000
   ```

## 贡献指南

1. Fork 项目
2. 创建特性分支
3. 提交改动
4. 推送到分支
5. 创建 Pull Request

## 许可证

MIT License

## 联系方式

项目负责人: ChiefHYK
Email: ChiefHYK@163.com
