import 'package:flutter/material.dart';

import '../../ModelTampo/Pharmacie.dart';
import '../../component/AppBar.dart';
import '../../component/AppBarTest.dart';
import '../../component/BottomApp.dart';
import '../../component/Colors.dart';
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
      body: Container(
        color: Colors.white38,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true, // active le fond coloré
                    fillColor: Colors.grey[200],
                    labelText: "Rechercher une pharmacie",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,

                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onChanged: (query) {
                  },
                ),
              ),
              SizedBox(height: 10),
            // Titre "Mes pharmacies"
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mes pharmacies",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 23,
                    ),
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
                    return Container(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: pharmacies.length,
                        itemBuilder: (context, index) {
                          Pharmacie pharma = pharmacies[index];
                          return LookPharma(
                            context: context,
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
        floatingActionButton: SizedBox(
          width: 52,
          height: 52,
          child: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              goToPagePlacement(context,CreationComptePage());
            },
            backgroundColor: MyColors.primary,
            child: Icon(Icons.add, size: 32,color: Colors.white,),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // arrondi perso
              )
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // BottomAppBar
        bottomNavigationBar: BottomAppBar(


          elevation: 10,
          shape: CircularNotchedRectangle(),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Image.asset("assets/Icone/accueil.png"),
                  onPressed: () {
                  },
                ),
                SizedBox(width: 40), // espace pour le FAB
                IconButton(
                  icon: Image.asset("assets/Icone/user.png"),
                  onPressed: () {
                  },
                ),
              ],
            ),
          ),
        )

    );
  }
}

Widget navItem({required IconData icon, required String label}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, size: 24, color: Colors.black),
      SizedBox(height: 2),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.black),
      ),
    ],
  );
}