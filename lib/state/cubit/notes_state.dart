part of 'notes_cubit.dart';

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

final class NotesInitial extends NotesState {}

class NotesLoaded extends NotesState{
  final List<Post> notes;
  const NotesLoaded(this.notes);

  @override
  List<Object>get props => [notes];
}
