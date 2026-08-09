import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTest extends StatefulWidget {
  const SupabaseTest({super.key});

  @override
  State<SupabaseTest> createState() => _SupabaseTestState();
}
 
class _SupabaseTestState extends State<SupabaseTest> {
  String result = "Loading...";

  @override
  void initState() {
    super.initState();
    test();
  }

  Future<void> test() async {
    try {
      final data = await Supabase.instance.client
          .from('matches')
          .select();

      setState(() {
        result = "Rows: ${data.length}\n\n$data";
      });
    } catch (e) {
      setState(() {
        result = "ERROR:\n$e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Supabase Test")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText(result),
      ),
    );
  }
}
