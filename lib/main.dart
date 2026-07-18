import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://njdeduovwamcbcucmull.supabase.co',
    anonKey: 'sb_publishable_C0DEuxqyVTgVE9uuTkuQ_x1xlPV',
  );

  runApp(const NFSportsApp());
}

class NFSportsApp extends StatelessWidget {
  const NFSportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NF Sports',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        primaryColor: const Color(0xFF00B4FF),
      ),
      home: const NavigationScreen(),
    );
  }
}
