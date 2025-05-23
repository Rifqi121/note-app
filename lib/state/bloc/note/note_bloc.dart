import 'package:bloc/bloc.dart';
import 'package:note/models/note.dart';
import 'package:note/repositories/note_repository.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository repository;

  NoteBloc(this.repository) : super(NoteInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NoteLoading());
      await emit.forEach<List<Note>>(
        repository.getNotesStream(),
        onData: (notes) => NoteLoaded(notes),
        onError: (_, __) => NoteError("Failed to load notes."),
      );
    });

    on<AddNoteEvent>((event, emit) async {
      await repository.addNote(event.note);
    });

    on<UpdateNoteEvent>((event, emit) async {
      await repository.updateNote(event.note);
    });

    on<DeleteNoteEvent>((event, emit) async {
      await repository.deleteNote(event.id);
    });
  }
}

