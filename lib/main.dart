import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/view/principal/portail.dart';
import 'component/LookPharma.dart';
import 'component/Option.dart';
import 'component/SeashBar.dart';
import 'leyouts/principal.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Portail(),
    );
  }
}
