import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/models.dart';

class StoryReadingScreen extends StatefulWidget {
  final Story story;

  const StoryReadingScreen({super.key, required this.story});

  @override
  State<StoryReadingScreen> createState() => _StoryReadingScreenState();
}

class _StoryReadingScreenState extends State<StoryReadingScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  void _handleWordTap(String word) {
    // Strip punctuation for matching
    String cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();

    _flutterTts.speak(cleanWord);

    if (widget.story.vocabulary.containsKey(cleanWord)) {
      _showTranslationTooltip(cleanWord, widget.story.vocabulary[cleanWord]!);
    }
  }

  void _showTranslationTooltip(String word, String translation) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.translate, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              '$word: $translation',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.story.content.split(' ');

    return Scaffold(
      appBar: AppBar(title: Text(widget.story.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tap any word to hear it. Difficult words will show their translation.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 4.0,
              runSpacing: 8.0,
              children: words.map((word) {
                String cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();
                bool isVocab = widget.story.vocabulary.containsKey(cleanWord);

                return GestureDetector(
                  onTap: () => _handleWordTap(word),
                  child: Text(
                    '$word ',
                    style: TextStyle(
                      fontSize: 22,
                      height: 1.5,
                      color: isVocab ? Colors.blue : null,
                      fontWeight: isVocab ? FontWeight.bold : FontWeight.normal,
                      decoration: isVocab ? TextDecoration.underline : TextDecoration.none,
                      decorationColor: Colors.blue,
                      decorationStyle: TextDecorationStyle.dotted,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
