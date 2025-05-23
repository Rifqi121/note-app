import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/di.dart';
import 'package:note/screen/detail_page.dart';
import 'package:note/screen/edit_page.dart';
import 'package:note/screen/home_screen.dart';
import 'package:note/screen/login.dart';
import 'package:note/screen/navigation/navigation_bar.dart';
import 'package:note/screen/register.dart';
import 'package:note/screen/splash_screen.dart';
import 'package:note/state/bloc/auth/auth_bloc.dart';
import 'package:note/state/bloc/auth/auth_event.dart';
import 'package:note/state/bloc/note/note_bloc.dart';
import 'package:note/state/cubit/notes_cubit.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotesCubit()..loadNotes()),
        BlocProvider(create: (_) => AuthBloc()..add(AppStarted())),
        BlocProvider<NoteBloc>(create: (context) => getIt<NoteBloc>())
      ],
      child: MaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/main',
        routes: {
          '/main': (context) => MainNavigation(),
          '/': (context) => LoginPage(),
          '/splash': (context) => const SplashScreen(),
          '/detail': (context) => const DetailPage(),
          '/edit': (context) => const EditPage(),
          '/home': (context) => const HomeScreen(),
          '/register': (context) => RegisterPage(),
        },
      ),
    );
  }
}
