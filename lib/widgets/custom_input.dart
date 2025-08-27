import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomInput<T> extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final void Function(T?)? onChanged;
  final bool isDropdown;

  const CustomInput({
    super.key,
    required this.label,
    this.controller,
    this.items,
    this.value,
    this.onChanged,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return isDropdown
        ? DropdownButtonFormField2<T>(
      isExpanded: true,
      value: value,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: _decoration(),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items,
      onChanged: onChanged,
      selectedItemBuilder: (context) {
        return items!
            .map((e) => Text(
          e.value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ))
            .toList();
      },
    )
        : TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: _decoration(),
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.10),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.greenAccent, width: 1.2),
      ),
    );
  }
}
