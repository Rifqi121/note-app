import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:note/models/note.dart';
import 'package:note/repositories/note_repository.dart';
import 'package:note/state/bloc/note/note_bloc.dart';

class MockNoteRepository extends Mock implements NoteRepository {}
class FakeNote extends Fake implements Note {}

void main() {
  late MockNoteRepository mockRepository;

  setUp(() {
    mockRepository = MockNoteRepository();
  });

  group('NoteBloc', () {
    final note = Note(
      id: '1',
      title: 'Test Title',
      description: 'Test Content',
    );

    setUpAll(() {
      registerFallbackValue(FakeNote());
    });

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NoteLoaded] when LoadNotes is added and repository returns notes',
      build: () {
        when(() => mockRepository.getNotesStream())
            .thenAnswer((_) => Stream.value([note]));
        return NoteBloc(mockRepository);
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [
        isA<NoteLoading>(),
        isA<NoteLoaded>().having((s) => s.notes, 'notes', [note])
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'emits NoteError when repository throws on getNotesStream',
      build: () {
        when(() => mockRepository.getNotesStream())
            .thenThrow(Exception('error'));
        return NoteBloc(mockRepository);
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [
        isA<NoteLoading>(),
        isA<NoteError>(),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'calls repository.addNote on AddNoteEvent',
      build: () {
        when(() => mockRepository.addNote(any())).thenAnswer((_) async {});
        return NoteBloc(mockRepository);
      },
      act: (bloc) => bloc.add(AddNoteEvent(note)),
      verify: (_) {
        verify(() => mockRepository.addNote(note)).called(1);
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits NoteError on AddNoteEvent when repository throws',
      build: () {
        when(() => mockRepository.addNote(any()))
            .thenThrow(Exception('error'));
        return NoteBloc(mockRepository);
      },
      act: (bloc) => bloc.add(AddNoteEvent(note)),
      expect: () => [
        isA<NoteError>(),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'emits NoteError on UpdateNoteEvent when repository throws',
      build: () {
        when(() => mockRepository.updateNote(any()))
            .thenThrow(Exception('error'));
        return NoteBloc(mockRepository);
      },
      act: (bloc) => bloc.add(UpdateNoteEvent(note)),
      expect: () => [
        isA<NoteError>(),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'emits NoteError on DeleteNoteEvent when repository throws',
      build: () {
        when(() => mockRepository.deleteNote(any()))
            .thenThrow(Exception('error'));
        return NoteBloc(mockRepository);
      },
      act: (bloc) => bloc.add(DeleteNoteEvent('1')),
      expect: () => [
        isA<NoteError>(),
      ],
    );
  });
}