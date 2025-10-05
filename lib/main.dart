import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/services/ApiService/ApiServiceLotTampo.dart';


import 'package:gestion_pharmacie_mobile/services/GetStorage/expiration_medicament.dart';
import 'package:gestion_pharmacie_mobile/utils/NotificationPush.dart';
import 'package:gestion_pharmacie_mobile/view/auth/LoginPage.dart';
import 'ModelTampo/Lot.dart';


final notificationPush = NotificationPush();

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation des notifications
  await notificationPush.init();

  // Vérification périodique tous les 5s
  Timer.periodic(const Duration(seconds: 10), (timer) async {

    List<Lot> lots = await LotService().fetchLots();

    for (var lot in lots) {
      final dateExp = DateTime.parse(lot.dateExpiration);

      print(lot.dateExpiration);

      // Vérifier si proche de l'expiration
      if (ExpirationMedicamentStorage.isNearExpiration(dateExp, daysBefore: 15)) {

        // Récupérer les lots déjà notifiés
        List<Lot> notifiedLots = await ExpirationMedicamentStorage.getExpiringLots();
        bool alreadyNotified = notifiedLots.any((l) => l.numeroLot == lot.numeroLot);

        if (!alreadyNotified) {
          // Calcul des jours restants
          int jr = ExpirationMedicamentStorage.joursRestants(dateExp);

          // Afficher notification
          await notificationPush.showNotification(
            medicament:
            "lot :${lot.numeroLot}, ${lot.medicament.nom}_${lot.medicament.forme.nom}_${lot.medicament.dose.quantite}_${lot.medicament.dose.unite}",
            jourRestants: jr.toString(),
          );

          // Ajouter le lot au storage pour ne plus notifier
          await ExpirationMedicamentStorage.addExpiringLot(lot);
        }
      }
    }
  });

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
