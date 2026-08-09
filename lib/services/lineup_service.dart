import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lineup_model.dart';

class LineupService {
  final SupabaseClient _client = Supabase.instance.client;

  /// جلب تشكيلات وخطط مباراة محددة بواسطة المعرف حياً من السيرفر
  Future<List<LineupModel>> getMatchLineups(String matchId) async {
    try {
      final response = await _client
          .from('lineups')
          .select()
          .eq('match_id', matchId);

      return (response as List)
          .map((item) => LineupModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to load lineups: $e');
    }
  }

  /// إضافة تشكيلة جديدة (خاص بلوحة تحكم الإدارة حقتك سحابياً)
  Future<void> addLineup(LineupModel lineup) async {
    try {
      await _client
          .from('lineups')
          .insert(lineup.toJson());
    } catch (e) {
      throw Exception('Failed to add lineup: $e');
    }
  }
}
