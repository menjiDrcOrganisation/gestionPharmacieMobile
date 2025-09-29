import 'package:flutter/material.dart';
import '../../component/AppBarTest.dart';
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
      // Dégradé léger en fond
      body: Container(
        decoration: const BoxDecoration(
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

                  // Titre + filtre date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Rapport de vente",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
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
                        "${montantTotal} ",
                        Colors.indigo,

                        Text("FC",style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.bold),),
                        context, //
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        "Quantité vendue",
                        "$quantiteTotale",
                        Colors.teal,
                        Icon(Icons.inventory_2_outlined,color: Colors.white, )
                        ,
                        context, //
                      ),
                    ],
                  ),
                ),


                  // Liste des ventes
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: ventesDuJour.length,
                      itemBuilder: (context, index) {
                        final vente = ventesDuJour[index];
                        final quantiteVente =
                        vente.lots.fold(0, (sum, lot) => sum + lot.quantite);
                        final montantVente = double.tryParse(vente.montantTotal) ?? 0;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent.withOpacity(0.2),
                              child: const Icon(Icons.person, color: Colors.blueAccent),
                            ),
                            title: Text(
                              "Client: ${vente.nomClient}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text("Vente N° ${vente.idVente} | Lots: $quantiteVente"),
                                Text("Total: ${montantVente.toStringAsFixed(2)} FC",
                                    style: const TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.info_outline, color: Colors.blueAccent),
                              onPressed: () => _showDetails(context, vente, quantiteVente, montantVente),
                            ),
                          ),
                        );
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
  void _showDetails(BuildContext context, vente, int quantiteVente, double montantVente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Détails de la vente",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: Text("Quantité: $quantiteVente",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.blueAccent)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text("Montant: ${montantVente.toStringAsFixed(2)} FC",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.green)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Lots de médicaments :",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 160,
                child: ListView.builder(
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
            ],
          ),
        ),
        actions: [
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
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.7), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                leading ?? const SizedBox(), // si non défini, rien
                if (leading != null) const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    displayValue,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: valueFontSize,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: titleFontSize,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

