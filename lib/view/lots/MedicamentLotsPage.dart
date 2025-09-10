import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/LotController.dart';
import '../../model/lotModel.dart';
import '../../services/GetStorage/Pharmacie.dart';

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

    return RefreshIndicator(
      onRefresh: _loadLots,
      child: ListView.builder(
        itemCount: lots.length,
        itemBuilder: (context, index) {
          final lot = lots[index];
          final color = getExpirationColor(lot.dateExpiration);

          return Dismissible(
            key: Key(lot.idLot.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            confirmDismiss: (direction) async {
              return await _confirmDelete(lot);
            },
            onDismissed: (direction) {
              _deleteLot(lot);
            },
            child: Card(
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
                    Text("Expiration: ${_formatDate(lot.dateExpiration)}"),
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
                      onPressed: () => _showSetPrixUnitaireDialog(lot),
                    ),
                  ],
                ),
                onTap: () {
                  _showLotDetails(lot);
                },
              ),
            ),
          );
        },
      ),
    );
  }

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
    try {
      _lotController.deletelot(idlot: lot.idLot);
      setState(() {
        lots.remove(lot);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lot ${lot.numeroLot} supprimé avec succès'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showAddLotDialog() {
    final numeroLotController = TextEditingController();
    final quantiteController = TextEditingController();
    final dateController = TextEditingController();
    final prixAchatController = TextEditingController();
    final prixUnitaireController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter un nouveau lot"),
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
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      dateController.text = "${picked.toLocal()}".split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: prixAchatController,
                  decoration: const InputDecoration(
                    labelText: 'Prix d\'achat',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
              /*  TextField(
                  controller: prixUnitaireController,
                  decoration: const InputDecoration(
                    labelText: 'Prix unitaire',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
                  keyboardType: TextInputType.number,
                ),*/
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
               final String idPharma = await PharmacieStorage.getPharma();
                try {
                  final newLot = await _lotController.enregistrerLot(
                    idMedicament: widget.medicamentId,
                    //numeroLot: numeroLotController.text,
                    quantite: int.parse(quantiteController.text),
                    dateExpiration: dateController.text,
                    prixAchat: int.parse(prixAchatController.text),
                    idPharmacie: int.parse(idPharma),
                   // prixUnitaire: int.parse(prixUnitaireController.text),
                  );

                  if (newLot != null) {
                    Navigator.of(context).pop();
                    _loadLots();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lot ajouté avec succès!'),
                        backgroundColor: Colors.green,
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
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  void _showEditLotDialog(Lot lot) {
    final quantiteController = TextEditingController(text: lot.quantite.toString());
    final dateController = TextEditingController(text: lot.dateExpiration);
    final prixAchatController = TextEditingController(text: lot.prixAchat.toString());

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
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(lot.dateExpiration),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          dateController.text = "${picked.toLocal()}".split(' ')[0];
                          setDialogState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: prixAchatController,
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
                    setDialogState(() {});

                    try {
                      final updatedLot = await _lotController.updatelot(
                        idlot: lot.idLot,
                        quantite: int.parse(quantiteController.text),
                        dateExpiration: dateController.text,
                        prixAchat: int.parse(prixAchatController.text),
                      );

                      if (updatedLot != null) {
                        Navigator.of(context).pop();
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

  void _showSetPrixUnitaireDialog(Lot lot) {
    final prixUnitaireController = TextEditingController(text: lot.prixUnitaire.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Modifier le prix unitaire"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: prixUnitaireController,
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
                    setDialogState(() {});

                    try {
                      final updatedLot = await _lotController.setprixunitaire(
                        idlot: lot.idLot,
                        prix_unitaire: int.parse(prixUnitaireController.text),
                      );

                      if (updatedLot != null) {
                        Navigator.of(context).pop();
                        _loadLots();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Prix unitaire modifié avec succès!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erreur lors de la modification!'),
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
                Text("Date d'expiration: ${_formatDate(lot.dateExpiration)}"),
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  Color getExpirationColor(String expirationDate) {
    try {
      final now = DateTime.now();
      final expiration = DateTime.parse(expirationDate);
      final difference = expiration.difference(now).inDays;

      if (difference < 0) {
        return Colors.red; // Déjà expiré
      } else if (difference < 30) {
        return Colors.orange; // Expire dans moins d'un mois
      } else if (difference < 90) {
        return Colors.amber; // Expire dans moins de 3 mois
      } else {
        return Colors.green; // Valide (plus de 3 mois)
      }
    } catch (e) {
      return Colors.grey; // Format de date invalide
    }
  }

  String getExpirationInfo(String expirationDate) {
    try {
      final now = DateTime.now();
      final expiration = DateTime.parse(expirationDate);
      final difference = expiration.difference(now).inDays;

      if (difference < 0) {
        return "Expiré (${difference.abs()} jours)";
      } else if (difference < 30) {
        return "$difference jours";
      } else if (difference < 90) {
        final months = (difference / 30).floor();
        return "$months mois ${difference % 30} jours";
      } else {
        final months = (difference / 30).floor();
        return "$months mois";
      }
    } catch (e) {
      return "Date invalide";
    }
  }
}