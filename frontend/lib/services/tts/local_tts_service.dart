import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Process;
import 'tts_interface.dart';

class LocalTtsService implements TtsInterface {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  @override
  Future<bool> init() async {
    if (_isInitialized) return true;
    
    try {
      // 检查平台支持
      if (!defaultTargetPlatform.supports) {
        debugPrint('当前平台不支持 TTS: $defaultTargetPlatform');
        return false;
      }

      // 基本设置
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(0.5);

      // 尝试设置中文
      try {
        await _flutterTts.setLanguage('zh-CN');
      } catch (e) {
        debugPrint('设置中文失败，尝试设置英文: $e');
        try {
          await _flutterTts.setLanguage('en-US');
        } catch (e) {
          debugPrint('设置英文也失败: $e');
          // 继续执行，使用系统默认语言
        }
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('TTS初始化失败: $e');
      return false;
    }
  }

  @override
  Future<void> speak(String text) async {
    try {
      if (!_isInitialized) {
        final success = await init();
        if (!success) {
          debugPrint('TTS服务未能初始化');
          return;
        }
      }
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTS播放失败: $e');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('TTS停止失败: $e');
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _flutterTts.pause();
    } catch (e) {
      debugPrint('TTS暂停失败: $e');
    }
  }

  @override
  Future<void> resume() async {
    try {
      await _flutterTts.speak('');
    } catch (e) {
      debugPrint('TTS恢复失败: $e');
    }
  }

  @override
  Future<void> setRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      debugPrint('设置语速失败: $e');
    }
  }

  @override
  Future<void> setPitch(double pitch) async {
    try {
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      debugPrint('设置音调失败: $e');
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    try {
      await _flutterTts.setVolume(volume);
    } catch (e) {
      debugPrint('设置音量失败: $e');
    }
  }

  @override
  void dispose() async {
    try {
      await stop();
      _isInitialized = false;
    } catch (e) {
      debugPrint('TTS dispose 失败: $e');
    }
  }
}

// 平台支持检查扩展
extension PlatformSupport on TargetPlatform {
  bool get supports {
    switch (this) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      case TargetPlatform.linux:
        // 在 Linux 上需要检查 speech-dispatcher
        try {
          Process.runSync('which', ['spd-say']);
          return true;
        } catch (e) {
          return false;
        }
      default:
        return false;
    }
  }
} 