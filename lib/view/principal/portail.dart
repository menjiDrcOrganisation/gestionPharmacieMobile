import 'package:flutter/material.dart';

import '../../ModelTampo/Pharmacie.dart';
import '../../component/AppBar.dart';
import '../../component/AppBarTest.dart';
import '../../component/BottomApp.dart';
import '../../component/LookPharma.dart';
import '../../component/Option.dart';
import '../../component/SeashBar.dart';
import '../../controller/LotController.dart';
import '../../controller/PharmacieController.dart';
import '../../controller/VenteController.dart';
import '../../model/userModel.dart';
import '../../services/ApiService/ApiPharmacie.dart';
import '../../services/GetStorage/Pharmacie.dart';
import '../../utils/navigation.dart';
import '../auth/ProfilPage.dart';
import '../dashboard/viewDash.dart';
import '../pharmacie/Setting.dart';
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
      appBar: AppbarTest(title: "Portail").lancer(context),
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
                        viewSetting: ()async{
                          Pharmacie p= await ControllerPharmacie.showPhramacie(pharma.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Setting(pharmacie: p,),
                            ),
                          );

                        },
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