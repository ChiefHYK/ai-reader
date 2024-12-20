const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// 连接到MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('Connected to MongoDB for AI Reader'))
.catch(err => console.error('MongoDB connection error:', err));

// 中间件
app.use(express.json());

// 基本路由
app.get('/', (req, res) => {
  res.send('AI Reading App Backend');
});

// 使用用户路由
const userRoutes = require('./routes/user.routes');

// 使用用户路由
app.use('/api/users', userRoutes);

// 使用文本路由
const textRoutes = require('./routes/text.routes');

// 使用文本路由
app.use('/api/texts', textRoutes);

// 使用TTS路由
const ttsRoutes = require('./routes/tts.routes');

// 使用TTS路由
app.use('/api/tts', ttsRoutes);

// 启动服务器
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
