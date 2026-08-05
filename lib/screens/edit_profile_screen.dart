import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  
  final supabase = Supabase.instance.client;
  File? _imageFile;
  String? _currentAvatarUrl;
  String? _userId;
  String _initialName = '';
  DateTime? _lastNameUpdatedAt;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // 🟢 جلب بيانات المستخدم الحالية عند فتح الصفحة
  Future<void> _loadUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (mounted) Navigator.pop(context);
      return;
    }

    _userId = user.id;

    try {
      final response = await supabase
          .from('profiles')
          .select('username, bio, avatar_url, last_name_updated_at')
          .eq('id', _userId!)
          .maybeSingle();

      if (response != null && mounted) {
        _initialName = response['username'] ?? 'مشجع NF Sports';
        _nameController.text = _initialName;
        _bioController.text = response['bio'] ?? '';
        _currentAvatarUrl = response['avatar_url'];
        
        if (response['last_name_updated_at'] != null) {
          _lastNameUpdatedAt = DateTime.tryParse(response['last_name_updated_at']);
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 📸 اختيار صورة من المعرض
  Future<void> _pickImage() async {
    HapticFeedback.lightImpact();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // 💾 حفظ التعديلات في السحابة
  Future<void> _saveProfile() async {
    if (_isSaving) return;
    HapticFeedback.mediumImpact();

    String newName = _nameController.text.trim();
    String newBio = _bioController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الرجاء كتابة اسم صحيح', style: GoogleFonts.cairo())),
      );
      return;
    }

    // ⏳ التحقق من شرط الـ 15 يومًا (لن يسمح بالتغيير إذا لم تمر 15 يومًا)
    if (_lastNameUpdatedAt != null) {
      final daysPassed = DateTime.now().difference(_lastNameUpdatedAt!).inDays;
      if (daysPassed < 15 && _initialName != newName) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('عذراً، يمكنك تغيير اسمك مرة واحدة كل 15 يومًا. المتبقي ${15 - daysPassed} يومًا.', style: GoogleFonts.cairo()),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      Map<String, dynamic> updates = {
        'username': newName,
        'bio': newBio,
      };

      // إذا اختار المستخدم صورة جديدة، نرفعها أولاً
      if (_imageFile != null) {
        final String filePath = 'avatars/${_userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await supabase.storage.from('avatars').upload(filePath, _imageFile!);
        
        final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
        updates['avatar_url'] = publicUrl;
      }

      // تحديث قاعدة البيانات
      await supabase.from('profiles').update(updates).eq('id', _userId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح! ✨', style: GoogleFonts.cairo())),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء الحفظ، حاول مجدداً.', style: GoogleFonts.cairo())),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.neonBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'تعديل الملف الشخصي',
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.neonBlue))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 🖼️ قسم الصورة الشخصية
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF161926),
                              border: Border.all(color: AppTheme.neonBlue, width: 2),
                              boxShadow: AppTheme.neonGlow(blur: 10),
                            ),
                            child: ClipOval(
                              child: _imageFile != null
                                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                                  : (_currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty
                                      ? Image.network(_currentAvatarUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, color: AppTheme.neonBlue, size: 40))
                                      : Center(
                                          child: Text(
                                            _initialName.isNotEmpty ? _initialName.substring(0, 1) : 'NF',
                                            style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 32, fontWeight: FontWeight.bold),
                                          ),
                                        )),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.neonBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.backgroundColor, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 📝 حقول التعديل
                  GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الاسم الظاهر للجميع', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.cairo(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black26,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppTheme.neonBlue.withOpacity(0.4)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('حالتك الرياضية (Bio)', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _bioController,
                          textDirection: TextDirection.rtl,
                          maxLines: 3,
                          style: GoogleFonts.cairo(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'اكتب شيئاً يعبر عن حبك لكرة القدم...',
                            hintStyle: GoogleFonts.cairo(color: Colors.white24, fontSize: 12),
                            filled: true,
                            fillColor: Colors.black26,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppTheme.neonBlue.withOpacity(0.4)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🟢 زر الحفظ
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _isSaving ? null : _saveProfile,
                      child: _isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                          : Text(
                              'حفظ التغييرات',
                              style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
