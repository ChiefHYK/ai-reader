import 'package:flutter/foundation.dart';
import 'tts_interface.dart';
import 'local_tts_service.dart';
import 'linux_tts_service.dart';

class TtsFactory {
  static TtsInterface create() {
    if (defaultTargetPlatform == TargetPlatform.linux) {
      return LinuxTtsService();
    }
    return LocalTtsService();
  }
} 