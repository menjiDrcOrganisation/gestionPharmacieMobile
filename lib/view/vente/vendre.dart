import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/view/vente/pannier.dart';

import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/Colors.dart';
import '../../component/Combobox.dart';
import '../../component/LookPharma.dart';
import '../../component/Option.dart';
import '../../component/SeashBar.dart';
import '../../component/vente/Prix.dart';
import '../layouts/StructurePage.dart';

class Vendre extends StatefulWidget {
  @override
  State<Vendre> createState() => _VendreState();
}

class _VendreState extends State<Vendre> {
  String selected = "Option 1";

  @override
  Widget build(BuildContext context) {
    // Récupérer les dimensions de l'écran
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Appbar(Title: "Espace vente").lancer(),
      body: StructurePage(
          contentBack:InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Pannier(), // ta page cible
                ),
              );
            },
            child:Container(
              height: screenWidth * 0.13,
              width: screenWidth * 0.13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                color: MyColors.primaryColor,
              ),
              child: Icon(Icons.add, color: Colors.white, size: screenWidth * 0.1),
            ) ,
          ) ,
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              buildComboBox(
                title: "Nom du produit",
                items: ["Option 1", "Option 2", "Option 3"],
                placeholder: "Choisissez un produit",
                onChanged: (value) {
                  setState(() {
                    selected = value!;
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Expanded(
                    child: buildComboBox(
                      title: "Forme",
                      items: ["Option 1", "Option 2", "Option 3"],
                      placeholder: "Choisissez une forme",
                      onChanged: (value) {
                        setState(() {
                          selected = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: buildComboBox(
                      title: "Dose",
                      items: ["Option 1", "Option 2", "Option 3"],
                      placeholder: "Choisissez une dose",
                      onChanged: (value) {
                        setState(() {
                          selected = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Quantite"),
                      Text("0-100"),
                    ],
                  ),
                  Slider(
                    value: 2,
                    onChanged: (double value) {},
                    max: 10,
                    min: 2,
                    thumbColor: MyColors.primaryColor,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Prix().lancer(),
              SizedBox(height: screenHeight * 0.02),
              Prix().lancer(),
            ],
          )
      ).lancer(),
      bottomNavigationBar: Bottomapp().lancer(),
    );
  }
}
