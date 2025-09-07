import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/view/auth/LoginPage.dart';
import 'package:gestion_pharmacie_mobile/view/auth/ProfilPage.dart';
import 'package:gestion_pharmacie_mobile/view/lots/MedicamentLotsPage.dart';
import 'package:gestion_pharmacie_mobile/view/principal/portail.dart';

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
