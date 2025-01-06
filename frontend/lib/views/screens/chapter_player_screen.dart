import 'package:flutter/material.dart';
import '../../services/tts_service.dart';

class ChapterPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> chapter;
  final String courseTitle;

  const ChapterPlayerScreen({
    Key? key,
    required this.chapter,
    required this.courseTitle,
  }) : super(key: key);

  @override
  _ChapterPlayerScreenState createState() => _ChapterPlayerScreenState();
}

class _ChapterPlayerScreenState extends State<ChapterPlayerScreen> {
  final TtsService _ttsService = TtsService();
  bool _isPlaying = false;
  bool _isPaused = false;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  // 初始化TTS服务
  Future<void> _initTts() async {
    try {
      await _ttsService.init();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize TTS: $e')),
        );
      }
    }
  }

  // 播放或暂停
  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        if (_isPaused) {
          await _ttsService.resume();
          setState(() => _isPaused = false);
        } else {
          await _ttsService.pause();
          setState(() => _isPaused = true);
        }
      } else {
        await _ttsService.speak(widget.chapter['content']);
        setState(() {
          _isPlaying = true;
          _isPaused = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playback error: $e')),
      );
    }
  }

  // 停止播放
  Future<void> _stop() async {
    try {
      await _ttsService.stop();
      setState(() {
        _isPlaying = false;
        _isPaused = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop playback: $e')),
      );
    }
  }

  // 调整播放速度
  Future<void> _changeSpeed(double speed) async {
    try {
      await _ttsService.setRate(speed);
      setState(() => _playbackSpeed = speed);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change speed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTitle),
        subtitle: Text(widget.chapter['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 章节内容
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.chapter['content'],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            // 播放控制
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 播放速度控制
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Speed: ${_playbackSpeed.toStringAsFixed(1)}x'),
                        Slider(
                          value: _playbackSpeed,
                          min: 0.5,
                          max: 2.0,
                          divisions: 3,
                          onChanged: _changeSpeed,
                        ),
                      ],
                    ),
                    // 播放控制按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(_isPlaying && !_isPaused
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: _togglePlayPause,
                          iconSize: 48,
                        ),
                        IconButton(
                          icon: const Icon(Icons.stop),
                          onPressed: _isPlaying ? _stop : null,
                          iconSize: 48,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }
} 