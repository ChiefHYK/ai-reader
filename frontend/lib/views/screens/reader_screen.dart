import 'package:flutter/material.dart';
import '../widgets/tts_player_controls.dart';
import '../../services/tts/tts_interface.dart';
import '../../services/tts/tts_factory.dart';

class ReaderScreen extends StatefulWidget {
  final String text;

  const ReaderScreen({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final TtsInterface _ttsService = TtsFactory.create();
  
  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    final success = await _ttsService.init();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('TTS初始化失败，请检查系统TTS设置')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('阅读器'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            TtsPlayerControls(
              ttsService: _ttsService,
              text: widget.text,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
} 