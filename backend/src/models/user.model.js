const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

// 定义用户Schema
const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
});

// 在保存用户前加密密码
userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

// 创建用户模型
const User = mongoose.model('User', userSchema);

module.exports = User;
