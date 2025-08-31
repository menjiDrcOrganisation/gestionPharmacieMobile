import 'package:flutter/material.dart';

import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/LookPharma.dart';
import '../../component/Option.dart';
import '../../component/SeashBar.dart';
import '../dashboard/viewDash.dart';
import '../pharmacie/pharmacoePage.dart';

class Portail extends StatefulWidget {

  @override
  State<Portail> createState() => _PortailState();
}

class _PortailState extends State<Portail> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(Title: "Portail").lancer(),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [

            SizedBox(height: 20),
            Row(
              children: [
                SeashBar().lancer(),
                Option(
                    src: 'assets/Icone/filter.png',
                    action: (){
                    }).lancer()
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Option(
                    src: 'assets/Icone/traitement 1.png',
                    intitule: "Pharma",
                    action: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreationComptePage(), // ta page cible
                        ),
                      );
                    }).lancer(),
                SizedBox(width: 20),
                Option(
                    src: 'assets/Icone/userQ.png',
                    intitule: "User",
                    action: (){
                    }).lancer()
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Mes pharmacies",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ) ,
                )
              ],
            ),

            SizedBox(height: 10),

            Column(
              children: [
                LookPharma(
                  action: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewDash(), // ta page cible
                      ),
                    );

                  }
                ).lancer(),
                LookPharma(
                    action: (){
                    }
                ).lancer()
              ],
            )
          ],
        ) ,),
      bottomNavigationBar:Bottomapp().lancer() ,
    );
  }
}
