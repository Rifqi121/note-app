import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note/state/bloc/auth/auth_bloc.dart';
import 'package:note/state/bloc/auth/auth_event.dart';
import 'package:note/state/bloc/auth/auth_state.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthBloc authBloc;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authBloc = AuthBloc(firebaseAuth: mockFirebaseAuth);
  });

  group('AuthBloc', () {
    final email = 'test@example.com';
    final password = 'password123';
    final nama = 'Test User';
    final mockUser = MockUser();
    final mockUserCredential = MockUserCredential();

    setUpAll(() {
      registerFallbackValue(MockUser());
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [Authenticated] when AppStarted and user is logged in',
      build: () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [Authenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Unauthenticated] when AppStarted and no user',
      build: () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);
        return authBloc;
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [Unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when LoggedIn succeeds',
      build: () {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .thenAnswer((_) async => mockUserCredential);
        return authBloc;
      },
      act: (bloc) => bloc.add(LoggedIn(email, password)),
      expect: () => [AuthLoading(), Authenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError, Unauthenticated] when LoggedIn fails',
      build: () {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'user-not-found', message: 'No user found'));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoggedIn(email, password)),
      expect: () => [
        AuthLoading(),
        isA<AuthError>(),
        Unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when Registered succeeds',
      build: () {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password))
          .thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.updateProfile(displayName: nama)).thenAnswer((_) async {});
        when(() => mockUser.reload()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(Registered(email, password, nama)),
      expect: () => [AuthLoading(), Authenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError, Unauthenticated] when Registered fails',
      build: () {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'weak-password', message: 'Weak password'));
        return authBloc;
      },
      act: (bloc) => bloc.add(Registered(email, password, nama)),
      expect: () => [
        AuthLoading(),
        isA<AuthError>(),
        Unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Unauthenticated] when LoggedOut',
      build: () {
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(LoggedOut()),
      expect: () => [Unauthenticated()],
    );
  });
}