import 'base_tts_service.dart';
import 'system_tts_service.dart';
import 'edge_tts_service.dart';

class TtsManager {
  static final TtsManager _instance = TtsManager._internal();
  factory TtsManager() => _instance;
  TtsManager._internal();

  late BaseTtsService _currentEngine;
  final Map<String, BaseTtsService> _engines = {};
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // 只注册基本的TTS引擎
      _engines.addAll({
        '系统TTS': SystemTtsService(),
        'Edge TTS': EdgeTtsService(),
      });

      // 默认使用系统TTS
      _currentEngine = _engines['系统TTS']!;
      await _currentEngine.init();
      _isInitialized = true;
    } catch (e) {
      throw Exception('TTS管理器初始化失败: $e');
    }
  }

  Future<void> setEngine(String engineName) async {
    if (!_isInitialized) await init();
    
    if (!_engines.containsKey(engineName)) {
      throw Exception('未找到TTS引擎: $engineName');
    }
    
    try {
      final newEngine = _engines[engineName]!;
      await newEngine.init();
      _currentEngine = newEngine;
    } catch (e) {
      throw Exception('切换TTS引擎失败: $e');
    }
  }

  List<String> get availableEngines => _engines.keys.toList();
  BaseTtsService get currentEngine => _currentEngine;
  bool get isInitialized => _isInitialized;
} 