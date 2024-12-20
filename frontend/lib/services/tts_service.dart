import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class TtsService {
  final String baseUrl = 'http://localhost:3000/api/tts';
  final AudioPlayer audioPlayer = AudioPlayer();

  // 请求TTS服务
  Future<void> synthesizeText(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/synthesize'),
      headers: {'Content-Type': 'application/json'},
      body: {'text': text},
    );

    if (response.statusCode == 200) {
      await audioPlayer.play(BytesSource(response.bodyBytes));
    } else {
      throw Exception('Failed to synthesize text');
    }
  }
} 