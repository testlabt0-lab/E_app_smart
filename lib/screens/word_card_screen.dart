import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/models.dart';
import '../providers/user_provider.dart';

class WordCardScreen extends StatefulWidget {
  final Word word;

  const WordCardScreen({super.key, required this.word});

  @override
  State<WordCardScreen> createState() => _WordCardScreenState();
}

class _WordCardScreenState extends State<WordCardScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _showAdvanced = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setStartHandler(() {
      if(mounted) setState(() => _isSpeaking = true);
    });
    flutterTts.setCompletionHandler(() {
      if(mounted) setState(() => _isSpeaking = false);
    });
    flutterTts.setErrorHandler((msg) {
      if(mounted) setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isSaved = userProvider.savedItems.any((item) => item.wordId == widget.word.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Details'),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            color: isSaved ? Colors.blue : null,
            onPressed: () {
              if (isSaved) {
                userProvider.removeSavedWord(widget.word.id);
              } else {
                userProvider.saveWord(widget.word.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Word saved for spaced repetition!')),
                );
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(widget.word.emoji, style: const TextStyle(fontSize: 80)),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                widget.word.word,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                widget.word.translation,
                style: const TextStyle(fontSize: 24, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _speak(widget.word.word),
                  icon: Icon(_isSpeaking ? Icons.volume_up : Icons.volume_up_outlined),
                  label: const Text('Listen'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // Mock Speech Recognition feature
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mock Speech Eval: Pronunciation 85% Correct!')),
                    );
                    userProvider.addXp(10);
                  },
                  icon: const Icon(Icons.mic),
                  label: const Text('Speak'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            const Text('Meaning:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.word.usage, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Example:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('"${widget.word.example}"', style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),

            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _showAdvanced = !_showAdvanced;
                });
              },
              icon: Icon(_showAdvanced ? Icons.expand_less : Icons.expand_more),
              label: Text(_showAdvanced ? 'Hide Advanced Details' : 'Show Advanced Details'),
            ),

            if (_showAdvanced) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Synonyms:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: widget.word.synonyms.map((s) => Chip(label: Text(s))).toList(),
                    ),
                    const SizedBox(height: 10),
                    const Text('Antonyms:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: widget.word.antonyms.map((a) => Chip(label: Text(a))).toList(),
                    ),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
