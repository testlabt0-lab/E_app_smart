import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import 'sentence_builder_game.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Center')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GameCard(
            title: 'Word Scramble',
            icon: Icons.sort_by_alpha,
            color: Colors.orange,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WordScrambleGame())),
          ),
          const SizedBox(height: 16),
          GameCard(
            title: 'Word Match',
            icon: Icons.compare_arrows,
            color: Colors.green,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WordMatchGame())),
          ),
          const SizedBox(height: 16),
          GameCard(
            title: 'Time Attack',
            icon: Icons.timer,
            color: Colors.red,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimeAttackGame())),
          ),
          const SizedBox(height: 16),
          GameCard(
            title: 'Sentence Builder',
            icon: Icons.extension,
            color: Colors.purple,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SentenceBuilderGame())),
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const GameCard({super.key, required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(width: 24),
              Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.play_circle_fill, size: 36),
            ],
          ),
        ),
      ),
    );
  }
}

// Word Scramble Game
class WordScrambleGame extends StatefulWidget {
  const WordScrambleGame({super.key});
  @override
  State<WordScrambleGame> createState() => _WordScrambleGameState();
}

class _WordScrambleGameState extends State<WordScrambleGame> {
  late Word currentWord;
  late List<String> scrambledLetters;
  List<String> userLetters = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    _loadNewWord();
  }

  void _loadNewWord() {
    final random = Random();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final allWords = [...MockData.words, ...userProvider.customWords];

    currentWord = allWords[random.nextInt(allWords.length)];
    scrambledLetters = currentWord.word.toUpperCase().split('')..shuffle();
    userLetters = List.filled(currentWord.word.length, '');
  }

  void _checkAnswer() {
    if (userLetters.join() == currentWord.word.toUpperCase()) {
      setState(() {
        score += 10;
        Provider.of<UserProvider>(context, listen: false).addXp(10);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correct! +10 XP', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
      Future.delayed(const Duration(seconds: 1), () {
        if(mounted) setState(() => _loadNewWord());
      });
    } else if (!userLetters.contains('')) {
      // If word is fully filled but wrong
      Provider.of<UserProvider>(context, listen: false).logMistake(currentWord.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect. Try again! (Logged to clinic)'), backgroundColor: Colors.orange));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Score: $score')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text('Translation: ${currentWord.translation}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            Wrap(
              spacing: 8,
              children: List.generate(userLetters.length, (index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (userLetters[index].isNotEmpty) {
                        scrambledLetters.add(userLetters[index]);
                        userLetters[index] = '';
                      }
                    });
                  },
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.center,
                    child: Text(userLetters[index], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                );
              }),
            ),
            const SizedBox(height: 50),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: scrambledLetters.map((letter) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      int emptyIndex = userLetters.indexOf('');
                      if (emptyIndex != -1) {
                        userLetters[emptyIndex] = letter;
                        scrambledLetters.remove(letter);
                        _checkAnswer();
                      }
                    });
                  },
                  child: Text(letter, style: const TextStyle(fontSize: 20)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Word Match Game
class WordMatchGame extends StatefulWidget {
  const WordMatchGame({super.key});
  @override
  State<WordMatchGame> createState() => _WordMatchGameState();
}

class _WordMatchGameState extends State<WordMatchGame> {
  List<Word> gameWords = [];
  List<String> englishWords = [];
  List<String> arabicWords = [];
  String? selectedEnglish;
  String? selectedArabic;
  int score = 0;
  List<String> matchedWords = [];

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final random = Random();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final allWords = [...MockData.words, ...userProvider.customWords];

    gameWords = List.from(allWords)..shuffle(random);
    gameWords = gameWords.take(5).toList();

    englishWords = gameWords.map((w) => w.word).toList()..shuffle(random);
    arabicWords = gameWords.map((w) => w.translation).toList()..shuffle(random);
    matchedWords.clear();
    score = 0;
  }

  void _checkMatch() {
    if (selectedEnglish != null && selectedArabic != null) {
      final isMatch = gameWords.any((w) => w.word == selectedEnglish && w.translation == selectedArabic);
      if (isMatch) {
        setState(() {
          matchedWords.add(selectedEnglish!);
          matchedWords.add(selectedArabic!);
          score += 10;
          Provider.of<UserProvider>(context, listen: false).addXp(10);
        });
        selectedEnglish = null;
        selectedArabic = null;

        if (matchedWords.length == gameWords.length * 2) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You won! Resetting game...'), backgroundColor: Colors.green));
           Future.delayed(const Duration(seconds: 2), () {
             if(mounted) setState(() => _initGame());
           });
        }
      } else {
        // Find the english word they selected to log the mistake
        try {
           final wrongWord = gameWords.firstWhere((w) => w.word == selectedEnglish);
           Provider.of<UserProvider>(context, listen: false).logMistake(wrongWord.id);
        } catch(_) {}

        setState(() {
          selectedEnglish = null;
          selectedArabic = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong match! Logged to clinic.'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Score: $score')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: englishWords.map((word) => _buildGameButton(word, true)).toList(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: arabicWords.map((word) => _buildGameButton(word, false)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton(String text, bool isEnglish) {
    bool isMatched = matchedWords.contains(text);
    bool isSelected = isEnglish ? selectedEnglish == text : selectedArabic == text;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: isMatched ? Colors.grey : (isSelected ? Colors.blue.shade200 : null),
        ),
        onPressed: isMatched ? null : () {
          setState(() {
            if (isEnglish) {
              selectedEnglish = text;
            } else {
              selectedArabic = text;
            }
          });
          _checkMatch();
        },
        child: Text(text, style: TextStyle(fontSize: 18, color: isMatched ? Colors.transparent : null)),
      ),
    );
  }
}

// Time Attack Game

class TimeAttackGame extends StatefulWidget {
  const TimeAttackGame({super.key});
  @override
  State<TimeAttackGame> createState() => _TimeAttackGameState();
}

class _TimeAttackGameState extends State<TimeAttackGame> {
  int _timeLeft = 60;
  int _score = 0;
  Timer? _timer;
  late Word _currentWord;
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadQuestion();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _endGame();
      }
    });
  }

  void _loadQuestion() {
    final random = Random();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final allWords = [...MockData.words, ...userProvider.customWords];

    _currentWord = allWords[random.nextInt(allWords.length)];

    // Generate 3 wrong options + 1 correct option
    Set<String> optionsSet = {_currentWord.translation};
    while(optionsSet.length < 4) {
       optionsSet.add(allWords[random.nextInt(allWords.length)].translation);
    }
    _options = optionsSet.toList()..shuffle();
  }

  void _checkAnswer(String selectedTranslation) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (selectedTranslation == _currentWord.translation) {
      setState(() {
        _score += 5;
        userProvider.addXp(5);
      });
      _loadQuestion();
    } else {
      setState(() {
        _timeLeft -= 5; // Penalty for wrong answer
        if(_timeLeft < 0) _timeLeft = 0;
      });
      userProvider.logMistake(_currentWord.id);
    }
  }

  void _endGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Time\'s Up!'),
        content: Text('You scored $_score points!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back to Games'),
          )
        ],
      )
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Left: $_timeLeft s'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text('Score: $_score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _currentWord.word,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ..._options.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 20)
                ),
                onPressed: _timeLeft > 0 ? () => _checkAnswer(option) : null,
                child: Text(option),
              ),
            )).toList()
          ],
        ),
      ),
    );
  }
}
