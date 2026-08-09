import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/highlight_model.dart';

class HighlightService {
  final SupabaseClient _client = Supabase.instance.client;
 
  /// جلب جميع الملخصات والأهداف حية ومُرتبة زمنياً من السيرفر
  Future<List<HighlightModel>> getHighlights() async {
    try {
      final response = await _client
          .from('highlights')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => HighlightModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to load highlights: $e');
    }
  }

  /// جلب ملخصات وأهداف مباراة محددة بواسطة المعرف
  Future<List<HighlightModel>> getMatchHighlights(String matchId) async {
    try {
      final response = await _client
          .from('highlights')
          .select()
          .eq('match_id', matchId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => HighlightModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to load match highlights: $e');
    }
  }

  /// إضافة ملخص جديد (للاستخدام الإداري لاحقاً بلمسة واحدة من السحاب)
  Future<void> addHighlight(HighlightModel highlight) async {
    try {
      await _client
          .from('highlights')
          .insert(highlight.toJson());
    } catch (e) {
      throw Exception('Failed to add highlight: $e');
    }
  }

  /// حذف ملخص بواسطة المعرف الفريد آلياً
  Future<void> deleteHighlight(String id) async {
    try {
      await _client
          .from('highlights')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete highlight: $e');
    }
  }
}
