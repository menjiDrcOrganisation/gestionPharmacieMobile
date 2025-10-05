import 'package:flutter/material.dart';
import '../../component/AppBarTest.dart';
import '../../component/Colors.dart';
import '../../component/rapport/cardBlock.dart';
import '../../controller/Rapport_vente_controller.dart';
import '../../model/RapportVente.dart';
import '../dashboard/viewDash.dart';

class ViewRapport extends StatefulWidget {
  @override
  State<ViewRapport> createState() => _ViewRapportState();
}

class _ViewRapportState extends State<ViewRapport> {
  late Future<RapportVente> listRapport;
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    listRapport = RapportVenteController.getRapportVente();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white38,
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<RapportVente>(
          future: listRapport,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.ventesParDate.isEmpty) {
              return const Center(child: Text('Aucune vente trouvée.'));
            }

            final rapport = snapshot.data!;
            final dates = rapport.ventesParDate.keys.toList();
            dates.sort((a, b) => b.compareTo(a));
            selectedDate ??= dates.first;

            final ventesDuJour = rapport.ventesParDate[selectedDate!]!;

            // Calcul du montant total et quantité totale
            double montantTotal = 0;
            int quantiteTotale = 0;
            for (var vente in ventesDuJour) {
              montantTotal += double.tryParse(vente.montantTotal) ?? 0;
              quantiteTotale += vente.lots.fold(0, (sum, lot) => sum + lot.quantite);
            }

            return SafeArea(
              child: Column(
                children: [
                  AppbarTest(
                    title: "Rapport",
                    pageDeRemplacement: ViewDash(),
                  ).lancer(context),


                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26, // couleur de la bordure
                          width: 0.3,           // épaisseur de la bordure
                        )

                    ),
                    child: DropdownButton<String>(
                      value: selectedDate,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                      items: dates.map((date) {
                        return DropdownMenuItem(
                          value: date,
                          child: Text(
                            date,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, color: Colors.blueGrey),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDate = value;
                        });
                      },
                    ),
                  ),

                  // Statistiques (montant + quantité)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [

                      _buildStatCard(
                        "Montant vendu",
                        "${montantTotal.toInt()} ",
                        Colors.indigo,

                        Text("FC",style: TextStyle(fontSize:16,color: Colors.black,fontWeight: FontWeight.bold),),
                        context, //
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        "Quantité vendue",
                        "$quantiteTotale",
                        Colors.teal,
                        Icon(Icons.inventory_2_outlined,color: Colors.black, )
                        ,
                        context, //
                      ),
                    ],
                  ),
                ),


                  // Liste des ventes
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(13),
                      itemCount: ventesDuJour.length,
                      itemBuilder: (context, index) {
                        final vente = ventesDuJour[index];
                        final quantiteVente =
                        vente.lots.fold(0, (sum, lot) => sum + lot.quantite);
                        final montantVente = double.tryParse(vente.montantTotal) ?? 0;

                        return  createPaiementMarchandCard(
                          titre: "Vente N°${vente.idVente}",
                            montant: montantVente.toStringAsFixed(2),
                            heure: '08:32',
                            onVoirDetailsTap: () => _showDetailsBottom(context, vente, quantiteVente, montantVente));
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //  Popup détails améliorée
  void _showDetailsBottom(BuildContext context, vente, int quantiteVente, double montantVente) {
    showModalBottomSheet(
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 600), // vitesse de l’animation
      ),

      context: context,
      isScrollControlled: true, // pour permettre d'avoir plus d'espace
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(

        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text("Détails ",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),

              const Text("Médicaments",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: vente.lots.length,
                  itemBuilder: (context, i) {
                    final lot = vente.lots[i];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent.withOpacity(0.1),
                        child: Text('${i + 1}',
                            style: const TextStyle(color: Colors.blueAccent)),
                      ),
                      title: Text(lot.medicament.nom),
                      subtitle: Text(
                          "Quantité: ${lot.quantite} | Prix: ${lot.prixUnitaire} FC"),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(

                ),
                child: Text(
                  "Prix Total: ${montantVente.toStringAsFixed(2)} FC",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.print, size: 18),
                    label: const Text("Imprimer"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Fermer"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}
Widget _buildStatCard(String title, String value, Color color, Widget? leading,  BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Hauteur et taille police adaptatives
  final cardHeight = screenHeight * 0.15; // 15% de la hauteur écran
  final valueFontSize = screenWidth * 0.05; // 5% de la largeur écran
  final titleFontSize = screenWidth * 0.035; // 3.5% largeur
  final iconSize = screenWidth * 0.07; // 7% largeur

  // Convertir en K si > 999
  String displayValue = value;
  double? numericValue = double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), ''));
  if (numericValue != null && numericValue >= 1000) {
    displayValue = (numericValue / 1000).toStringAsFixed(1) + 'K';
  }

  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black26, // couleur de la bordure
          width: 0.3,           // épaisseur de la bordure
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 0), // décalage ombre
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1,horizontal:10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.access_time_sharp,color: Colors.black,)
              ],
            ),
            Row(
              children: [
                leading ?? const SizedBox(), // si non défini, rien
                if (leading != null) const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    displayValue,
                    style: TextStyle(
                      color: MyColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: valueFontSize,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400

              ),
            ),
          ],
        ),
      ),
    ),
  );
}

