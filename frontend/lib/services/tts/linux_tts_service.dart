import 'dart:io';
import 'package:flutter/foundation.dart';
import 'tts_interface.dart';

class LinuxTtsService implements TtsInterface {
  bool _isInitialized = false;
  Process? _currentProcess;
  double _rate = 1.0;
  double _pitch = 1.0;
  double _volume = 1.0;
  
  @override
  Future<bool> init() async {
    try {
      // 检查 speech-dispatcher 是否可用
      final result = await Process.run('which', ['spd-say']);
      if (result.exitCode == 0) {
        // 检查中文支持
        final voices = await Process.run('spd-say', ['-L']);
        debugPrint('可用语音: ${voices.stdout}');
        
        // 尝试设置中文语音
        await Process.run('spd-say', ['-l', 'cmn']);  // 使用 cmn 代表中文普通话
        
        _isInitialized = true;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Linux TTS 初始化失败: $e');
      return false;
    }
  }

  @override
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      final success = await init();
      if (!success) {
        debugPrint('Linux TTS 服务未能初始化');
        return;
      }
    }

    try {
      // 确保先停止当前播放
      await stop();

      // 构建命令参数
      final args = [
        '-w',                                     // 等待播放完成
        '-l', 'cmn',                             // 使用中文普通话
        '-r', '${(_rate * 100 - 100).round()}',  // 语速 (-100 到 100)
        '-p', '${(_pitch * 100 - 100).round()}', // 音调 (-100 到 100)
        '-i', '${(_volume * 100).round()}',      // 音量 (0 到 100)
        '-t', 'native',                          // 使用本地文本处理
        text
      ];

      // 启动新进程
      _currentProcess = await Process.start('spd-say', args);
      
      // 监听进程退出
      _currentProcess!.exitCode.then((_) {
        _currentProcess = null;
      });

      debugPrint('开始播放文本: $text');
    } catch (e) {
      debugPrint('Linux TTS 播放失败: $e');
    }
  }

  @override
  Future<void> stop() async {
    try {
      if (_currentProcess != null) {
        _currentProcess!.kill(ProcessSignal.sigterm);
        await _currentProcess!.exitCode;  // 等待进程结束
        _currentProcess = null;
      }
      
      // 确保清理所有 spd-say 进程
      await Process.run('pkill', ['-f', 'spd-say']);
      
      debugPrint('TTS 已停止');
    } catch (e) {
      debugPrint('Linux TTS 停止失败: $e');
    }
  }

  @override
  void dispose() async {
    await stop();
  }

  @override
  Future<void> pause() async {
    await stop();  // Linux TTS 不支持暂停，所以直接停止
  }

  @override
  Future<void> resume() async {
    // Linux TTS 不支持恢复，需要重新开始
  }

  @override
  Future<void> setRate(double rate) async {
    _rate = rate;
  }

  @override
  Future<void> setPitch(double pitch) async {
    _pitch = pitch;
  }

  @override
  Future<void> setVolume(double volume) async {
    _volume = volume;
  }
} 