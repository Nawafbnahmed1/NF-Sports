import 'package:flutter/material.dart';

class NFSportsBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NFSportsBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFF07111F),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF1B5DFF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0066FF).withOpacity(0.35),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(
            icon: Icons.home_rounded,
            title: "الرئيسية",
            index: 0,
          ),
          _item(
            icon: Icons.sports_soccer_rounded,
            title: "المباريات",
            index: 1,
          ),
          _item(
            icon: Icons.article_rounded,
            title: "الأخبار",
            index: 2,
          ),
          _item(
            icon: Icons.menu_rounded,
            title: "المزيد",
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final bool selected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF0066FF).withOpacity(0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected
                  ? const Color(0xFF00D1FF)
                  : Colors.white70,
              size: 27,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.white70,
                fontSize: 12,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
