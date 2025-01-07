import 'package:flutter/material.dart';
import '../../services/tts/tts_interface.dart';
import 'tts_settings.dart';

class TtsPlayerControls extends StatefulWidget {
  final TtsInterface ttsService;
  final String text;

  const TtsPlayerControls({
    Key? key,
    required this.ttsService,
    required this.text,
  }) : super(key: key);

  @override
  State<TtsPlayerControls> createState() => _TtsPlayerControlsState();
}

class _TtsPlayerControlsState extends State<TtsPlayerControls> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 播放/暂停按钮
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _togglePlayPause,
          iconSize: 48,
        ),
        // 停止按钮
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: _isPlaying ? _stop : null,
          iconSize: 48,
        ),
        // 设置按钮
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _showSettings(context),
          iconSize: 48,
        ),
      ],
    );
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await widget.ttsService.stop();
    } else {
      await widget.ttsService.speak(widget.text);
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  Future<void> _stop() async {
    await widget.ttsService.stop();
    setState(() => _isPlaying = false);
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TtsSettings(
        ttsService: widget.ttsService,
      ),
    );
  }
} 