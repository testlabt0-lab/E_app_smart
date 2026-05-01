import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class PlacementTestScreen extends StatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  State<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends State<PlacementTestScreen> {
  final List<Map<String, dynamic>> _questions = [
    // A1
    {"q": "I ___ a student.", "opts": ["am", "is", "are", "be"], "ans": "am", "level": "A1"},
    // A2
    {"q": "She ___ to the market yesterday.", "opts": ["goes", "went", "gone", "going"], "ans": "went", "level": "A2"},
    // B1
    {"q": "If it rains, we ___ at home.", "opts": ["stay", "will stay", "stayed", "would stay"], "ans": "will stay", "level": "B1"},
    // B2
    {"q": "The project ___ by tomorrow.", "opts": ["will be finished", "will finish", "has finished", "finishes"], "ans": "will be finished", "level": "B2"},
    // C1
    {"q": "Scarcely ___ the house when it started to rain.", "opts": ["I had left", "had I left", "I left", "did I leave"], "ans": "had I left", "level": "C1"},
    // C2
    {"q": "The committee's decision was completely ___, leaving no room for appeal.", "opts": ["arbitrary", "irrevocable", "transient", "spurious"], "ans": "irrevocable", "level": "C2"},
  ];

  int _currentIndex = 0;
  int _consecutiveCorrect = 0;
  int _consecutiveWrong = 0;
  bool _isFinished = false;
  String _finalLevel = "A1";

  void _answerQuestion(String selected) {
    bool isCorrect = selected == _questions[_currentIndex]["ans"];

    if (isCorrect) {
      _consecutiveCorrect++;
      _consecutiveWrong = 0;

      // Move to harder question if available
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _finishTest("C2");
      }
    } else {
      _consecutiveWrong++;
      _consecutiveCorrect = 0;

      if (_consecutiveWrong >= 2 || _currentIndex == 0) {
        // Fail state, determine level based on current index
        String level = _questions[_currentIndex]["level"];
        if (_currentIndex > 0) {
           level = _questions[_currentIndex - 1]["level"];
        }
        _finishTest(level);
      } else {
        // Stay on same difficulty / move forward slightly
        if (_currentIndex < _questions.length - 1) {
          setState(() {
            _currentIndex++;
          });
        } else {
          _finishTest(_questions.last["level"]);
        }
      }
    }
  }

  void _finishTest(String calculatedLevel) {
    setState(() {
      _isFinished = true;
      _finalLevel = calculatedLevel;
    });

    int xpReward = 0;
    if (_finalLevel == "A1") xpReward = 50;
    if (_finalLevel == "A2") xpReward = 100;
    if (_finalLevel == "B1") xpReward = 200;
    if (_finalLevel == "B2") xpReward = 300;
    if (_finalLevel == "C1") xpReward = 400;
    if (_finalLevel == "C2") xpReward = 500;

    Provider.of<UserProvider>(context, listen: false).addXp(xpReward);
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return Scaffold(
        backgroundColor: Colors.indigo.shade900,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stars, size: 100, color: Colors.amber),
                const SizedBox(height: 24),
                const Text('Test Complete!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                Text('Your estimated CEFR level is:\n$_finalLevel', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, color: Colors.white70)),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Start Learning Path', style: TextStyle(fontSize: 18)),
                )
              ],
            ),
          ),
        ),
      );
    }

    final currentQ = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Placement Test')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: (_currentIndex + 1) / _questions.length),
            const SizedBox(height: 40),
            Text(
              currentQ["q"],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ...List.generate(currentQ["opts"].length, (index) {
              final opt = currentQ["opts"][index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => _answerQuestion(opt),
                  child: Text(opt, style: const TextStyle(fontSize: 20)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
