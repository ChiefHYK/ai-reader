import 'dart:convert';
import 'package:http/http.dart' as http;

class TextService {
  final String baseUrl = 'http://localhost:3000/api/texts';

  // 上传文本
  Future<void> uploadText(String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/upload'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to upload text');
    }
  }
} 