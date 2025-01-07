import 'package:flutter/material.dart';
import '../../services/tts/tts_interface.dart';

class TtsSettings extends StatefulWidget {
  final TtsInterface ttsService;

  const TtsSettings({
    Key? key,
    required this.ttsService,
  }) : super(key: key);

  @override
  State<TtsSettings> createState() => _TtsSettingsState();
}

class _TtsSettingsState extends State<TtsSettings> {
  double _rate = 1.0;
  double _pitch = 1.0;
  double _volume = 1.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('TTS 设置'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 语速设置
          Row(
            children: [
              const Text('语速: '),
              Expanded(
                child: Slider(
                  value: _rate,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: _rate.toString(),
                  onChanged: (value) async {
                    await widget.ttsService.setRate(value);
                    setState(() => _rate = value);
                  },
                ),
              ),
            ],
          ),
          // 音调设置
          Row(
            children: [
              const Text('音调: '),
              Expanded(
                child: Slider(
                  value: _pitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: _pitch.toString(),
                  onChanged: (value) async {
                    await widget.ttsService.setPitch(value);
                    setState(() => _pitch = value);
                  },
                ),
              ),
            ],
          ),
          // 音量设置
          Row(
            children: [
              const Text('音量: '),
              Expanded(
                child: Slider(
                  value: _volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: _volume.toString(),
                  onChanged: (value) async {
                    await widget.ttsService.setVolume(value);
                    setState(() => _volume = value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
    );
  }
} 