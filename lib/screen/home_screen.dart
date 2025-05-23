import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/di.dart';
import 'package:note/repositories/note_repository.dart';
import 'package:note/state/bloc/note/note_bloc.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoteBloc(getIt<NoteRepository>())..add(LoadNotes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Beranda', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: BlocConsumer<NoteBloc, NoteState>(
          listener: (context, state) {
            if (state is NoteLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data berhasil ditampilkan')),
              );
            } else if (state is NoteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gagal memuat data')),
              );
            }
          },
          builder: (context, state) {
            if (state is NoteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NoteLoaded) {
              if (state.notes.isEmpty) {
                return const Center(child: Text('Belum ada catatan'));
              }
              return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return Dismissible(
                    key: Key(note.id), // Key unik berdasarkan ID note
                    direction: DismissDirection.endToStart, // Geser dari kanan ke kiri
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Hapus', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      // Konfirmasi sebelum menghapus (opsional)
                      return await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Hapus Catatan?"),
                          content: const Text("Apakah Anda yakin ingin menghapus catatan ini?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      // Trigger hapus note
                      context.read<NoteBloc>().add(DeleteNoteEvent(note.id));
                      
                      // Tampilkan snackbar undo (opsional)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Catatan dihapus'),
                          action: SnackBarAction(
                            label: 'Batalkan',
                            onPressed: () {
                              // Tambahkan kembali note yang dihapus
                              context.read<NoteBloc>().add(AddNoteEvent(note));
                            },
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: note,
                          );
                        },
                        child: NoteCard(
                          title: Text(note.title),
                          content: Text(
                            note.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          date: '12-04-2025',
                          owner: 'Rifqi',
                          priority: 'Low',
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'reload',
              onPressed: () {
                context.read<NoteBloc>().add(LoadNotes());
              },
              tooltip: 'Muat Ulang',
              backgroundColor: Colors.orange,
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'add',
              onPressed: () {
                Navigator.pushNamed(context, '/edit');
              },
              tooltip: 'Tambah Catatan',
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
