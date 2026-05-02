import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
  late stt.SpeechToText _speech;
  bool _isSpeaking = false;
  bool _showAdvanced = false;
  bool _isListening = false;
  String _spokenText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _spokenText = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _evaluateSpeech();
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _evaluateSpeech() {
    if (_spokenText.isEmpty) return;

    // Simple comparison logic
    String target = widget.word.word.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    String spoken = _spokenText.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');

    if (spoken.contains(target)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excellent pronunciation! +10 XP'), backgroundColor: Colors.green),
      );
      Provider.of<UserProvider>(context, listen: false).addXp(10);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You said: $_spokenText. Try again!'), backgroundColor: Colors.orange),
      );
    }
    setState(() => _isListening = false);
    _speech.stop();
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
            if (widget.word.ipa.isNotEmpty)
              Center(
                child: Text(
                  widget.word.ipa,
                  style: TextStyle(fontSize: 18, color: Colors.blue.shade300, fontStyle: FontStyle.italic),
                ),
              ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.5)),
                ),
                child: Text(
                  widget.word.partOfSpeech.toUpperCase(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
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
                  onPressed: _listen,
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  label: Text(_isListening ? 'Listening...' : 'Speak'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _isListening ? Colors.red : null,
                    side: BorderSide(color: _isListening ? Colors.red : Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),

            if (widget.word.partOfSpeech.toLowerCase() == 'verb' && widget.word.v2.isNotEmpty) ...[
              const Text('Verb Conjugations:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildVerbConjugation('V1 (Base)', widget.word.word),
                  _buildVerbConjugation('V2 (Past)', widget.word.v2),
                  _buildVerbConjugation('V3 (Participle)', widget.word.v3),
                ],
              ),
              const SizedBox(height: 20),
            ],

            const Text('Meaning:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.word.usage, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Example:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('"${widget.word.example}"', style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),

            if (widget.word.movieQuote.isNotEmpty) ...[
              const SizedBox(height: 20),
              GlassCard(
                color: Colors.amber,
                opacity: 0.1,
                child: Row(
                  children: [
                    const Icon(Icons.movie_creation, color: Colors.amber, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Movie Context', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.amber)),
                          const SizedBox(height: 4),
                          Text(widget.word.movieQuote, style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

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

  Widget _buildVerbConjugation(String label, String verb) {
    return Expanded(
      child: Card(
        color: Colors.indigo.withOpacity(0.05),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.indigo.withOpacity(0.2))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.indigo)),
              const SizedBox(height: 4),
              Text(verb.isEmpty ? '-' : verb, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (verb.isNotEmpty)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.volume_up, size: 16, color: Colors.indigo),
                  onPressed: () => _speak(verb),
                )
            ],
          ),
        ),
      ),
    );
  }
}
