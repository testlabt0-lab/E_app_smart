import 'package:flutter/material.dart';

class GlobalLeaderboardScreen extends StatelessWidget {
  const GlobalLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Leaderboard')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Theme.of(context).colorScheme.primary.withOpacity(0.1), Colors.transparent]
          )
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(Icons.public, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'World Rankings',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Compete with learners worldwide. Syncing with Firebase...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            _buildRankCard(1, 'Emma Watson', 15420, Colors.amber, Icons.emoji_events),
            _buildRankCard(2, 'Ahmed K.', 14200, Colors.grey.shade400, null),
            _buildRankCard(3, 'Sarah M.', 13850, Colors.orangeAccent, null),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text('...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey))),
            ),

            // Current User
            _buildRankCard(42, 'You', 2450, Colors.blue.shade100, Icons.person, isCurrentUser: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRankCard(int rank, String name, int xp, Color color, IconData? icon, {bool isCurrentUser = false}) {
    return Card(
      elevation: isCurrentUser ? 8 : 2,
      color: isCurrentUser ? Colors.blue.shade50 : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrentUser ? const BorderSide(color: Colors.blue, width: 2) : BorderSide.none,
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color,
          child: icon != null
              ? Icon(icon, color: Colors.black87)
              : Text('$rank', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        title: Text(name, style: TextStyle(fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600, fontSize: 18)),
        trailing: Text('$xp XP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
      ),
    );
  }
}
