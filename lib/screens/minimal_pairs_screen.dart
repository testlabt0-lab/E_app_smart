import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import '../widgets/glass_card.dart';

class MinimalPairsScreen extends StatefulWidget {
  const MinimalPairsScreen({super.key});

  @override
  State<MinimalPairsScreen> createState() => _MinimalPairsScreenState();
}

class _MinimalPairsScreenState extends State<MinimalPairsScreen> {
  final FlutterTts _tts = FlutterTts();
  late MinimalPair _currentPair;
  late String _targetWord;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _nextPair();
  }

  void _initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.4);
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  void _nextPair() {
    setState(() {
      _currentPair = MockData.minimalPairs[Random().nextInt(MockData.minimalPairs.length)];
      _targetWord = Random().nextBool() ? _currentPair.word1 : _currentPair.word2;
    });
    // Add slight delay before auto-playing
    Future.delayed(const Duration(milliseconds: 500), _playAudio);
  }

  Future<void> _playAudio() async {
    setState(() => _isPlaying = true);
    await _tts.speak(_targetWord);
  }

  void _checkAnswer(String selectedWord) {
    if (selectedWord == _targetWord) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correct! Hearing is sharp! 👂'), backgroundColor: Colors.green));
      Future.delayed(const Duration(seconds: 1), _nextPair);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oops, listen carefully again.'), backgroundColor: Colors.orange));
      _playAudio();
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minimal Pairs Training 🎧')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Listen to the audio and select the exact word you heard to train your ears against common Arabic pronunciation mistakes.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
            const Spacer(),

            // Audio Button
            GestureDetector(
              onTap: _isPlaying ? null : _playAudio,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isPlaying ? Colors.blue.shade200 : Colors.blue,
                  boxShadow: [
                    if (_isPlaying) BoxShadow(color: Colors.blue.withOpacity(0.5), spreadRadius: 15, blurRadius: 30)
                  ]
                ),
                child: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow, color: Colors.white, size: 60),
              ),
            ),

            const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GlassCard(
                    color: Colors.purple,
                    opacity: 0.1,
                    onTap: () => _checkAnswer(_currentPair.word1),
                    child: Center(
                      child: Column(
                        children: [
                          Text(_currentPair.word1, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          Text(_currentPair.arabic1, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlassCard(
                    color: Colors.teal,
                    opacity: 0.1,
                    onTap: () => _checkAnswer(_currentPair.word2),
                    child: Center(
                      child: Column(
                        children: [
                          Text(_currentPair.word2, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          Text(_currentPair.arabic2, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
