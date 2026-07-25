import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'screens/navigation_screen.dart';
import 'supabase_test.dart'; // تم استدعاء ملف الفحص الجديد والمنفصل هنا بنجاح

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // الاحتفاظ بالروابط والمفاتيح الأصلية والكاملة 100% بدون أي نقص أو تغيير برمي
  await Supabase.initialize(
    url: 'https://njdeduovwamcbcucmull.supabase.co',
    publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qZGVkdW92d2FtY2JjdWNtdWxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQxODM3NDgsImV4cCI6MjA5OTc1OTc0OH0.AeQM-jGZOQrufBMmav7SxPK93LUi2DqEeSi2O95esq0',
  );

  // السطر الذكي الإضافي لتشغيل فحص المطور وطباعة الـ DATA تلقائياً فور فتح التطبيق
  await SupabaseTest.runDebugCheck();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NF Sports',
      theme: AppTheme.darkTheme,
      home: NavigationScreen(), // العودة لفتح كافة الأقسام والصفحات السابقة تلقائياً في مكانها
    );
  }
}
