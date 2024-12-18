
“”“
基于您的需求,我推荐以下技术方案:
前端技术栈:
Flutter + GetX
Flutter_tts
Hive
Provider
后端技术栈:
Node.js + Express + TypeScript
MongoDB + Mongoose
JWT
PM2
推荐理由:
为什么选择Flutter:
跨平台开发,显著提升开发效率
优秀的UI渲染性能,保证阅读体验
丰富的第三方库生态
Hot Reload支持快速开发
社区活跃度高
为什么选择Node.js后端:
JavaScript全栈开发,降低开发成本
异步IO性能好,适合文件处理
npm生态丰富,快速集成各类功能
部署维护简单
为什么选择MongoDB:
文档型数据库,灵活存储课程数据
查询性能好
易于横向扩展
与Node.js完美配合
具体实现建议:
文件解析:
PDF: pdf.js
EPUB: epub.js
RSS: feed-parser
AI语音集成:
预留标准化接口
支持Azure/讯飞/百度等多个语音服务
支持自定义语音参数
学习计划管理:
使用MongoDB存储课程结构
Hive实现本地数据缓存
GetX管理全局状态
部署方案:
Docker容器化
Kubernetes集群
CI/CD自动化部署
这套技术方案可以很好地支持您需要的核心功能,同时具有良好的扩展性和维护性。
”“”

# AI听书App技术设计文档

## 项目结构

project_root/
├── frontend/ # Flutter前端项目
│ ├── lib/
│ │ ├── api/ # API请求
│ │ ├── models/ # 数据模型
│ │ ├── pages/ # 页面
│ │ ├── services/ # 服务
│ │ ├── utils/ # 工具类
│ │ └── widgets/ # 自定义组件
│ ├── assets/ # 静态资源
│ └── test/ # 测试用例
│
├── backend/ # Node.js后端项目
│ ├── src/
│ │ ├── controllers/ # 控制器
│ │ ├── models/ # 数据模型
│ │ ├── routes/ # 路由
│ │ ├── services/ # 服务
│ │ └── utils/ # 工具函数
│ ├── config/ # 配置文件
│ └── tests/ # 测试用例
│
├── docs/ # 项目文档
└── docker/ # Docker配置


## 技术栈

### 前端
- Flutter 3.x
- GetX (状态管理)
- Flutter_tts (语音合成)
- Hive (本地存储)
- Provider (依赖注入)

### 后端
- Node.js + Express + TypeScript
- MongoDB + Mongoose
- JWT认证
- PM2进程管理

## 核心功能模块

### 1. 文件管理
- 支持格式: PDF, EPUB, TXT, RSS
- 文件解析库: pdf.js, epub.js, feed-parser
- 本地缓存策略
- 文件同步机制

### 2. 课程管理
- 课程创建与编辑
- 章节管理
- 进度追踪
- 笔记标注

### 3. 学习计划
- 计划创建
- 课程编排
- 自动执行
- 进度统计

### 4. AI语音合成
- 标准化语音接口
- 多模型支持
- 语音参数配置
- 缓存机制

## 数据模型

### User

javascript
{
id: ObjectId,
username: String,
email: String,
password: String,
settings: {
voiceModel: String,
speed: Number,
pitch: Number
}
}


### Course

javascript
{
id: ObjectId,
userId: ObjectId,
title: String,
type: String,
chapters: [{
title: String,
content: String,
duration: Number
}],
progress: Number
}


### StudyPlan

javascript
{
id: ObjectId,
userId: ObjectId,
title: String,
courses: [{
courseId: ObjectId,
chaptersPerDay: Number
}],
schedule: {
startDate: Date,
endDate: Date,
dailyGoal: Number
}
}



## API接口设计

### 用户相关
- POST /api/auth/register
- POST /api/auth/login
- GET /api/user/profile
- PUT /api/user/settings

### 课程相关
- POST /api/courses
- GET /api/courses
- PUT /api/courses/:id
- DELETE /api/courses/:id

### 学习计划
- POST /api/plans
- GET /api/plans
- PUT /api/plans/:id
- DELETE /api/plans/:id

## 部署方案

### Docker配置

yaml
version: '3'
services:
frontend:
build: ./frontend
ports:
"80:80"
backend:
build: ./backend
ports:
"3000:3000"
mongodb:
image: mongo
ports:
"27017:27017"


### CI/CD流程
1. 代码提交触发CI
2. 运行测试用例
3. 构建Docker镜像
4. 推送到镜像仓库
5. 自动部署到测试环境
6. 手动确认生产环境部署

## 开发规范

### 代码风格
- 使用ESLint进行代码检查
- 遵循Flutter官方代码规范
- 使用Prettier格式化代码

### 提交规范
- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式
- refactor: 重构
- test: 测试用例
- chore: 构建过程或辅助工具的变动

### 测试要求
- 单元测试覆盖率 > 80%
- 必须包含集成测试
- UI测试覆盖主要功能