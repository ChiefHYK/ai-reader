import 'package:flutter/material.dart';
import '../../services/course_service.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends StatefulWidget {
  final String userId;

  const CourseListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CourseService _courseService = CourseService();
  List<dynamic> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  // 加载课程列表
  Future<void> _loadCourses() async {
    try {
      final courses = await _courseService.getUserCourses(widget.userId);
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load courses: $e')),
      );
    }
  }

  // 显示添加课程对话框
  Future<void> _showAddCourseDialog() async {
    final TextEditingController titleController = TextEditingController();
    String selectedType = 'PDF';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Course'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Course Title'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: ['PDF', 'EPUB', 'TXT', 'RSS'].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                selectedType = value!;
              },
              decoration: const InputDecoration(labelText: 'Course Type'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _courseService.createCourse(
                  widget.userId,
                  titleController.text,
                  selectedType,
                  [],
                );
                Navigator.pop(context);
                _loadCourses(); // 重新加载课程列表
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to create course: $e')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCourseDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _courses.isEmpty
              ? const Center(child: Text('No courses yet'))
              : ListView.builder(
                  itemCount: _courses.length,
                  itemBuilder: (context, index) {
                    final course = _courses[index];
                    return ListTile(
                      title: Text(course['title']),
                      subtitle: Text(
                        'Type: ${course['type']}\n'
                        'Progress: ${(course['progress'] * 100).toStringAsFixed(1)}%',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailScreen(
                              course: course,
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