const express = require('express');
const ReadingHistory = require('../models/reading_history.model');
const router = express.Router();

// 添加阅读记录
router.post('/add', async (req, res) => {
  try {
    const { userId, textContent, title, duration } = req.body;
    const newHistory = new ReadingHistory({
      userId,
      textContent,
      title,
      duration
    });
    await newHistory.save();
    res.status(201).json({ message: 'Reading history added successfully' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// 获取用户的阅读历史
router.get('/:userId', async (req, res) => {
  try {
    const histories = await ReadingHistory.find({ userId: req.params.userId })
      .sort({ readDate: -1 });
    res.status(200).json(histories);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router; 