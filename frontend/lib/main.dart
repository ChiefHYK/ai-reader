import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/screens/reader_screen.dart';

void main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  // 设置首选方向
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ReaderScreen(
        text: '欢迎使用 AI Reader！\n\n'
             '这是一个示例文本，您可以在这里阅读和收听文章内容。\n\n'
             '点击下方的播放按钮开始收听，或者使用设置按钮调整语音参数。',
      ),
    );
  }
}

