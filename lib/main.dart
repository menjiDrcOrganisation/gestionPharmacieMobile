import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/route/router.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  runApp(const MyApp());
}


int joursRestants(DateTime dateExpiration) {
  return dateExpiration.difference(DateTime.now()).inDays;
}

bool isNearExpiration(DateTime dateExpiration, {int daysBefore = 15}) {
  final diff = joursRestants(dateExpiration);
  return diff <= daysBefore && diff>=0;
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
      ),
    );
  }
}
