import 'package:flutter/material.dart';

import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/Button.dart';
import '../../component/Colors.dart';
import '../../component/Combobox.dart';
import '../../component/LookPharma.dart';
import '../../component/Option.dart';
import '../../component/SeashBar.dart';
import '../../component/vente/Prix.dart';
import '../../component/vente/Table.dart';
import '../layouts/StructurePage.dart';

class Pannier extends StatefulWidget {

  @override
  State<Pannier> createState() => _PannierState();
}

class _PannierState extends State<Pannier> {
  String selected = "Option 1";

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Appbar(Title: "Espace Panier").lancer(),
      body:StructurePage(
        contentBack: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Button(
              intitule: "Valider",
              colorText: Colors.white,
              colorButton: ColorsApp.primaryColor
            ).lancer(),
            Button(
                intitule: "Annuler"
            ).lancer()
          ],
        ),
          screenHeight: screenHeight,
          sizeContent: 0.78,
          screenWidth: screenWidth,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              tableau().lancer()
            ],
          )
      ).lancer()
      ,
      bottomNavigationBar:Bottomapp().lancer() ,
    );
  }
}
