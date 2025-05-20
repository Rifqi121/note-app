import 'package:get_it/get_it.dart';
import 'package:note/services/api_service.dart';
import 'package:note/services/post_repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => PostApi());
  getIt.registerLazySingleton(() => PostRepository(getIt<PostApi>()));
}
