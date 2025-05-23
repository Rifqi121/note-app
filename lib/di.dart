import 'package:get_it/get_it.dart';
import 'package:note/repositories/auth_repository.dart';
import 'package:note/repositories/note_repository.dart';
import 'package:note/state/bloc/note/note_bloc.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepository());
  getIt.registerLazySingleton<NoteRepository>(() => NoteRepository());
  getIt.registerFactory(() => NoteBloc(getIt<NoteRepository>()));
}
