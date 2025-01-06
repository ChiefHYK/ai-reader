import 'package:flutter/material.dart';
import '../../services/course_service.dart';

class CourseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseDetailScreen({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final CourseService _courseService = CourseService();
  bool _isLoading = false;

  // 更新课程进度
  Future<void> _updateProgress(double progress) async {
    setState(() => _isLoading = true);
    try {
      await _courseService.updateProgress(
        widget.course['_id'],
        progress,
      );
      // 更新本地数据
      setState(() {
        widget.course['progress'] = progress;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update progress: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 显示添加章节对话框
  Future<void> _showAddChapterDialog() async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Chapter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Chapter Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Chapter Content'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 实现添加章节功能
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapters = List<Map<String, dynamic>>.from(widget.course['chapters'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course['title']),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddChapterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 课程信息卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Course Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text('Type: ${widget.course['type']}'),
                          Text(
                            'Progress: ${(widget.course['progress'] * 100).toStringAsFixed(1)}%',
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: widget.course['progress'] ?? 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 章节列表
                  Text(
                    'Chapters',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  chapters.isEmpty
                      ? const Center(
                          child: Text('No chapters yet'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = chapters[index];
                            return Card(
                              child: ListTile(
                                title: Text(chapter['title']),
                                subtitle: Text(
                                  'Duration: ${chapter['duration']} minutes',
                                ),
                                trailing: const Icon(Icons.play_arrow),
                                onTap: () {
                                  // TODO: 实现章节播放功能
                                },
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