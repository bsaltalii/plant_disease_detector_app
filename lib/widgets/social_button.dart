import 'package:flutter/material.dart';

class Social extends StatelessWidget {
  final IconData icon;
  const Social({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}