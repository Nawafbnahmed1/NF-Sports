import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/match_detail_model.dart';

class MatchDetailService {
  final SupabaseClient _client = Supabase.instance.client;
 
  /// جلب تفاصيل وإحصائيات مباراة واحدة بواسطة المعرف حياً
  Future<MatchDetailModel?> getMatchDetails(String matchId) async {
    try {
      final response = await _client
          .from('match_details')
          .select()
          .eq('match_id', matchId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return MatchDetailModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load match details: $e');
    }
  }

  /// جلب كافّة تفاصيل المباريات المضافة مُرتبة تنازلياً
  Future<List<MatchDetailModel>> getAllMatchDetails() async {
    try {
      final response = await _client
          .from('match_details')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => MatchDetailModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to load details: $e');
    }
  }

  /// تحديث تفاصيل المباراة لاحقاً (خاص بلوحة تحكم الإدارة حقتك)
  Future<void> updateMatchDetails(String id, Map<String, dynamic> data) async {
    try {
      await _client
          .from('match_details')
          .update(data)
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to update match details: $e');
    }
  }
}
