import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import '../providers/user_provider.dart';

class SentenceBuilderGame extends StatefulWidget {
  const SentenceBuilderGame({super.key});

  @override
  State<SentenceBuilderGame> createState() => _SentenceBuilderGameState();
}

class _SentenceBuilderGameState extends State<SentenceBuilderGame> {
  late Phrase _currentPhrase;
  late List<String> _shuffledWords;
  List<String> _userSentence = [];
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadNewSentence();
  }

  void _loadNewSentence() {
    setState(() {
      _currentPhrase = MockData.phrases[Random().nextInt(MockData.phrases.length)];
      // Remove punctuation for clean blocks
      String cleanEnglish = _currentPhrase.english.replaceAll(RegExp(r'[^\w\s]'), '');
      _shuffledWords = cleanEnglish.split(' ')..shuffle();
      _userSentence = [];
    });
  }

  void _checkSentence() {
    String cleanEnglish = _currentPhrase.english.replaceAll(RegExp(r'[^\w\s]'), '');
    if (_userSentence.join(' ') == cleanEnglish) {
      setState(() => _score += 20);
      Provider.of<UserProvider>(context, listen: false).addXp(20);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfect syntax! +20 XP'), backgroundColor: Colors.green));
      Future.delayed(const Duration(seconds: 1), _loadNewSentence);
    }
  }

  void _onWordTapped(String word, bool isFromShuffled) {
    setState(() {
      if (isFromShuffled) {
        _shuffledWords.remove(word);
        _userSentence.add(word);
      } else {
        _userSentence.remove(word);
        _shuffledWords.add(word);
      }
    });
    if (_shuffledWords.isEmpty) {
      _checkSentence();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Syntax Builder - Score: $_score')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(_currentPhrase.arabic, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            const Text('Drag or tap words to form the correct English sentence', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),

            // Drop Zone (User Sentence)
            Container(
              width: double.infinity,
              minHeight: 100,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200, width: 2),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _userSentence.map((word) => _buildWordChip(word, false)).toList(),
              ),
            ),

            const SizedBox(height: 40),

            // Available Words
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _shuffledWords.map((word) => _buildWordChip(word, true)).toList(),
            ),

            const Spacer(),
            if (_shuffledWords.isEmpty && _userSentence.join(' ') != _currentPhrase.english.replaceAll(RegExp(r'[^\w\s]'), ''))
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                onPressed: () {
                   setState(() {
                     _shuffledWords.addAll(_userSentence);
                     _userSentence.clear();
                   });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildWordChip(String word, bool isFromShuffled) {
    return ActionChip(
      label: Text(word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      backgroundColor: isFromShuffled ? Colors.white : Colors.blue,
      labelStyle: TextStyle(color: isFromShuffled ? Colors.black : Colors.white),
      elevation: 2,
      onPressed: () => _onWordTapped(word, isFromShuffled),
    );
  }
}
