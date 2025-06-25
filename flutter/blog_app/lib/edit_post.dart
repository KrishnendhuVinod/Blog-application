import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPostScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  final String token;

  const EditPostScreen({
    super.key,
    required this.post,
    required this.token,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.post['title']);
    contentController = TextEditingController(text: widget.post['content']);
  }

  Future<void> updatePost() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/posts/${widget.post['id']}/');

    setState(() {
      isUpdating = true;
    });

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${widget.token}',
        },
        body: jsonEncode({
          'title': titleController.text,
          'content': contentController.text,
          'summary': contentController.text.length > 50
              ? contentController.text.substring(0, 50) + '...'
              : contentController.text
        }),
      );

      setState(() {
        isUpdating = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Post updated successfully!')),
        );
        Navigator.pop(context, true); // Return to previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Update failed: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() {
        isUpdating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Edit Post'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter post title',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Content',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                maxLines: 8,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter full post content',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isUpdating ? null : updatePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isUpdating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Update Post',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
