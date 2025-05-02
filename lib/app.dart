import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/screen/detail_page.dart';
import 'package:note/screen/edit_page.dart';
import 'package:note/screen/navigation/navigation_bar.dart';
import 'package:note/screen/second_screen.dart';
import 'package:note/screen/splash_screen.dart';
import 'package:note/screen/third_screen.dart';
import 'package:note/state/cubit/notes_cubit.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotesCubit()..loadNotes(),
      child: MaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainNavigation(),       // Navigasi utama dengan bottom nav bar
          '/splash': (context) => const SplashScreen(),
          '/second': (context) => SecondScreen(),
          '/third': (context) => ThirdScreen(),
          '/detail': (context) => const DetailPage(),
          '/edit': (context) => const EditPage(),
        },
      ),
    );
  }
}
