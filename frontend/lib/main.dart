import 'package:flutter/material.dart';
import 'services/user_service.dart';
import 'services/text_service.dart';
import 'services/tts_service.dart';
import 'views/screens/reading_history_screen.dart';
import 'views/screens/course_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Reader App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatelessWidget {
  final UserService userService = UserService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextService textService = TextService();
  final TextEditingController textController = TextEditingController();
  final TtsService ttsService = TtsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Reader App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadingHistoryScreen(
                    userId: 'current-user-id', // TODO: 替换为实际的用户ID
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Enter text to upload'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await userService.register(
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration successful')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration failed')),
                  );
                }
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await userService.login(
                    emailController.text,
                    passwordController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login successful')),
                  );
                  // 获取并显示用户信息
                  final userProfile = await userService.getUserProfile(emailController.text);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('User Profile'),
                      content: Text('Username: ${userProfile['username']}\nEmail: ${userProfile['email']}'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed')),
                  );
                }
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await textService.uploadText(textController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Text uploaded successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload text')),
                  );
                }
              },
              child: Text('Upload Text'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ttsService.synthesizeText(textController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Text synthesized successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to synthesize text')),
                  );
                }
              },
              child: Text('Synthesize Text'),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('My Courses'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseListScreen(
                      userId: 'current-user-id', // TODO: 替换为实际的用户ID
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
