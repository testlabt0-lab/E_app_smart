import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/models.dart';
import '../data/mock_data.dart';
import '../widgets/glass_card.dart';

class TongueTwisterScreen extends StatefulWidget {
  const TongueTwisterScreen({super.key});

  @override
  State<TongueTwisterScreen> createState() => _TongueTwisterScreenState();
}

class _TongueTwisterScreenState extends State<TongueTwisterScreen> {
  final FlutterTts _tts = FlutterTts();
  late stt.SpeechToText _speech;

  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isListening = false;
  String _spokenText = '';
  double _accuracy = 0.0;
  bool _hasEvaluated = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initTts();
  }

  void _initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5); // slightly faster to demonstrate
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  Future<void> _playAudio() async {
    setState(() => _isPlaying = true);
    await _tts.speak(MockData.tongueTwisters[_currentIndex].english);
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _spokenText = '';
          _hasEvaluated = false;
        });
        _speech.listen(onResult: (val) {
          setState(() {
            _spokenText = val.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_spokenText.isNotEmpty) {
        _evaluateAccuracy();
      }
    }
  }

  void _evaluateAccuracy() {
    final targetWords = MockData.tongueTwisters[_currentIndex].english.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').split(' ');
    final spokenWords = _spokenText.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').split(' ');

    int matches = 0;
    for (String word in spokenWords) {
      if (targetWords.contains(word)) matches++;
    }

    double calcAccuracy = matches / targetWords.length;
    if (calcAccuracy > 1.0) calcAccuracy = 1.0;

    setState(() {
      _accuracy = calcAccuracy;
      _hasEvaluated = true;
    });
  }

  void _nextTwister() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % MockData.tongueTwisters.length;
      _spokenText = '';
      _hasEvaluated = false;
      _accuracy = 0.0;
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final twister = MockData.tongueTwisters[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Tongue Twisters Gym 👅')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Say it as fast and accurately as possible!', style: TextStyle(color: Colors.grey, fontSize: 16)),
            const Spacer(),
            GlassCard(
              color: Colors.deepPurple,
              opacity: 0.1,
              child: Column(
                children: [
                  Text(twister.english, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Text(twister.arabic, style: const TextStyle(fontSize: 18, color: Colors.grey), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 48,
                  icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_circle_fill, color: Colors.blue),
                  onPressed: _isPlaying ? null : _playAudio,
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: _toggleListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isListening ? 80 : 64,
                    height: _isListening ? 80 : 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? Colors.red : Colors.green,
                      boxShadow: [
                        if (_isListening) BoxShadow(color: Colors.red.withOpacity(0.5), spreadRadius: 10, blurRadius: 20)
                      ]
                    ),
                    child: Icon(_isListening ? Icons.stop : Icons.mic, color: Colors.white, size: 32),
                  ),
                ),
              ],
            ),

            if (_spokenText.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text('You said: "$_spokenText"', style: const TextStyle(fontStyle: FontStyle.italic)),
            ],

            if (_hasEvaluated) ...[
              const SizedBox(height: 24),
              Text(
                'Fluency Score: ${(_accuracy * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _accuracy >= 0.8 ? Colors.green : Colors.orange
                )
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nextTwister,
                child: const Text('Next Twister'),
              )
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
