import 'package:flutter/material.dart';

Widget buildComboBox<T>({
  required String title,
  required List<DropdownMenuItem<T>> items,
  T? selectedItem, // Peut être String, int, ou un objet
  required ValueChanged<T?> onChanged,
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
            color: Color.fromRGBO(0, 0, 0, 0.5),
            width: 1,
          ),
        ),
        child: DropdownButton<T>(
          value: selectedItem,
          isExpanded: true,
          underline: const SizedBox(),
          iconEnabledColor: Colors.green,
          hint: Text(
            placeholder,
            style: const TextStyle(color: Colors.grey),
          ),
          onChanged: onChanged,
          items: items,
        ),
      ),
    ],
  );
}
