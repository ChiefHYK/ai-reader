import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'base_tts_service.dart';

class EdgeTtsService implements BaseTtsService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  
  @override
  String get engineName => 'Edge TTS';

  static const Map<String, String> _voices = {
    'zh-CN': 'zh-CN-XiaoxiaoNeural',
    'en-US': 'en-US-AriaNeural'
  };

  @override
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      _isInitialized = true;
    } catch (e) {
      throw Exception('Edge TTS初始化失败: $e');
    }
  }

  @override
  Future<void> speak(String text, {String? language}) async {
    await init();
    final voice = _voices[language ?? 'zh-CN'] ?? _voices['zh-CN']!;
    
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.edge-tts.com/v1/speak'
          '?voice=$voice'
          '&text=${Uri.encodeComponent(text)}'
        ),
      );

      if (response.statusCode == 200) {
        await playAudio(response.bodyBytes);
      } else {
        throw Exception('Edge TTS请求失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Edge TTS错误: $e');
    }
  }

  @override
  Future<void> stop() async => await _audioPlayer.stop();

  @override
  Future<void> pause() async => await _audioPlayer.pause();

  @override
  Future<void> resume() async => await _audioPlayer.resume();

  @override
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  @override
  Future<void> setRate(double rate) async {
    // Edge TTS不支持动态调整语速
  }

  Future<void> playAudio(List<int> bytes) async {
    final source = BytesSource(bytes);
    await _audioPlayer.play(source);
  }
} 