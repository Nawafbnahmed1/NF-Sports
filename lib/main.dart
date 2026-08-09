import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'screens/navigation_screen.dart';
import 'widgets/no_internet_widget.dart';
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://njdeduovwamcbcucmull.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qZGVkdW92d2FtY2JjdWNtdWxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQxODM3NDgsImV4cCI6MjA5OTc1OTc0OH0.AeQM-jGZOQrufBMmav7SxPK93LUi2DqEeSi2O95esq0',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isOnline = true; // الحالة الافتراضية للإنترنت
  bool _isChecking = false; // لمنع تكرار الفحص عند الضغط المكثف
  Timer? _internetCheckTimer; // رادار فحص دوري صامت في الخلفية

  @override
  void initState() {
    super.initState();
    _checkInternetSilence(); // الفحص الفوري عند إقلاع التطبيق
    _internetCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkInternetSilence();
    });
  }

  @override
  void dispose() {
    _internetCheckTimer?.cancel(); // تنظيف الذاكرة بأعلى مواصفات برمجية
    super.dispose();
  }

  Future<void> _checkInternetSilence() async {
    if (_isChecking) return;
    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!_isOnline) setState(() => _isOnline = true);
      }
    } catch (_) {
      if (_isOnline) setState(() => _isOnline = false);
    }
  }

  Future<void> _checkInternetManual() async {
    setState(() => _isChecking = true);
    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 4));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isOnline = true;
          _isChecking = false;
        });
      } else {
        _showFailureSnack();
      }
    } catch (_) {
      _showFailureSnack();
    }
  }

  void _showFailureSnack() {
    setState(() => _isChecking = false);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '🔄 جاري الفحص.. لم يتم العثور على اتصال مستقر بالسحاب.',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue.shade900.withOpacity(0.9),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NF Sports',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: _isOnline 
          ? const NavigationScreen() 
          : NoInternetWidget(onRetry: _checkInternetManual),
    );
  }
}
