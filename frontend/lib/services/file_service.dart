import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileService {
  // 支持的文件格式
  static const supportedExtensions = [
    'txt',
    'epub',
    'pdf',
    'mobi',
    'doc',
    'docx'
  ];

  // 选择并验证文件
  Future<File?> pickTextFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: supportedExtensions,
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final isValid = await _validateFile(file);
        
        if (!isValid) {
          throw Exception('不支持的文件格式');
        }
        
        return file;
      }
      return null;
      
    } catch (e) {
      debugPrint('文件选择错误: $e');
      rethrow;
    }
  }

  // 验证文件
  Future<bool> _validateFile(File file) async {
    // 检查文件扩展名
    final extension = file.path.split('.').last.toLowerCase();
    if (!supportedExtensions.contains(extension)) {
      return false;
    }

    // 检查文件大小 (例如限制为 50MB)
    final fileSize = await file.length();
    if (fileSize > 50 * 1024 * 1024) {
      throw Exception('文件大小超过限制');
    }

    return true;
  }

  // 读取文本内容
  Future<String> readTextFile(File file) async {
    try {
      final extension = file.path.split('.').last.toLowerCase();
      
      switch (extension) {
        case 'txt':
          return await file.readAsString();
        // TODO: 添加其他格式的解析支持
        default:
          throw Exception('暂不支持该文件格式的解析');
      }
    } catch (e) {
      debugPrint('文件读取错误: $e');
      rethrow;
    }
  }
} 