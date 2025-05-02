import 'package:flutter/material.dart';
import '../models/post.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  Post? post;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Post) {
      post = args;
      _titleController.text = post!.title;
      _bodyController.text = post!.body;
    }
  }

  void _saveNote() {
    final title = _titleController.text;
    final body = _bodyController.text;

    if (title.isNotEmpty && body.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${title}" disimpan!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post != null ? 'Edit Catatan' : 'Tambah Catatan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bodyController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Isi Catatan'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
