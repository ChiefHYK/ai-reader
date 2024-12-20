const express = require('express');
const Text = require('../models/text.model');

const router = express.Router();

// 上传文本
router.post('/upload', async (req, res) => {
  try {
    const { content } = req.body;
    const newText = new Text({ content });
    await newText.save();
    res.status(201).json({ message: 'Text uploaded successfully' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router; 