import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/news_model.dart';

class NewsService {
  final SupabaseClient _client = Supabase.instance.client;

  /// جلب كافّة الأخبار حية ومُرتبة زمنياً من السيرفر
  Future<List<NewsModel>> getNews() async {
    try {
      final response = await _client
          .from('news')
          .select()
          .order('published_at', ascending: false);
 
      return (response as List)
          .map((item) => NewsModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  /// جلب تفاصيل الخبر الفردي بواسطة المعرف الفريد آلياً
  Future<NewsModel?> getNewsById(String id) async {
    try {
      final response = await _client
          .from('news')
          .select()
          .eq('id', id)
          .single();

      return NewsModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
