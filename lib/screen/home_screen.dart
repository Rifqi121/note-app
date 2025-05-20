import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/di.dart';
import 'package:note/services/post_repository.dart';
import 'package:note/state/bloc/post_bloc.dart';
import 'package:note/state/bloc/post_event.dart';
import 'package:note/state/bloc/post_state.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(getIt<PostRepository>())..add(FetchPosts()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Beranda', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data berhasil ditampilkan')),
              );
            } else if (state is PostError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data tidak ditemukan')),
              );
            }
          },
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostLoaded) {
              if (state.posts.isEmpty) {
                return const Center(child: Text('Belum ada data post'));
              }
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context, 
                          '/detail',
                          arguments: post,
                        );
                      },
                    child: NoteCard(
                      title: Text(post.title),
                      content: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                      date: '12-04-2025',
                      owner: 'Rifqi',
                      priority: 'low',
                      onInfo: () {},
                    ),
                  )
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
            // Tombol Reload Data
            FloatingActionButton(
              heroTag: 'reload',
              onPressed: () {},
              tooltip: 'Muat Ulang',
              backgroundColor: Colors.orange,
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(height: 16),
            // Tombol Tambah Data
            FloatingActionButton(
              heroTag: 'add',
              onPressed: () {
                Navigator.pushNamed(context, '/edit'); // Ganti '/edit' dengan rute ke halaman tambah catatan
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
