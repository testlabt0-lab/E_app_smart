import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class TwoMinuteRushScreen extends StatefulWidget {
  const TwoMinuteRushScreen({super.key});

  @override
  State<TwoMinuteRushScreen> createState() => _TwoMinuteRushScreenState();
}

class _TwoMinuteRushScreenState extends State<TwoMinuteRushScreen> {
  int _timeLeft = 120;
  int _score = 0;
  Timer? _timer;
  late Word _currentWord;
  late List<String> _options;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadQuestion();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
        setState(() => _isGameOver = true);
      }
    });
  }

  void _loadQuestion() {
    final random = Random();
    final allWords = [...MockData.words, ...Provider.of<UserProvider>(context, listen: false).customWords];
    _currentWord = allWords[random.nextInt(allWords.length)];

    Set<String> optionsSet = {_currentWord.translation};
    while(optionsSet.length < 4) {
       optionsSet.add(allWords[random.nextInt(allWords.length)].translation);
    }
    _options = optionsSet.toList()..shuffle();
  }

  void _checkAnswer(String selectedOption) {
    if (selectedOption == _currentWord.translation) {
      setState(() => _score += 15); // High XP reward for rush mode
      _loadQuestion();
    } else {
      Provider.of<UserProvider>(context, listen: false).logMistake(_currentWord.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong! Moving to next...'), duration: Duration(milliseconds: 500)));
      _loadQuestion();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isGameOver) {
      return Scaffold(
        backgroundColor: Colors.indigo.shade900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              const Text('RUSH COMPLETE!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              Text('You earned $_score XP!', style: const TextStyle(fontSize: 24, color: Colors.amber)),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                onPressed: () {
                  Provider.of<UserProvider>(context, listen: false).addXp(_score);
                  Navigator.pop(context);
                },
                child: const Text('Claim Reward', style: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ 2-Minute Rush', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
        backgroundColor: Colors.indigo.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade900, Colors.purple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Time: ${_timeLeft}s', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('XP: $_score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
              ],
            ),
            const Spacer(),
            Text(_currentWord.emoji, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(_currentWord.word, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
            const SizedBox(height: 40),
            ..._options.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => _checkAnswer(option),
                child: Text(option, style: const TextStyle(fontSize: 22)),
              ),
            )).toList(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
