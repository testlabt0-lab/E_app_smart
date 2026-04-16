import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import '../providers/user_provider.dart';
import '../data/mock_data.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final savedWords = userProvider.savedItems.map((item) {
      return MockData.words.firstWhere((w) => w.id == item.wordId);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Practice Gym - Spaced Repetition')),
      body: savedWords.isEmpty
          ? const Center(child: Text('No words saved for practice yet.\nGo to Home and save some words!', textAlign: TextAlign.center))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: savedWords.length,
              itemBuilder: (context, index) {
                final word = savedWords[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    height: 250,
                    child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(word.emoji, style: const TextStyle(fontSize: 50)),
                              const SizedBox(height: 10),
                              Text(word.word, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              const Text('Tap to flip', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      back: Card(
                        elevation: 4,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(word.translation, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Text('"${word.example}"', style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
                                    onPressed: () => userProvider.updateReview(word.id, false),
                                    child: const Text('Hard'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100),
                                    onPressed: () {
                                      userProvider.updateReview(word.id, true);
                                      userProvider.addXp(5);
                                    },
                                    child: const Text('Easy'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
