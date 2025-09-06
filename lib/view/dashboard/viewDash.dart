import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // pour formater la date
import 'package:gestion_pharmacie_mobile/services/ApiService/venteService.dart';
import '../../ModelTampo/Vente.dart';
import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/Option.dart';
import '../../component/dashboard/Block.dart';
import '../vente/vendre.dart';
import '../lots/LotRegisterPage.dart';
import '../../services/GetStorage/LotStorage.dart';

class ViewDash extends StatefulWidget {
  @override
  State<ViewDash> createState() => _ViewDashState();
}

class _ViewDashState extends State<ViewDash> {
  List<Vente> Ventes = [];
  double montantVenduJour = 0.0;
  double montantVenduMois = 0.0;

  @override
  void initState() {
    super.initState();
    getVente();
  }

  Future<void> getVente() async {
    try {
      final ventesData = await VenteService().fetchVentes();

      double totalJour = 0.0;
      double totalMois = 0.0;
      DateTime today = DateTime.now();

      for (var vente in ventesData) {
        DateTime dateVente = DateTime.parse(vente.dateVente);
        double montant = double.tryParse(vente.montant_total) ?? 0.0;

        // Vérifie la vente du mois
        if (dateVente.year == today.year && dateVente.month == today.month) {
          totalMois += montant;

          // Vérifie la vente du jour
          if (dateVente.day == today.day) {
            totalJour += montant;
          }
        }
      }

      setState(() {
        Ventes = ventesData;
        montantVenduJour = totalJour;
        montantVenduMois = totalMois;
      });
    } catch (e) {
      print("Erreur lors de la récupération des ventes : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Appbar(Title: "Dashboard").lancer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bienvenu , Marien",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: screenWidth * 0.06,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Option(
                    src: 'assets/Icone/shopping-cart-add 5.png',
                    intitule: "Vente",
                    action: () {
                      print(LotStorage.getLots());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Vendre()),
                      );
                    },
                  ).lancer(),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Option(
                    src: 'assets/Icone/supplier-alt 1.png',
                    intitule: "Stock",
                    action: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddProduitPage()),
                      );
                    },
                  ).lancer(),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Option(
                    src: 'assets/Icone/inventaire-alternatif 1.png',
                    intitule: "Invent",
                    action: () {},
                  ).lancer(),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Option(
                    src: 'assets/Icone/traitement 1.png',
                    intitule: "Rapport",
                    action: () {},
                  ).lancer(),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),

            Row(
              children: [
                Expanded(
                  child: Block(
                    src: 'assets/Icone/traitement 1.png',
                    text: "Vente du jour",
                    montant: "${montantVenduJour.toStringAsFixed(2)} FC",
                    action: () {},
                  ).lancer(),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Block(
                    src: 'assets/Icone/supplier-alt 1.png',
                    text: "Vente du mois",
                    montant: "${montantVenduMois.toStringAsFixed(2)} FC",
                    action: () {},
                  ).lancer(),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),

            Row(
              children: [
                Icon(Icons.access_time, size: screenWidth * 0.06),
                SizedBox(width: 10),
                Text(
                  "Activité récentes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.045,
                  ),
                )
              ],
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color.fromRGBO(234, 234, 234, 1), width: 1),
              ),
              child: Ventes.isEmpty
                  ? Text("Aucune activité récente")
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: Ventes.length > 5 ? 5 : Ventes.length,
                itemBuilder: (context, index) {
                  final v = Ventes[index];
                  final date = DateFormat('dd/MM – HH:mm').format(DateTime.parse(v.dateVente));
                  return Text("$date · Vente · ${v.nom_client ?? 'Client'} · ${v.montant_total} FC");
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Bottomapp().lancer(),
    );
  }
}
