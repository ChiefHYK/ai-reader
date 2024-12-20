import 'dart:convert';
import 'package:http/http.dart' as http;

class ReadingHistoryService {
  final String baseUrl = 'http://localhost:3000/api/reading-history';

  // 添加阅读记录
  Future<void> addHistory(String userId, String textContent, String title, int duration) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'textContent': textContent,
        'title': title,
        'duration': duration,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add reading history');
    }
  }

  // 获取阅读历史
  Future<List<dynamic>> getHistory(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load reading history');
    }
  }
} 