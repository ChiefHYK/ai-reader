import 'package:flutter/material.dart';
import '../../services/reading_history_service.dart';
import 'reading_detail_screen.dart';

class ReadingHistoryScreen extends StatefulWidget {
  final String userId;

  const ReadingHistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ReadingHistoryScreenState createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  final ReadingHistoryService _historyService = ReadingHistoryService();
  List<dynamic> _histories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistories();
  }

  // 加载阅读历史
  Future<void> _loadHistories() async {
    try {
      final histories = await _historyService.getHistory(widget.userId);
      setState(() {
        _histories = histories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load reading history: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _histories.isEmpty
              ? const Center(child: Text('No reading history yet'))
              : ListView.builder(
                  itemCount: _histories.length,
                  itemBuilder: (context, index) {
                    final history = _histories[index];
                    return ListTile(
                      title: Text(history['title'] ?? 'Untitled'),
                      subtitle: Text(
                        'Duration: ${history['duration']} seconds\n'
                        'Date: ${DateTime.parse(history['readDate']).toString()}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadingDetailScreen(
                              history: history,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
} 