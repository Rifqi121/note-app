import 'package:flutter/material.dart';
import '../models/note.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Note) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Catatan')),
        body: const Center(
          child: Text('Data catatan tidak ditemukan'),
        ),
      );
    }

    final Note post = args;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Catatan',
            onPressed: () async {
              final editedPost = await Navigator.pushNamed(
                context,
                '/edit',
                arguments: post,
              );

              if (editedPost is Note) {
                Navigator.pushReplacementNamed(
                  context,
                  '/detail',
                  arguments: editedPost,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(post.body, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
