import 'package:flutter/foundation.dart';
import '../services/tts/tts_interface.dart';
import '../services/tts/tts_factory.dart';

class TtsProvider extends ChangeNotifier {
  final TtsInterface _tts = TtsFactory.create();
  bool _isPlaying = false;
  double _rate = 1.0;
  double _pitch = 1.0;
  double _volume = 1.0;

  bool get isPlaying => _isPlaying;
  double get rate => _rate;
  double get pitch => _pitch;
  double get volume => _volume;

  Future<bool> initialize() async {
    return await _tts.init();
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> stop() async {
    await _tts.stop();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> setRate(double value) async {
    await _tts.setRate(value);
    _rate = value;
    notifyListeners();
  }

  Future<void> setPitch(double value) async {
    await _tts.setPitch(value);
    _pitch = value;
    notifyListeners();
  }

  Future<void> setVolume(double value) async {
    await _tts.setVolume(value);
    _volume = value;
    notifyListeners();
  }
} 