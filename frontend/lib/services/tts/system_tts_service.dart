import 'package:flutter_tts/flutter_tts.dart';
import 'base_tts_service.dart';

class SystemTtsService implements BaseTtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  @override
  String get engineName => '系统TTS';

  @override
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      await _flutterTts.setLanguage("zh-CN");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(0.5);
      _isInitialized = true;
    } catch (e) {
      throw Exception('系统TTS初始化失败: $e');
    }
  }

  @override
  Future<void> speak(String text, {String? language}) async {
    await init();
    if (language != null) {
      await _flutterTts.setLanguage(language);
    }
    await _flutterTts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  @override
  Future<void> pause() async {
    await _flutterTts.pause();
  }

  @override
  Future<void> resume() async {
    await _flutterTts.speak('');
  }

  @override
  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume.clamp(0.0, 1.0));
  }

  @override
  Future<void> setRate(double rate) async {
    await _flutterTts.setSpeechRate(rate.clamp(0.1, 2.0));
  }
} 