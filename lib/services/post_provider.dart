import 'package:http/http.dart' as http;
import 'package:note/models/note.dart';

class PostProvider {
  Future<List<Note>> fetchPosts() async {
    // Simulasi fetch data dari API
    await Future.delayed(Duration(seconds: 2));
    // Ganti dengan fetch dari API sebenarnya
    return [
      Note(userId: 1, id: 1, title: 'Catatan 1', body: 'Isi catatan pertama'),
      Note(userId: 1, id: 2, title: 'Catatan 2', body: 'Isi catatan kedua'),
    ];
  }

  Future<void> deletePost(int postId) async {
    final response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus post');
    }
  }
}