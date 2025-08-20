import 'package:flutter/material.dart';
import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  final List<Map<String, dynamic>> stats;

  const StatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final stat = stats[index];
          return StatCard(
            title: stat["title"],
            value: stat["value"],
            icon: stat["icon"],
          );
        },
      ),
    );
  }
}
