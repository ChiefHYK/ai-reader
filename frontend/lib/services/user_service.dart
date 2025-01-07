import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://localhost:3000/api/users';

  // 用户注册
  Future<void> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user');
    }
  }

  // 用户登录
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to login');
    }
  }

  // 获取用户信息
  Future<Map<String, dynamic>> getUserProfile(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<bool> isLoggedIn() async {
    // 这里实现检查用户是否已登录的逻辑
    // 例如检查本地存储的token是否有效
    // 暂时返回false表示需要登录
    return false;
  }

  Future<void> logout() async {
    // TODO: 实现登出逻辑
  }
} 