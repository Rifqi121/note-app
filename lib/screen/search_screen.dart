import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/models/note.dart';
import 'package:note/repositories/note_repository.dart';
import 'package:note/state/bloc/note/note_bloc.dart';
import 'package:note/widgets/search_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key
  });

  @override
  State < SearchScreen > createState() => _SearchScreenState();
}

class _SearchScreenState extends State < SearchScreen > {
  late TextEditingController _searchController;
  List < Note > _searchResults = [];
  String _query = "";
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _query = _searchController.text;
      _isSearching = _query.isNotEmpty;
    });
  }

  List < Note > _filterNotes(List < Note > notes) {
    if (_query.isEmpty) return [];
    return notes.where((note) {
      final title = note.title.toLowerCase();
      final desc = note.description.toLowerCase();
      final prio = note.priority?.toLowerCase()?? '';
      final status = note.status?.toLowerCase()?? '';
      return title.contains(_query.toLowerCase()) ||
        desc.contains(_query.toLowerCase()) ||
        prio.contains(_query.toLowerCase()) ||
        status.contains(_query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return BlocProvider(
      create: (_) => NoteBloc(NoteRepository())..add(LoadNotes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cari Catatan', style: TextStyle(color: Colors.blue)),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.blue),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari judul, isi, prioritas, atau status...',
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                        suffixIcon: _query.isNotEmpty ?
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.blue),
                            onPressed: () {
                              _searchController.clear();
                              FocusScope.of(context).unfocus();
                            },
                        ) :
                        null,
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                    ),
                    textInputAction: TextInputAction.search,
                  ),
                ),
                const SizedBox(height: 20),
                  Expanded(
                    child: BlocBuilder < NoteBloc, NoteState > (
                      builder: (context, state) {
                        if (state is NoteLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is NoteLoaded) {
                          _searchResults = _filterNotes(state.notes);
                          if (!_isSearching) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search, size: 64, color: Colors.blue[200]),
                                  const SizedBox(height: 16),
                                    const Text(
                                      'Cari catatan apa?',
                                      style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                                    ),
                                ],
                              ),
                            );
                          }
                          if (_searchResults.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 64, color: Colors.red[200]),
                                  const SizedBox(height: 16),
                                    const Text(
                                      'Catatan tidak ditemukan',
                                      style: TextStyle(fontSize: 20, color: Colors.redAccent),
                                    ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.only(top: 1),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final note = _searchResults[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/detail',
                                      arguments: note,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                      child: SearchCard(
                                        title: Text(note.title),
                                        content: Text(
                                          note.description,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        date: note.deadline?.toString()?? "",
                                        owner : user?.displayName??'Anonymous',
                                        priority : note.priority??'',
                                        onInfo : () {},
                                      ),
                                  ),
                                );
                              },
                          );
                        } else if (state is NoteError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  )
              ],
            ),
        ),
      ),
    );
  }
}