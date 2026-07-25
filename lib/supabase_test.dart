import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTest {
  static final supabase = Supabase.instance.client;

  // دالة الفحص والطباعة المؤقتة التي طلبها المطور لاختبار جلب الـ 17 مباراة
  static Future<void> runDebugCheck() async {
    try {
      final data = await supabase.from('matches').select();
      
      print('DATA FROM SUPABASE:');
      print(data);
      print('Matches count total: ${data.length}');
    } catch (e) {
      print('ERROR DURING FETCH: $e');
    }
  }
}
