import 'package:flutter/material.dart';

import '../../ModelTampo/Pharmacie.dart';
import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/LookPharma.dart';
import '../../component/Option.dart';
import '../../component/SeashBar.dart';
import '../../controller/LotController.dart';
import '../../controller/VenteController.dart';
import '../../model/userModel.dart';
import '../../services/ApiService/ApiPharmacie.dart';
import '../../services/GetStorage/Pharmacie.dart';
import '../../utils/navigation.dart';
import '../auth/ProfilPage.dart';
import '../dashboard/viewDash.dart';
import '../pharmacie/pharmacoePage.dart';

class Portail extends StatefulWidget {

  @override
  State<Portail> createState() => _PortailState();
}

class _PortailState extends State<Portail> {
  late Future<List<Pharmacie>> pharmaciesFuture;


  @override
  void initState() {
    super.initState();

    pharmaciesFuture = PharmacieService().fetchPharmaciesDuGerant(8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(Title: "Portail").lancer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                SeashBar().lancer(),
                Option(
                  src: 'assets/Icone/filter.png',
                  action: () {},
                ).lancer(),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Option(
                  src: 'assets/Icone/traitement 1.png',
                  intitule: "Pharma",
                  action: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreationComptePage(),
                      ),
                    );
                  },
                ).lancer(),
                SizedBox(width: 20),
                Option(
                  src: 'assets/Icone/userQ.png',
                  intitule: "User",
                  action: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  },
                ).lancer(),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Mes pharmacies",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

        Expanded(
          child: FutureBuilder<List<Pharmacie>>(
            future: pharmaciesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Affiche un indicateur de chargement centré
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Chargement des pharmacies...")
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                // Affiche l'erreur si elle existe
                return Center(
                  child: Text(
                    "Erreur lors du chargement : ${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Cas où il n'y a aucune donnée
                return const Center(
                  child: Text("Aucune pharmacie trouvée"),
                );
              }

              // Cas où les données sont disponibles
              final pharmacies = snapshot.data!;

              return ListView.builder(
                itemCount: pharmacies.length,
                itemBuilder: (context, index) {
                  Pharmacie pharma = pharmacies[index];
                  return LookPharma(
                    action: () async {
                      await PharmacieStorage.savePharmacie(pharma.id.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewDash(),
                        ),
                      );
                    },
                    title: pharma.nom,
                    subtitle: pharma.adresse,
                  ).lancer();
                },
              );
            },
          ),
        ),

          ],
        ),
      ),
      bottomNavigationBar: Bottomapp(
        onAccueil: (){
          goToPagePlacement(context,ViewDash());
        },
        onUser:() {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => ProfilePage(),
    ),
    );

        },).lancer(),
    );
  }
}
