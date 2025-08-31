import 'package:flutter/material.dart';
import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/LookPharma.dart';
import '../../component/Option.dart';
import '../../component/SeashBar.dart';
import '../../component/dashboard/Block.dart';

class ViewDash extends StatefulWidget {
  @override
  State<ViewDash> createState() => _ViewDashState();
}

class _ViewDashState extends State<ViewDash> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer la taille de l’écran
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
                    action: () {},
                  ).lancer(),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Option(
                    src: 'assets/Icone/supplier-alt 1.png',
                    intitule: "Stock",
                    action: () {},
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
                    montant: "20 000 FC",
                    action: () {},
                  ).lancer(),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Block(
                    src: 'assets/Icone/supplier-alt 1.png',
                    text: "Vente du mois",
                    montant: "16 000 FC",
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
                border: Border.all(
                  color: Color.fromRGBO(234, 234, 234, 1),
                  width: 1,
                ),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Text("05/08 – 14h35 · Vente · Paracétamol 500mg · 3 u · 3 600 FC"),
                  Text("05/08 – 14h35 · Vente · Paracétamol 500mg · 3 u · 3 600 FC"),
                  Text("05/08 – 14h35 · Vente · Paracétamol 500mg · 3 u · 3 600 FC")
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Bottomapp().lancer(),
    );
  }
}
