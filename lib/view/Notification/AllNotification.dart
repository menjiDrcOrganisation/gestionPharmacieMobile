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
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.black12,
                  width: 1,
                ),
              ),

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
                      fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black),
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

Widget buildStatCardAsCard({
  required String title,
  required String value,
  required Color color,
  Widget? leading,
  BuildContext? context,
  double? height,
}) {
  final screenWidth = context != null ? MediaQuery.of(context).size.width : 300.0;
  final screenHeight = context != null ? MediaQuery.of(context).size.height : 150.0;

  final cardHeight = height ?? screenHeight * 0.15;
  final valueFontSize = screenWidth * 0.05;
  final titleFontSize = screenWidth * 0.035;

  // Convertir en K si > 999
  String displayValue = value;
  double? numericValue = double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), ''));
  if (numericValue != null && numericValue >= 1000) {
    displayValue = (numericValue / 1000).toStringAsFixed(1) + 'K';
  }

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    child: Container(
      height: cardHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              leading ?? const Icon(Icons.access_time_sharp, color: Colors.black),
              if (leading != null) const SizedBox(width: 8),
              Flexible(
                child: Text(
                  displayValue,
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: valueFontSize,
                  ),
                ),
              ),
            ],
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}


