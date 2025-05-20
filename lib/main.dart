import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:note/di.dart';
import 'app.dart';

void main() async{
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null); 
  runApp(const MainApp());
}
