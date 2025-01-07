import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../services/text_service.dart';
import '../../services/tts_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  final UserService userService = UserService();
  final TextService textService = TextService();
  final TtsService ttsService = TtsService();
  
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await ttsService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await userService.logout();
              // TODO: 处理登出后的导航
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '请输入要阅读的文本',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (isPlaying) {
                  await ttsService.stop();
                } else {
                  await ttsService.speak(textController.text);
                }
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
              child: Text(isPlaying ? '停止' : '开始阅读'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ttsService.stop();
    super.dispose();
  }
} 