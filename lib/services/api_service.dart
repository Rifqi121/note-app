import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/note.dart';

class PostApi {
  Future<List<Note>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Note.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
