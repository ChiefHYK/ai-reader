const express = require('express');
const gTTS = require('gtts');

const router = express.Router();

// 文本到语音转换
router.post('/synthesize', (req, res) => {
  const { text } = req.body;
  const gtts = new gTTS(text, 'en');

  gtts.stream().pipe(res);
});

module.exports = router; 