import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/component/Colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;


  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = false,


  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.primary,
      elevation: 5,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      leading: showBack
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      )
          : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // Exemple : action notification
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pas encore implémenté")),
            );
          },
        ),


      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
