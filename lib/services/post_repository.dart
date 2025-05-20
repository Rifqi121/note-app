import 'package:note/models/note.dart';
import 'package:note/services/api_service.dart';

class PostRepository {
  final PostApi api;

  PostRepository(this.api);

  Future<List<Note>> getPosts() async {
    return await api.fetchPosts();
  }
}
