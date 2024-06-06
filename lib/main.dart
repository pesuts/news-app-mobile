import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';
import 'package:project_praktikum/views/auth/Login.dart';
import 'package:project_praktikum/views/HomeNews.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// ...
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  var box = await Hive.openBox('sibas');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIBAS News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      // future: FirebaseAuth.instance.currentUser,
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return HomeNews();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
