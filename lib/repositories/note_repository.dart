import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/note.dart';

class NoteRepository {
  final db = FirebaseDatabase.instance.ref().child('notes');
  DatabaseReference get _userNotesRef {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User belum login');
    return FirebaseDatabase.instance.ref().child('notes').child(uid);
  }

  Stream<List<Note>> getNotesStream() {
    return _userNotesRef.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];
      return data.entries.map((e) {
        return Note.fromMap(Map<String, dynamic>.from(e.value), e.key);
      }).toList();
    });
  }

  Future<void> addNote(Note note) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final newRef = _userNotesRef.push();
    final newNote = note.copyWith(id: newRef.key, userId: uid);
    await newRef.set(newNote.toMap());
  }

  Future<void> updateNote(Note note) {
    return _userNotesRef.child(note.id).set(note.toMap());
  }

  Future<void> deleteNote(String id) {
    return _userNotesRef.child(id).remove();
  }
}
