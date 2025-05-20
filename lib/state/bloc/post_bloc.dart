import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/services/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc(this.repository) : super(PostLoading()) {
    on<FetchPosts>((event, emit) async {
      emit(PostLoading());
      try {
        final posts = await repository.getPosts();
        emit(PostLoaded(posts));
      } catch (_) {
        emit(PostError());
      }
    });
  }
}
