import 'package:flutter/material.dart';

class PlantsPage extends StatelessWidget {
  const PlantsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Bitkilerim')),
    body: const Center(child: Text('Liste burada olacak')),
  );
}