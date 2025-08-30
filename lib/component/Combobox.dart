import 'package:flutter/material.dart';

Widget buildComboBox({
  required String title,
  required List<String> items,
  String? selectedItem, // Nullable pour permettre d'afficher le hint
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
          fontSize: 16,
          color: Color.fromRGBO(117, 117, 117, 1),
          fontWeight: FontWeight.w500,
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
            color: Color.fromRGBO(0,0, 0, 0.5),
            width: 1,
          ),
        ),
        child: DropdownButton<String>(
          value: items.contains(selectedItem) ? selectedItem : null,
          isExpanded: true,
          underline: const SizedBox(),
          iconEnabledColor: Colors.green,
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
