import 'package:flutter/material.dart';

class tableau {
  Widget lancer() {
    return Table(
       // bordures du tableau
      columnWidths: const {
        0: FlexColumnWidth(2), // largeur relative de la 1ère colonne
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        // Ligne d'en-tête
        TableRow(
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("Nom produit", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("Qté", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("Prix", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const TableRow(
          children: [
            Divider(thickness: 1, color: Colors.grey),
            Divider(thickness: 1, color: Colors.grey),
            Divider(thickness: 1, color: Colors.grey),
          ],
        ),
        // Ligne 1
        const TableRow(
          children: [
            Padding(padding: EdgeInsets.all(8), child: Text("Paracétamol 500")),
            Padding(padding: EdgeInsets.all(8), child: Text("80")),
            Padding(padding: EdgeInsets.all(8), child: Text("2000 FC")),
          ],
        ),
        const TableRow(
          children: [
            Divider(thickness: 1, color: Colors.grey),
            Divider(thickness: 1, color: Colors.grey),
            Divider(thickness: 1, color: Colors.grey),
          ],
        ),

        // Ligne 2
        const TableRow(
          children: [
            Padding(padding: EdgeInsets.all(8), child: Text("Ibuprofène 200")),
            Padding(padding: EdgeInsets.all(8), child: Text("120")),
            Padding(padding: EdgeInsets.all(8), child: Text("3500 FC")),
          ],
        ),
      ],
    );
  }
}
