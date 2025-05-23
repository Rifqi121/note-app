import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:note/di.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}
