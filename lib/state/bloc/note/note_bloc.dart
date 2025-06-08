import 'package:bloc/bloc.dart';
import 'package:note/models/note.dart';
import 'package:note/repositories/note_repository.dart';
import 'package:note/service/firebase_service.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository repository;

  NoteBloc(this.repository) : super(NoteInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NoteLoading());
      try{
      await emit.forEach<List<Note>>(
        repository.getNotesStream(),
        onData: (notes) => NoteLoaded(notes),
        onError: (_, __) => NoteError("Failed to load notes."),
      );
      } catch (e) {
      emit(NoteError("Gagal menambahkan catatan: $e"));
    }
    });

    on<AddNoteEvent>((event, emit) async {
    try{
      await repository.addNote(event.note);

      await FirebaseService.showNotification(
        "Catatan Baru",
        "Catatan baru telah berhasil ditambahkan!",
      );
    } catch (e) {
      emit(NoteError("Gagal menambahkan catatan: $e"));
    }

    });

    on<UpdateNoteEvent>((event, emit) async {
      try {
        await repository.updateNote(event.note);
        await FirebaseService.showNotification(
          "Catatan Update",
          "Catatan telah berhasil diubah!",
        );
        add(LoadNotes());
      } catch (e) {
        emit(NoteError("Gagal memperbarui catatan: $e"));
      }
    });

    on<DeleteNoteEvent>((event, emit) async {
      try {
        await repository.deleteNote(event.id);
      } catch (e) {
        emit(NoteError("Gagal menghapus catatan: $e"));
      }
    });
  }
}

