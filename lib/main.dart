import 'package:flutter/material.dart';
import 'component/Option.dart';
import 'leyouts/SeashBar.dart';
import 'leyouts/principal.dart'; // <-- importe ton fichier LayoutPrincipal

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // pour enlever le bandeau debug
      title: 'Prod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LayoutPrincipal(
        titre: "Portail",   // 👈 donnée injectée
        compteurInitial: 5,
        contenu:Row(
          children: [

            SeashBar().lancer(),
            Option(
                icon: Icons.access_time_rounded,
            intitule:"hello",
                action: (){
            }).lancer()
          ],
        ), // 👈 donnée injectée
      ),
    );
  }
}
