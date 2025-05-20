import 'package:note/models/note.dart';

abstract class PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Note> posts;
  PostLoaded(this.posts);
}

class PostError extends PostState {}
