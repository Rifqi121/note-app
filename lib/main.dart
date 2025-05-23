import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:note/di.dart';
import 'package:note/service/firebase_service.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null); 
  await Firebase.initializeApp(
    name: 'notes-pbi',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseService.initNotifications();

  final token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");

  runApp(const MainApp());
}
