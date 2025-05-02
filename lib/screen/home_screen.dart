import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/state/cubit/notes_cubit.dart';
import 'package:note/widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state is NotesInitial) {
            return const Center(child: Text('Belum ada catatan'));
          } else if (state is NotesLoaded) {
            final notes = state.notes;
            if (notes.isEmpty) {
              return const Center(child: Text('Tidak ada catatan'));
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final post = notes[index];
                return Dismissible(
                  key: Key(post.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Catatan?'),
                        content: const Text('Catatan ini akan dihapus secara permanen.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) {
                    context.read<NotesCubit>().deleteNote(post.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Catatan "${post.title}" dihapus')),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/detail', arguments: post);
                      },
                      child: NoteCard(
                        title: Text(post.title),
                        content: Text(
                          post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        date: post.createAt,
                        owner: 'created by rifqi',
                        priority: 'low',
                        onInfo: () {},
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Terjadi kesalahan'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
