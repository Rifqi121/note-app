import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/state/cubit/notes_cubit.dart';
import '../models/post.dart';
import 'package:intl/intl.dart';


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
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) return;

    final cubit = context.read<NotesCubit>();

    if (post != null) {
    final updatedPost = Post(
      userId: post!.userId,
      id: post!.id,
      title: title,
      body: body,
      createAt: 'lastedited ${DateFormat('dd-mm-yyyy', 'id').format(DateTime.now())}'
    );
    cubit.updateNote(updatedPost);
    Navigator.pop(context, updatedPost); // Kirim catatan hasil update
  } else {
    final newId = DateTime.now().millisecondsSinceEpoch;
    final newPost = Post(
      userId: 1,
      id: newId,
      title: title,
      body: body,
      createAt: DateFormat('dd-mm-yyyy', 'id').format(DateTime.now())
    );
    cubit.addNote(newPost);
    Navigator.pop(context, newPost); // Kirim catatan baru
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post != null ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
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
