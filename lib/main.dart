// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_n_one/auth/login.dart';
import 'package:project_n_one/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyA6lWFBCvb86NiJobiUHFThNmD3eCdDEc8",
          authDomain: "project-n-m.firebaseapp.com",
          projectId: "project-n-m",
          storageBucket: "project-n-m.appspot.com",
          messagingSenderId: "554693500173",
          appId: "1:554693500173:web:982199658722dbbc9ae444",
          measurementId: "G-Q95H1Z0L02"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        {
          print('User is currently signed out!');
        }
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 223, 218, 218),
        iconTheme: IconThemeData(
          color: Colors.red,
        ),
        titleTextStyle: TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
      )),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage()
          : LoginPage(),
    );
  }
}
