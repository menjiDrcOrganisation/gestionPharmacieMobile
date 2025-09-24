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
      backgroundColor: Colors.grey[100],
      appBar: AppbarTest(
        title: "Rapport",
        pageDeRemplacement: ViewDash(),
      ).lancer(context),
      body: FutureBuilder<RapportVente>(
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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rapport de vente",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: selectedDate,
                        underline: const SizedBox(),
                        items: dates.map((date) {
                          return DropdownMenuItem(
                            value: date,
                            child: Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDate = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    _buildStatCard(
                      "Montant vendu",
                      "${montantTotal.toStringAsFixed(2)} FC",
                      Colors.blueAccent,
                      Icons.attach_money_outlined,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      "Quantité vendue",
                      "$quantiteTotale",
                      Colors.green,
                      Icons.inventory_2_outlined,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: ventesDuJour.length,
                  itemBuilder: (context, index) {
                    final vente = ventesDuJour[index];
                    final quantiteVente = vente.lots.fold(0, (sum, lot) => sum + lot.quantite);
                    final montantVente = double.tryParse(vente.montantTotal) ?? 0;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Client: ${vente.nomClient}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text("Vente N° ${vente.idVente} | Lots: $quantiteVente"),
                            const SizedBox(height: 4),
                            Text("Total: ${montantVente.toStringAsFixed(2)} FC",
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                                icon: const Icon(Icons.info_outline, size: 18),
                                label: const Text("Détails"),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Détails de la vente"),
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
                                                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue[50], // fond léger
                                                      borderRadius: BorderRadius.circular(8), // coins arrondis
                                                      border: Border.all(color: Colors.blueAccent, width: 1),
                                                    ),
                                                    child: Text(
                                                      "Quantité totale: $quantiteVente",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.blueAccent,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green[50], // fond léger différent pour distinction
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(color: Colors.green, width: 1),
                                                    ),
                                                    child: Text(
                                                      "Montant: ${montantVente.toStringAsFixed(2)} FC",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.green,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 12),
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("detaille vente:",
                                                  style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            const SizedBox(height: 6),
                                            // Liste des lots
                                            SizedBox(
                                              height: 150, // hauteur fixe pour le scroll
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: vente.lots.length,
                                                itemBuilder: (context, i) {
                                                  final lot = vente.lots[i];
                                                  return ListTile(
                                                    dense: true,
                                                    leading: CircleAvatar(
                                                      backgroundColor: Colors.blueAccent.withOpacity(0.2),
                                                      child: Text('${i + 1}', style: const TextStyle(color: Colors.blueAccent)),
                                                    ),
                                                    title: Text(lot.medicament.nom),
                                                    subtitle: Text(
                                                        "Quantité: ${lot.quantite} | Prix unitaire: ${lot.prixUnitaire} FC"),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // Ici tu peux ajouter la fonction d'impression
                                            // Par exemple: generatePdf(vente) ou sharePdf(vente)
                                          },
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.print, size: 18),
                                              SizedBox(width: 4),
                                              Text("Imprimer"),
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("Fermer"),
                                        ),
                                      ],
                                    ),
                                  );

                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildStatCard(String title, String value, Color color, IconData icon) {
  return Expanded(
    child: Container(
      height: 120,
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
                Icon(icon, color: Colors.white, size: 28),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
}
