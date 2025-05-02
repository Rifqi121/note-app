import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/post.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  void loadNotes() {
    // Simulasi data dummy
    final dummyNotes = [
      Post(userId: 1, id: 1, title: 'Catatan 1', body: 'Isi catatan pertama', createAt: '01-05-2025'),
      Post(userId: 1, id: 2, title: 'Catatan 2', body: 'Isi catatan kedua', createAt: '02-05-2025'),
    ];
    emit(NotesLoaded(List.from(dummyNotes)));
  }

  void addNote(Post post) {
    if (state is NotesLoaded) {
      final updatedNotes = List<Post>.from((state as NotesLoaded).notes)..add(post);
      emit(NotesLoaded(updatedNotes));
    }
  }

  void updateNote(Post updatedPost) {
    if (state is NotesLoaded) {
      final notes = (state as NotesLoaded).notes;
      final updatedNotes = notes.map((note) {
        return note.id == updatedPost.id ? updatedPost : note;
      }).toList();
      emit(NotesLoaded(updatedNotes));
    }
  }

  void deleteNote(int id) {
    if (state is NotesLoaded) {
      final updatedNotes = (state as NotesLoaded)
          .notes
          .where((note) => note.id != id)
          .toList();
      emit(NotesLoaded(updatedNotes));
    }
  }
}
