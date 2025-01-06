const express = require('express');
const Course = require('../models/course.model');
const router = express.Router();

// 创建新课程
router.post('/', async (req, res) => {
  try {
    const { userId, title, type, chapters } = req.body;
    const newCourse = new Course({
      userId,
      title,
      type,
      chapters: chapters || []
    });
    await newCourse.save();
    res.status(201).json(newCourse);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// 获取用户的所有课程
router.get('/user/:userId', async (req, res) => {
  try {
    const courses = await Course.find({ userId: req.params.userId });
    res.status(200).json(courses);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// 更新课程进度
router.put('/:id/progress', async (req, res) => {
  try {
    const { progress } = req.body;
    const course = await Course.findByIdAndUpdate(
      req.params.id,
      { progress },
      { new: true }
    );
    res.status(200).json(course);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router; 