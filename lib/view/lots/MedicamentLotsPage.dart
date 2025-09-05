import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/LotController.dart';
import '../../model/lotModel.dart';

class MedicamentLotsPage extends StatefulWidget {
  final String medicamentName;
  final int medicamentId;

  const MedicamentLotsPage({
    super.key,
    required this.medicamentName,
    required this.medicamentId,
  });

  @override
  State<MedicamentLotsPage> createState() => _MedicamentLotsPageState();
}

class _MedicamentLotsPageState extends State<MedicamentLotsPage> {
  final LotController _lotController = LotController();
  List<Lot> lots = [];
  bool isLoading = true;
  String errorMessage = '';

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

      final List<Lot> allLots = await _lotController.getLots();

      // Filtrer les lots pour ce médicament spécifique
      final filteredLots = allLots
          .where((lot) => lot.idMedicament == widget.medicamentId)
          .toList();

      setState(() {
        lots = filteredLots;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur lors du chargement: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicamentName),
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
              _showAddLotDialog();
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLotDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // AJOUTEZ CETTE MÉTHODE MANQUANTE :
  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
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
      );
    }

    if (lots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2, size: 50, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Aucun lot trouvé'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showAddLotDialog();
              },
              child: const Text('Ajouter un lot'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: lots.length,
      itemBuilder: (context, index) {
        final lot = lots[index];
        final color = getExpirationColor(lot.dateExpiration);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              "Lot: ${lot.numeroLot}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Quantité: ${lot.quantite}"),
                Text("Prix unitaire: ${lot.prixUnitaire} FCFA"),
                Text("Expiration: ${lot.dateExpiration}"),
                Text(
                  "Statut: ${getExpirationInfo(lot.dateExpiration)}",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditLotDialog(lot),
                ),
                IconButton(
                  icon: const Icon(Icons.monetization_on_outlined, color: Colors.green),
                  onPressed: () => _showsetprixunitaire(lot),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(lot).then((confirmed) {
                    if (confirmed) {
                      _deleteLot(lot);
                    }
                  }),
                ),
              ],
            ),
            onTap: () {
              _showLotDetails(lot);
            },
          ),
        );
      },
    );
  }

  // AJOUTEZ CES MÉTHODES MANQUANTES :

  Future<bool> _confirmDelete(Lot lot) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmer la suppression"),
          content: Text("Êtes-vous sûr de vouloir supprimer le lot ${lot.numeroLot} ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _deleteLot(Lot lot) {
    setState(() {
      _lotController.deletelot(idlot: lot.idLot);
      lots.remove(lot);
    });
    // Ici vous devriez aussi appeler votre API pour supprimer le lot
  }

  void _showAddLotDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter un nouveau lot"),
          content: const Text("Fonctionnalité d'ajout de lot"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  void _showEditLotDialog2(Lot lot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier le lot"),
          content: const Text("Fonctionnalité de modification de lot"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  void _showEditLotDialog(Lot lot) {
    final idlot = lot.idLot;
    final quantiteController = TextEditingController(text: lot.quantite.toString());
    final dateController = TextEditingController(text: lot.dateExpiration);
    final prixController = TextEditingController(text: lot.prixAchat.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Modifier le lot"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: quantiteController,
                      decoration: const InputDecoration(
                        labelText: 'Quantité',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.inventory_2),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date d\'expiration (AAAA-MM-JJ)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: prixController,
                      decoration: const InputDecoration(
                        labelText: 'Prix d\'achat',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Show loading state in the dialog
                    setDialogState(() {});

                    try {
                      final updatedLot = await _lotController.updatelot(
                        idlot: idlot,
                        quantite: int.parse(quantiteController.text),
                        dateExpiration: dateController.text,
                        prixAchat: int.parse(prixController.text),

                      );

                      if (updatedLot != null) {
                        Navigator.of(context).pop();
                        // Call the loadLots function properly
                        _loadLots();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lot modifié avec succès!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erreur lors de la modification du lot!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      setDialogState(() {});
                    }
                  },
                  child: const Text("Enregistrer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showsetprixunitaire(Lot lot) {
    final idlot = lot.idLot;

    final prix_unitaire = TextEditingController(text: lot.prixUnitaire.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Modifier le lot"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextField(
                      controller: prix_unitaire,
                      decoration: const InputDecoration(
                        labelText: 'Prix unitaire',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Show loading state in the dialog
                    setDialogState(() {});

                    try {
                      final updatedLot = await _lotController.setprixunitaire(
                        idlot: idlot,

                        prix_unitaire: int.parse(prix_unitaire.text),

                      );

                      if (updatedLot != null) {
                        Navigator.of(context).pop();
                        // Call the loadLots function properly
                        _loadLots();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lot modifié avec succès!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erreur lors de la modification du lot!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      setDialogState(() {});
                    }
                  },
                  child: const Text("Enregistrer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLotDetails(Lot lot) {
    final color = getExpirationColor(lot.dateExpiration);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Détails du lot ${lot.numeroLot}"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Médicament: ${widget.medicamentName}"),
                const SizedBox(height: 10),
                Text("Numéro de lot: ${lot.numeroLot}"),
                Text("Quantité: ${lot.quantite}"),
                Text("Prix d'achat: ${lot.prixAchat} FCFA"),
                Text("Prix unitaire: ${lot.prixUnitaire} FCFA"),
                Text("Date d'expiration: ${lot.dateExpiration}"),
                Text(
                  "Statut: ${getExpirationInfo(lot.dateExpiration)}",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  // AJOUTEZ LES MÉTHODES D'EXPIRATION :

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

  String getExpirationInfo(String expirationDate) {
    final now = DateTime.now();
    final expiration = DateTime.parse(expirationDate);
    final difference = expiration.difference(now).inDays;

    if (difference < 0) {
      return "Expiré";
    } else if (difference < 30) {
      return "$difference jours";
    } else if (difference < 90) {
      return "${(difference / 30).floor()} mois";
    } else {
      return "${(difference / 30).floor()} mois";
    }
  }
}