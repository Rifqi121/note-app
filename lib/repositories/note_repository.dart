import 'package:firebase_database/firebase_database.dart';
import '../models/note.dart';

class NoteRepository {
  final db = FirebaseDatabase.instance.ref().child('notes');

  Stream<List<Note>> getNotesStream() {
    return db.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];
      return data.entries.map((e) {
        return Note.fromMap(Map<String, dynamic>.from(e.value), e.key);
      }).toList();
    });
  }

  Future<void> addNote(Note note) {
    final newRef = db.push();
    return newRef.set(note.toMap());
  }

  Future<void> updateNote(Note note) {
    return db.child(note.id).set(note.toMap());
  }

  Future<void> deleteNote(String id) {
    return db.child(id).remove();
  }
}
