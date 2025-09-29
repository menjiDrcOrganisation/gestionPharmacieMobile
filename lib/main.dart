import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/services/GetStorage/LotStorage.dart';
import 'package:gestion_pharmacie_mobile/utils/NotificationPush.dart';
import 'package:gestion_pharmacie_mobile/view/auth/LoginPage.dart';
import 'ModelTampo/Lot.dart';

final notificationPush = NotificationPush();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation des notifications
  await notificationPush.init();

  // Vérification périodique tous les 5s
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    List<Lot> lots = await LotStorage.getLots();
    for (var medoc in lots) {
      if (isNearExpiration(DateTime.parse(medoc.dateExpiration))) {
        int jr = joursRestants(DateTime.parse(medoc.dateExpiration));
        await notificationPush.showNotification(
          medicament:
          "${medoc.medicament.nom}_${medoc.medicament.forme.nom}_${medoc.medicament.dose.quantite}_${medoc.medicament.dose.unite}",
          jourRestants: jr.toString(),
        );
      }
    }
  });
  runApp(const MyApp());
}


int joursRestants(DateTime dateExpiration) {
  return dateExpiration.difference(DateTime.now()).inDays;
}

bool isNearExpiration(DateTime dateExpiration, {int daysBefore = 7}) {
  final diff = joursRestants(dateExpiration);
  return diff <= daysBefore;
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
      home: const Loginpage(),
    );
  }
}
