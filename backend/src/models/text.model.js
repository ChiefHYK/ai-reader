const mongoose = require('mongoose');

// 定义文本Schema
const textSchema = new mongoose.Schema({
  content: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

// 创建文本模型
const Text = mongoose.model('Text', textSchema);

module.exports = Text; 