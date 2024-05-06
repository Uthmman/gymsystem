import 'package:flutter/material.dart';
import 'package:gymsystem/constants.dart';
// import 'package:gymsystem/helper/db_helper.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'Pages/nav_layout.dart';

void main() async {
  // sqfliteFfiInit();

  // databaseFactory = databaseFactoryFfi;
  // WidgetsFlutterBinding.ensureInitialized();
  // await DatabaseHelper().initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: mainBoldColor,
        ),
      ),
      home: const NavigationLayout(),
    );
  }
}
