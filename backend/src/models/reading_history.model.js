const mongoose = require('mongoose');

// 定义阅读历史Schema
const readingHistorySchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  textContent: {
    type: String,
    required: true
  },
  title: {
    type: String,
    default: '未命名文本'
  },
  readDate: {
    type: Date,
    default: Date.now
  },
  duration: {
    type: Number,
    default: 0  // 阅读时长（秒）
  }
});

const ReadingHistory = mongoose.model('ReadingHistory', readingHistorySchema);
module.exports = ReadingHistory; 