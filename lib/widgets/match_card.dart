import 'package:flutter/material.dart';
import '../models/match_model.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;

  const MatchCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF101C2B),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF00B4FF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B4FF).withValues(alpha: 0.20),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            match.league,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _team(
                match.homeTeam,
                match.homeLogo,
              ),
              Column(
                children: [
                  Text(
                    match.matchTime,
                    style: const TextStyle(
                      color: Color(0xFF00D1FF),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    match.status,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              _team(
                match.awayTeam,
                match.awayLogo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _team(String name, String logo) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.black26,
          backgroundImage: logo.isNotEmpty ? NetworkImage(logo) : null,
          child: logo.isEmpty
              ? const Icon(
                  Icons.shield,
                  color: Colors.white54,
                )
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
