import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/view/auth/LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prod',
      theme: ThemeData(
        fontFamily: "Roboto",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Loginpage(),
    );
  }
}
