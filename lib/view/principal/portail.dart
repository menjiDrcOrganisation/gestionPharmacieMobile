import 'package:flutter/material.dart';
import '../../ModelTampo/Pharmacie.dart';
import '../../component/AppBarTest.dart';
import '../../component/Colors.dart';
import '../../component/LookPharma.dart';
import '../../controller/PharmacieController.dart';
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
  List<Pharmacie> allPharmacies = [];       // toutes les pharmacies récupérées
  List<Pharmacie> filteredPharmacies = [];  // liste filtrée selon la recherche

  TextEditingController recherche = TextEditingController();

  @override
  void initState() {
    super.initState();
    pharmaciesFuture = PharmacieService().fetchPharmaciesDuGerant();

    // Quand le Future se termine, on initialise les deux listes
    pharmaciesFuture.then((list) {
      setState(() {
        allPharmacies = list;
        filteredPharmacies = list;
      });
    });
  }

  void updateSearch(String query) {
    setState(() {
      filteredPharmacies = allPharmacies.where((pharma) {
        final nameLower = pharma.nom.toLowerCase();
        final addressLower = pharma.adresse.toLowerCase();
        final searchLower = query.toLowerCase();

        // recherche par nom OU adresse
        return nameLower.contains(searchLower) || addressLower.contains(searchLower);
      }).toList();
    });
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
              // Champ recherche
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: recherche,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelText: "Rechercher une pharmacie",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onChanged: updateSearch,
                ),
              ),
              SizedBox(height: 10),
              // Titre
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
              // Liste filtrée
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
                    } else if (filteredPharmacies.isEmpty) {
                      return const Center(
                        child: Text("Aucune pharmacie trouvée"),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredPharmacies.length,
                      itemBuilder: (context, index) {
                        Pharmacie pharma = filteredPharmacies[index];
                        return LookPharma(
                          context: context,
                          viewSetting: () async {
                            Pharmacie p = await ControllerPharmacie.showPhramacie(pharma.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Setting(pharmacie: p),
                              ),
                            );
                          },
                          action: () async {
                            await PharmacieStorage.savePharmacie(pharma.id.toString(),pharma.indice.toString());
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
      ),
      floatingActionButton: SizedBox(
        width: 52,
        height: 52,
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            goToPagePlacement(context, CreationComptePage());
          },
          backgroundColor: MyColors.primary,
          child: Icon(Icons.add, size: 32, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 200,
        shadowColor: Colors.black,
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Image.asset("assets/Icone/accueil.png"),
                onPressed: () {},
              ),
              SizedBox(width: 40), // espace pour le FAB
              IconButton(
                icon: Image.asset("assets/Icone/user.png"),
                onPressed: () {
                  goToPagePlacement(context, ProfilePage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
