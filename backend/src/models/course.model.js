const mongoose = require('mongoose');

// 定义章节Schema
const chapterSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  content: {
    type: String,
    required: true
  },
  duration: {
    type: Number,
    default: 0
  }
});

// 定义课程Schema
const courseSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  title: {
    type: String,
    required: true
  },
  type: {
    type: String,
    enum: ['PDF', 'EPUB', 'TXT', 'RSS'],
    required: true
  },
  chapters: [chapterSchema],
  progress: {
    type: Number,
    default: 0
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Course = mongoose.model('Course', courseSchema);
module.exports = Course; 