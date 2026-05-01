import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';

class ShadowingScreen extends StatefulWidget {
  const ShadowingScreen({super.key});

  @override
  State<ShadowingScreen> createState() => _ShadowingScreenState();
}

class _ShadowingScreenState extends State<ShadowingScreen> {
  final FlutterTts _tts = FlutterTts();
  late stt.SpeechToText _speech;

  Phrase? _currentPhrase;
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
    _loadNextPhrase();
  }

  void _initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.4); // Slower for shadowing

    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  void _loadNextPhrase() {
    setState(() {
      _currentPhrase = MockData.phrases[Random().nextInt(MockData.phrases.length)];
      _spokenText = '';
      _accuracy = 0.0;
      _hasEvaluated = false;
    });
  }

  Future<void> _playNativeAudio() async {
    if (_currentPhrase == null) return;
    setState(() => _isPlaying = true);
    await _tts.speak(_currentPhrase!.english);
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
    if (_currentPhrase == null || _spokenText.isEmpty) return;

    // Simple Jaccard/Token similarity logic for MVP
    final targetWords = _currentPhrase!.english.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').split(' ');
    final spokenWords = _spokenText.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').split(' ');

    int matches = 0;
    for (String word in spokenWords) {
      if (targetWords.contains(word)) {
        matches++;
      }
    }

    double calcAccuracy = matches / targetWords.length;
    if (calcAccuracy > 1.0) calcAccuracy = 1.0;

    setState(() {
      _accuracy = calcAccuracy;
      _hasEvaluated = true;
    });

    if (_accuracy >= 0.8) {
      Provider.of<UserProvider>(context, listen: false).addXp(15);
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
      appBar: AppBar(title: const Text('Audio Shadowing Studio 🎙️')),
      body: _currentPhrase == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Listen carefully, then tap the mic and repeat exactly what you heard.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const Spacer(),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(_currentPhrase!.english, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          Text(_currentPhrase!.arabic, style: const TextStyle(fontSize: 20, color: Colors.grey), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Native Speaker Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: _isPlaying ? Colors.blue.shade200 : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isPlaying ? null : _playNativeAudio,
                    icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
                    label: Text(_isPlaying ? 'Playing...' : 'Play Native Audio', style: const TextStyle(fontSize: 18)),
                  ),

                  const SizedBox(height: 40),

                  // User Record Button
                  GestureDetector(
                    onTap: _toggleListening,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _isListening ? 100 : 80,
                      height: _isListening ? 100 : 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening ? Colors.red : Colors.green,
                        boxShadow: [
                          if (_isListening) BoxShadow(color: Colors.red.withOpacity(0.5), spreadRadius: 10, blurRadius: 20)
                        ]
                      ),
                      child: Icon(_isListening ? Icons.stop : Icons.mic, color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(_isListening ? 'Listening... Tap to Stop' : 'Tap to Record', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  if (_spokenText.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('You said: "$_spokenText"', style: const TextStyle(fontStyle: FontStyle.italic)),
                  ],

                  if (_hasEvaluated) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Accuracy: ${(_accuracy * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _accuracy >= 0.8 ? Colors.green : Colors.orange
                      )
                    ),
                    if (_accuracy >= 0.8) const Text('Excellent! +15 XP', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loadNextPhrase,
                      child: const Text('Next Phrase'),
                    )
                  ],
                  const Spacer(),
                ],
              ),
            ),
    );
  }
}
