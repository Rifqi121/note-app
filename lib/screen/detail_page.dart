import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/post.dart';
import '../state/cubit/notes_cubit.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
Widget build(BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  if (args == null || args is! Post) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: const Center(
        child: Text('Data catatan tidak ditemukan'),
      ),
    );
  }

  final Post post = args;

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

            if (editedPost is Post) {
              Navigator.pushReplacementNamed(
                context,
                '/detail',
                arguments: editedPost,
              );
            }
          }
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Hapus Catatan',
          onPressed: () {
            _showDeleteConfirmation(context, post);
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


  void _showDeleteConfirmation(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Yakin ingin menghapus catatan ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.read<NotesCubit>().deleteNote(post.id);
                Navigator.of(dialogContext).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Kembali ke HomeScreen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Catatan dihapus')),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
