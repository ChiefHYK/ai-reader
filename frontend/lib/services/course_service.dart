import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseService {
  final String baseUrl = 'http://localhost:3000/api/courses';

  // 创建新课程
  Future<Map<String, dynamic>> createCourse(
    String userId,
    String title,
    String type,
    List<Map<String, dynamic>> chapters,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'title': title,
        'type': type,
        'chapters': chapters,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create course');
    }
  }

  // 获取用户的所有课程
  Future<List<dynamic>> getUserCourses(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load courses');
    }
  }

  // 更新课程进度
  Future<Map<String, dynamic>> updateProgress(
    String courseId,
    double progress,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$courseId/progress'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'progress': progress}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update progress');
    }
  }
}