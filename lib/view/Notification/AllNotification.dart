import 'package:flutter/material.dart';
import '../../ModelTampo/Lot.dart';
import '../../component/AppBarTest.dart';
import '../../services/GetStorage/LotStorage.dart';
import '../principal/portail.dart';

class AllNotification extends StatefulWidget {
  const AllNotification({super.key});

  @override
  State<AllNotification> createState() => _AllNotificationState();
}

class _AllNotificationState extends State<AllNotification> {
  List<Map<String, String>> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    List<Lot> lots = await LotStorage.getLots();
    List<Map<String, String>> notifList = [];

    for (var medoc in lots) {
      int remainingDays = DateTime.parse(medoc.dateExpiration)
          .difference(DateTime.now())
          .inDays;

      if (remainingDays <= 7) {
        notifList.add({
          "medicament":
          "${medoc.medicament.nom} ${medoc.medicament.forme.nom} ${medoc.medicament.dose.quantite}${medoc.medicament.dose.unite}",
          "joursRestants": remainingDays.toString(),
        });
      }
    }

    setState(() {
      notifications = notifList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppbarTest(title: "Notifications",pageDeRemplacement: Portail()).lancer(context),
      body: RefreshIndicator(
        onRefresh: loadNotifications,
        child: notifications.isEmpty
            ? const Center(
          child: Text(
            " Aucun médicament proche de l’expiration",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notif = notifications[index];
            final joursRestants =
            int.parse(notif["joursRestants"] ?? "0");
            Color cardColor =Colors.lightBlue[100]!;

            IconData icon = joursRestants <= 2
                ? Icons.warning_amber_rounded
                : Icons.access_time;

            return Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    icon,
                    color: Colors.black,
                  ),
                ),
                title: Text(
                  notif["medicament"]!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white),
                ),
                subtitle: Text(
                  "⏳ Expire dans $joursRestants jours",
                  style: TextStyle(
                    color: joursRestants <= 2
                        ? Colors.red
                        : Colors.black87,
                  ),
                ),
                trailing: const Icon(Icons.medical_services,
                    color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
