abstract class BaseTtsService {
  Future<void> init();
  Future<void> speak(String text, {String? language});
  Future<void> stop();
  Future<void> pause();
  Future<void> resume();
  Future<void> setVolume(double volume);
  Future<void> setRate(double rate);
  String get engineName;
} 