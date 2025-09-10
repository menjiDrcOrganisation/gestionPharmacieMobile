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
  double leftPosition = 0;

  Color Coloraction=Colors.black12;

  @override
  void initState() {
    super.initState();
    pharmaciesFuture = PharmacieService().fetchPharmaciesDuGerant(8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(Title: "Portail").lancer(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 20),
            // CORRECTION: Utilisation de IntrinsicHeight pour uniformiser la hauteur
            IntrinsicHeight(
              child: Row(
                children: [
                  // Barre de recherche avec contrainte de largeur
                  Expanded(
                    flex: 5,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      child: SeashBar().lancer(),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Bouton filtre avec taille fixe
                  Container(
                    width: 50,
                    height: 50,
                    child: Option(
                      src: 'assets/Icone/filter.png',
                      action: () {},
                    ).lancer(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Options Pharma et User - CORRECTION: Utilisation de MainAxisAlignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Option(
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
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Option(
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
                ),
              ],
            ),
            SizedBox(height: 10),


          // Titre "Mes pharmacies"
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mes pharmacies",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: 200, // largeur du widget glissable
                  child: Dismissible(
                    key: Key("unique"),
                    direction: DismissDirection.horizontal, // glisser de droite à gauche
                    background:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Coloraction,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            Container(
                              color: Coloraction,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.update, color: Colors.white),
                            )

                          ],
                        )

                  ,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {

                        // glissé vers la droite (côté gauche)
                        print("Action gauche déclenchée !");
                      } else if (direction == DismissDirection.endToStart) {
                        // glissé vers la gauche (côté droit)

                        print("Action droite déclenchée !");
                      }
                      // Ici tu peux faire ce que tu veux
                    },
                    child: Container(
                      height: 60,
                      color: Colors.green,
                      alignment: Alignment.center,
                      child: Text("Glisserd moi"),
                    ),
                  ),
                ),
              ],
            ),

            // Liste des pharmacies
            Expanded(
              child: FutureBuilder<List<Pharmacie>>(
                future: pharmaciesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                    return Center(
                      child: Text(
                        "Erreur lors du chargement : ${snapshot.error}",
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Aucune pharmacie trouvée"),
                    );
                  }

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
        onAccueil: () {
          goToPagePlacement(context, ViewDash());
        },
        onUser: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ),
          );
        },
      ).lancer(),
    );
  }
}