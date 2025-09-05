import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/view/layouts/StructurePage.dart';
import '../../controller/LotController.dart';
import '../../model/lotModel.dart';
import '../layouts/AppBarCustomer.dart';
import 'LotRegisterPage.dart';
import 'MedicamentLotsPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Pharmacie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final LotController _lotController = LotController();
  List<Lot> allLots = [];
  bool isLoading = true;
  String errorMessage = '';

  String searchQuery = "";
  String selectedPharmacy = "Toutes";

  @override
  void initState() {
    super.initState();
    _loadLots();
  }

  Future<void> _loadLots() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final List<Lot> fetchedLots = await _lotController.getLots();
      print('view ${fetchedLots}');

      setState(() {
        allLots = fetchedLots;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur lors du chargement: $e';
        isLoading = false;
      });
    }
  }

  // Fonction pour déterminer la couleur en fonction de la date d'expiration
  Color getExpirationColor(String expirationDate) {
    final now = DateTime.now();
    final expiration = DateTime.parse(expirationDate);
    final difference = expiration.difference(now).inDays;

    if (difference < 0) {
      return Colors.red; // Déjà expiré
    } else if (difference < 30) {
      return Colors.orange; // Expire dans moins d'un mois
    } else if (difference < 90) {
      return Colors.yellow; // Expire dans moins de 3 mois
    } else {
      return Colors.green; // Valide (plus de 3 mois)
    }
  }

  // Fonction pour obtenir le nombre de jours avant expiration
  String getExpirationInfo(String expirationDate) {
    final now = DateTime.now();
    final expiration = DateTime.parse(expirationDate);
    final difference = expiration.difference(now).inDays;

    if (difference < 0) {
      return "Expiré";
    } else if (difference < 30) {
      return "$difference j";
    } else if (difference < 90) {
      return "${(difference / 30).floor()} m";
    } else {
      return "${(difference / 30).floor()} m";
    }
  }

  // Grouper les lots par médicament
  Map<String, List<Lot>> groupLotsByMedicament() {
    Map<String, List<Lot>> grouped = {};

    for (var lot in allLots) {
      String medicamentName = lot.medicament.nom;
      if (!grouped.containsKey(medicamentName)) {
        grouped[medicamentName] = [];
      }
      grouped[medicamentName]!.add(lot);
    }

    return grouped;
  }

  // Calculer la quantité totale par médicament
  int getTotalQuantity(List<Lot> medicamentLots) {
    return medicamentLots.fold(0, (sum, lot) => sum + lot.quantite);
  }

  // Trouver la date d'expiration la plus proche
  Lot getEarliestExpiration(List<Lot> medicamentLots) {
    return medicamentLots.reduce((a, b) =>
    DateTime.parse(a.dateExpiration).isBefore(DateTime.parse(b.dateExpiration)) ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadLots,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    final groupedLots = groupLotsByMedicament();

    // Filtrage dynamique selon recherche
    final filteredMedicaments = groupedLots.entries.where((entry) =>
        entry.key.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Stoks'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLots,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {

            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITRE
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 15, bottom: 10),
              child: Text(
                "Tableau de bord",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),

            // CARTES INDICATEURS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  _buildStatCard("Total Médicaments", "${groupedLots.length}", Colors.blue,
                      Icons.medication_outlined),
                  const SizedBox(width: 10),
                  _buildStatCard("Lots en stock", "${allLots.length}", Colors.green,
                      Icons.inventory_2_outlined),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // BARRE DE RECHERCHE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Rechercher un médicament...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // TITRE TABLEAU
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Inventaire des médicaments",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // LEGENDE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildLegendItem(Colors.green, "Valide"),
                  const SizedBox(width: 15),
                  _buildLegendItem(Colors.yellow, "3 mois"),
                  const SizedBox(width: 15),
                  _buildLegendItem(Colors.orange, "< 1 mois"),
                  const SizedBox(width: 15),
                  _buildLegendItem(Colors.red, "Expiré"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // TABLEAU DES MEDICAMENTS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  child: Column(
                    children: [
                      // En-tête du tableau avec fond coloré
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: _buildTableHeader(),
                      ),
                      const Divider(height: 1, thickness: 0.5),

                      // Liste dynamique
                      Expanded(
                        child: filteredMedicaments.isEmpty
                            ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 50,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Aucun médicament trouvé",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                            : ListView.builder(
                          itemCount: filteredMedicaments.length,
                          itemBuilder: (context, index) {
                            final entry = filteredMedicaments[index];
                            final medicamentName = entry.key;
                            final medicamentLots = entry.value;
                            final totalQuantity = getTotalQuantity(medicamentLots);
                            final earliestLot = getEarliestExpiration(medicamentLots);

                            return InkWell(
                              onTap: () {
                                _showMedicamentDetails(context, medicamentName, medicamentLots);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: getExpirationColor(earliestLot.dateExpiration).withOpacity(0.1),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200]!,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: _buildTableRow(
                                  medicamentName,
                                  totalQuantity.toString(),
                                  medicamentLots.length.toString(),
                                  getExpirationInfo(earliestLot.dateExpiration),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // FLOATING BUTTON AJOUT
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduitPage(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 28),
        elevation: 4,
      ),

      // BOTTOM NAV BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: BottomNavigationBar(
            currentIndex: 0,
            selectedItemColor: Colors.green[700],
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Accueil",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: "Alertes",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: "Profil",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMedicamentDetails(BuildContext context, String medicamentName, List<Lot> lots) {
    if (lots.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicamentLotsPage(
            medicamentName: medicamentName,
            medicamentId: lots.first.idMedicament,
          ),
        ),
      );
    } else {
      // Gérer le cas où il n'y a pas de lots
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucun lot disponible pour $medicamentName')),
      );
    }
  }



// Widget pour les éléments de légende
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

// Petite carte statistique améliorée
  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const Spacer(),
                    Text(
                      value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// En-tête du tableau amélioré
  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text("Médicament",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text("Qté",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text("Lots",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text("Expiration",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

// Ligne de tableau améliorée
  Widget _buildTableRow(
      String medoc, String qte, String lots, String expiration) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(medoc, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 2,
            child: Text(qte,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 2,
            child: Text(lots,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 2,
            child: Text(expiration,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
// Fonction pour afficher les détails d'un médicament
