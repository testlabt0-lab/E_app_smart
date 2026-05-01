import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../data/mock_data.dart';
import 'word_card_screen.dart';

class MistakeClinicScreen extends StatelessWidget {
  const MistakeClinicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final allWords = [...MockData.words, ...userProvider.customWords];

    final mistakeWords = userProvider.mistakeWordIds.map((id) {
      return allWords.firstWhere((w) => w.id == id, orElse: () => allWords.first);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('The Mistake Clinic 🏥')),
      body: mistakeWords.isEmpty
          ? const Center(
              child: Text(
                'Great job! You have no recorded mistakes.\nKeep playing and practicing!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mistakeWords.length,
              itemBuilder: (context, index) {
                final word = mistakeWords[index];
                return Card(
                  color: Colors.red.shade50,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(word.emoji, style: const TextStyle(fontSize: 24)),
                    title: Text(word.word, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    subtitle: Text(word.translation),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          tooltip: 'I learned this!',
                          onPressed: () {
                            userProvider.removeMistake(word.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cured! Removed from clinic.')));
                          },
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordCardScreen(word: word),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
