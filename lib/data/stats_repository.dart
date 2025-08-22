import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class StatsRepository {
  final SupabaseClient _supa = Supabase.instance.client;

  Future<Map<String, dynamic>> loadStats() async {
    final uid = _supa.auth.currentUser!.id;

    final rows = await _supa.from('plants').select('id').eq('user_id', uid);
    final total = rows.length;

    final today = DateTime.now();

    // due tasks
    final due = await _supa.rpc('plants_due_today', params: {
      'uid': uid,
      'today_date':
      DateTime(today.year, today.month, today.day).toIso8601String()
    }).catchError((_) async {
      final rows = await _supa
          .from('plants')
          .select('last_watered, watering_interval_days')
          .eq('user_id', uid);
      int dueCount = 0;
      for (final r in rows) {
        final lw = r['last_watered'] != null
            ? DateTime.parse(r['last_watered'])
            : null;
        final interval = (r['watering_interval_days'] as int?) ?? 3;
        final next = (lw ?? today.subtract(Duration(days: interval)))
            .add(Duration(days: interval));
        if (!next.isAfter(today)) dueCount++;
      }
      return {'count': dueCount};
    });

    // latest plant
    final latest = await _supa
        .from('plants')
        .select('name')
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    // streak hesaplama
    int streak = 0;
    final allPlants = await _supa
        .from('plants')
        .select('last_watered')
        .eq('user_id', uid);

    bool broken = false;
    for (int i = 0; i < 30; i++) {
      final day = DateTime(today.year, today.month, today.day - i);
      final wateredToday = allPlants.any((p) {
        if (p['last_watered'] == null) return false;
        final lw = DateTime.parse(p['last_watered']);
        return lw.year == day.year && lw.month == day.month && lw.day == day.day;
      });

      if (wateredToday) {
        streak++;
      } else {
        if (i == 0) continue;
        broken = true;
        break;
      }
    }

    return {
      'total': total,
      'due': (due is Map && due['count'] != null)
          ? due['count'] as int
          : (due as List).length,
      'latest': latest?['name'] ?? '-',
      'streak': streak,
    };
  }
}
