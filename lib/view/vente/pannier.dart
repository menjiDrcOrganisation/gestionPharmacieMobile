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
      appBar: Appbar(Title: "Espace vente").lancer(),
      body:Stack(
        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: screenHeight * 0.05,
                width: double.infinity,
                color:ColorsApp.primaryColor,
              ),
              Container(
                width: double.infinity,
                height: screenHeight * 0.020,
                color:ColorsApp.primaryColor,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.8,
                width: screenWidth * 0.9,
                child:Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),

                      ),
                      alignment: Alignment.center,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          tableau().lancer()
                        ],
                      ),
                    ),
                Positioned(
                    bottom: screenHeight * 0.10, // distance du bas
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Button(
                          intitule: "Valider",
                          colorButton:ColorsApp.primaryColor,
                      colorText: Colors.white)
                          .lancer(),

                      Button(
                          intitule: "Annuller",
                          colorButton:Color.fromRGBO(217, 217, 217, 1)
                      ).lancer()
                    ],
                  ) )
                  ],
                ) ,
              )
              ,
            ],
          )
        ],
      )
      ,
      bottomNavigationBar:Bottomapp().lancer() ,
    );
  }
}
