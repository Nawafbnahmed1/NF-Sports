import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🧱 نموذج المشجع المسجل المربوط حياً بقاعدة بيانات سحابتك لقراءة الاسم والفرق
class UserPremiumModel {
  final String uid;
  final String email;
  final String displayName; 
  final List<String> favoriteTeams;

  const UserPremiumModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.favoriteTeams,
  });
}

class PremiumNotificationService {
  final Random _random = Random();

  // 📝 محرك الفرز الذكي: يدمج المتغيرات الحية القادمة من قاعدة البيانات حياً مع النصوص السحابية
  String _getLiveDatabaseMessage(List<String> liveMessages, String userName, String teamName) {
    if (liveMessages.isEmpty) return "";
    final int index = _random.nextInt(liveMessages.length);
    return liveMessages[index].replaceAll('{name}', userName).replaceAll('{team}', teamName);
  }

  // 🏆 أ. خوارزمية أشرطة الفوز الـ 5 (Premium Win Channel) - تستقبل الرسائل حياً من السحاب
  Future<void> triggerPremiumWinNotification(UserPremiumModel user, String teamName, List<String> databaseWinMessages) async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();

    final String finalMessage = _getLiveDatabaseMessage(databaseWinMessages, user.displayName, teamName);
    debugPrint("Triggering Live Win Action [Channel ${Random().nextInt(5) + 1}] -> $finalMessage");
  }

  // ⚽ ب. خوارزمية أشرطة الأهداف الـ 5 باسم المشجع (Premium Goal Channel) - تستقبل الرسائل حياً من السحاب
  Future<void> triggerPremiumGoalNotification(UserPremiumModel user, String teamName, List<String> databaseGoalMessages) async {
    for (int i = 0; i < 3; i++) {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 120));
    }

    final String finalMessage = _getLiveDatabaseMessage(databaseGoalMessages, user.displayName, teamName);
    debugPrint("Triggering Live Goal Action [Channel ${Random().nextInt(5) + 1}] -> $finalMessage");
  }

  // 🤝 ج. خوارزمية أشرطة التعادل الـ 5 (Premium Draw Channel) - تستقبل الرسائل حياً من السحاب
  Future<void> triggerPremiumDrawNotification(UserPremiumModel user, String teamName, List<String> databaseDrawMessages) async {
    await HapticFeedback.lightImpact();
    final String finalMessage = _getLiveDatabaseMessage(databaseDrawMessages, user.displayName, teamName);
    debugPrint("Triggering Live Draw Action [Channel ${Random().nextInt(5) + 1}] -> $finalMessage");
  }

  // 💔 د. أشرطة الاحتواء والتشجيع الإيجابي عند الخسارة (Premium Loss Channel) - تستقبل الرسائل حياً من السحاب
  Future<void> triggerPremiumLossNotification(UserPremiumModel user, String teamName, List<String> databaseLossMessages) async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 300));
    await HapticFeedback.lightImpact();

    final String finalMessage = _getLiveDatabaseMessage(databaseLossMessages, user.displayName, teamName);
    debugPrint("Triggering Live Loss Action [Channel ${Random().nextInt(5) + 1}] -> $finalMessage");
  }

  // ⏰ هـ. خوارزمية أشرطة التذكير الصباحي الـ 5 (Premium Morning Channel) - تستقبل الرسائل حياً من السحاب
  Future<void> triggerPremiumMorningReminder(UserPremiumModel user, String teamName, List<String> databaseMorningMessages) async {
    await HapticFeedback.lightImpact();
    final String finalMessage = _getLiveDatabaseMessage(databaseMorningMessages, user.displayName, teamName);
    debugPrint("Triggering Live Morning Action [Channel ${Random().nextInt(5) + 1}] -> $finalMessage");
  }

  // ⏱️ و. خوارزمية أشرطة انطلاق المباراة الـ 5 (Premium Match Kickoff Channel) - تستقبل الرسائل حياً من السحاب
  Future<void> triggerMatchKickoffNotification(UserPremiumModel user, String teamName, List<String> databaseKickoffMessages) async {
    for (int i = 0; i < 3; i++) {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 80));
    }

    final String finalMessage = _getLiveDatabaseMessage(databaseKickoffMessages, user.displayName, teamName);
    debugPrint("Triggering Live Kickoff Action [Channel ${Random().nextInt(5) + 1}] -> $finalMessage");
  }
}
