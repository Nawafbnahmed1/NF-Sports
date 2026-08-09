import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/match_model.dart';

class MatchService {
  MatchService._();
 
  static final SupabaseClient _client = Supabase.instance.client;

  /// جلب مباريات اليوم حية من السيرفر
  static Future<List<MatchModel>> getTodayMatches() async {
    final response = await _client
        .from('matches')
        .select()
        .order('match_date');

    return (response as List)
        .map((item) => MatchModel.fromJson(item))
        .toList();
  }

  /// جلب مباراة بواسطة المعرف الفريد
  static Future<MatchModel?> getMatchById(String id) async {
    final response = await _client
        .from('matches')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return MatchModel.fromJson(response);
  }

  /// جلب المباريات حسب البطولة آلياً
  static Future<List<MatchModel>> getMatchesByLeague(String leagueName) async {
    final response = await _client
        .from('matches')
        .select()
        .eq('league_name', leagueName)
        .order('match_date');

    return (response as List)
        .map((item) => MatchModel.fromJson(item))
        .toList();
  }

  /// جلب المباريات حسب الحالة (جارية / منتهية / مجدولة)
  static Future<List<MatchModel>> getMatchesByStatus(String status) async {
    final response = await _client
        .from('matches')
        .select()
        .eq('status', status)
        .order('match_date');

    return (response as List)
        .map((item) => MatchModel.fromJson(item))
        .toList();
  }
}
