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
    return Scaffold(
      appBar: Appbar(Title: "Dashboard").lancer(),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(height: 20),
                Text("Bienvenu , Marien",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ) ,
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Option(
                    src: 'assets/Icone/userQ.png',
                    intitule: "User",
                    action: (){
                    }).lancer(),
                Option(
                    src: 'assets/Icone/userQ.png',
                    intitule: "User",
                    action: (){
                    }).lancer(),
                Option(
                    src: 'assets/Icone/userQ.png',
                    intitule: "User",
                    action: (){
                    }).lancer()
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Block(
                    src: 'assets/Icone/traitement 1.png',
                    text:"vente du jour",
                    montant: "20 000 FC",
                    action: (){
                    }).lancer(),
                Block(
                    src: 'assets/Icone/traitement 1.png',
                    text:"vente du mois",
                    montant: "16 000 FC",
                    action: (){
                    }).lancer(),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 10),

                Text("Activité recentes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ))
              ],
            )
            ,
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color.fromRGBO(234, 234, 234, 1), // couleur de la bordure
                    width: 1,            // épaisseur de la bordure
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
              ) ,
            )



          ],
        ) ,),
      bottomNavigationBar:Bottomapp().lancer() ,
    );
  }
}
