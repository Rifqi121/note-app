import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note/di.dart';
import 'package:note/repositories/note_repository.dart';
import 'package:note/state/bloc/note/note_bloc.dart';
import '../widgets/note_card.dart';

enum NoteOrderBy { title, priority, deadline }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NoteOrderBy _selectedOrder = NoteOrderBy.title;

  final Map<String, int> priorityOrder = {
    'Rendah': 0,
    'Sedang': 1,
    'Tinggi': 2,
  };

  void _showToast(String msg, {Color backgroundColor = Colors.grey, Color textColor = Colors.white}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return BlocProvider(
      create: (_) => NoteBloc(getIt<NoteRepository>())..add(LoadNotes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MyNotes', style: TextStyle(color: Colors.blue)),
          actions: [
            PopupMenuButton<NoteOrderBy>(
              icon: const Icon(Icons.sort),
              initialValue: _selectedOrder,
              onSelected: (order) {
                setState(() {
                  _selectedOrder = order;
                });
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(
                  value: NoteOrderBy.title,
                  child: Text('Urutkan Judul (A-Z)'),
                ),
                const PopupMenuItem(
                  value: NoteOrderBy.priority,
                  child: Text('Urutkan Prioritas'),
                ),
                const PopupMenuItem(
                  value: NoteOrderBy.deadline,
                  child: Text('Urutkan Deadline'),
                ),
              ],
            ),
          ],
        ),
        body: BlocConsumer<NoteBloc, NoteState>(
          listener: (context, state) {
            if (state is NoteLoaded) {
              _showToast('Data berhasil ditampilkan');
            } else if (state is NoteError) {
              _showToast('Gagal memuat data', backgroundColor: Colors.red);
            }
          },
          builder: (context, state) {
            if (state is NoteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NoteLoaded) {
              if (state.notes.isEmpty) {
                return const Center(child: Text('Belum ada catatan'));
              }
              List notes = List.of(state.notes);

              if (_selectedOrder == NoteOrderBy.title) {
                notes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
              } else if (_selectedOrder == NoteOrderBy.priority) {
                notes.sort((a, b) {
                  int pa = priorityOrder[a.priority] ?? -1;
                  int pb = priorityOrder[b.priority] ?? -1;
                  return pa.compareTo(pb);
                });
              } else if (_selectedOrder == NoteOrderBy.deadline) {
                notes.sort((a, b) {
                  DateTime? da = a.deadline != null ? DateTime.tryParse(a.deadline!) : null;
                  DateTime? db = b.deadline != null ? DateTime.tryParse(b.deadline!) : null;
                  if (da == null && db == null) return 0;
                  if (da == null) return 1;
                  if (db == null) return -1;
                  return da.compareTo(db);
                });
              }

              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Dismissible(
                    key: Key(note.id),
                    direction: DismissDirection.endToStart,
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
                      context.read<NoteBloc>().add(DeleteNoteEvent(note.id));
                      _showToast('Catatan dihapus', backgroundColor: Colors.red);
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
                          date: note.deadline.toString(),
                          owner: user?.displayName?? 'Anonnymous',
                          priority: note.priority.toString(),
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