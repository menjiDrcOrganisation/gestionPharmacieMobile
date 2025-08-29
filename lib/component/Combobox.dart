import 'package:flutter/material.dart';

/// ComboBox stylé avec placeholder fonctionnel
Widget buildComboBox({
  required String title,
  required List<String> items,
  String? selectedItem,                    // nullable
  required Function(String?) onChanged,
  String placeholder = "Sélectionnez une option",
  double borderRadius = 12.0,
  Color borderColor = Colors.black,
  Color fillColor = Colors.white,
  double width = double.infinity,
  double height = 50,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(117, 117, 117, 1),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: DropdownButton<String>(
          iconEnabledColor: Colors.green,
          value: selectedItem,          // null pour afficher le hint
          isExpanded: true,
          underline: const SizedBox(),
          hint: Text(
            placeholder,
            style: const TextStyle(color: Colors.grey),
          ),
          onChanged: onChanged,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    ],
  );
}
