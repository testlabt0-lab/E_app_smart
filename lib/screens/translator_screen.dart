import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final GoogleTranslator _translator = GoogleTranslator();
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _inputController = TextEditingController();

  String _translatedText = '';
  bool _isEnglishToArabic = true;
  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _translate() async {
    if (_inputController.text.isEmpty) {
      setState(() => _translatedText = '');
      return;
    }

    setState(() => _isTranslating = true);

    try {
      final translation = await _translator.translate(
        _inputController.text,
        from: _isEnglishToArabic ? 'en' : 'ar',
        to: _isEnglishToArabic ? 'ar' : 'en',
      );

      setState(() {
        _translatedText = translation.text;
      });
    } catch (e) {
      setState(() {
        _translatedText = 'Error connecting to translation service.';
      });
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  void _swapLanguages() {
    setState(() {
      _isEnglishToArabic = !_isEnglishToArabic;
      // Swap the text
      String temp = _inputController.text;
      _inputController.text = _translatedText;
      _translatedText = temp;
    });
  }

  Future<void> _speakText(String text, bool isEnglish) async {
    await _flutterTts.setLanguage(isEnglish ? "en-US" : "ar-SA");
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Translator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Language Swap Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_isEnglishToArabic ? 'English' : 'Arabic', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.swap_horiz, size: 32, color: Colors.blue),
                  onPressed: _swapLanguages,
                ),
                Text(_isEnglishToArabic ? 'Arabic' : 'English', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),

            // Input Box
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            hintText: 'Enter text to translate...',
                            border: InputBorder.none,
                          ),
                          onChanged: (val) => _translate(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.volume_up, color: Colors.blue),
                            onPressed: () => _speakText(_inputController.text, _isEnglishToArabic),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _inputController.clear();
                              setState(() => _translatedText = '');
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            if (_isTranslating) const LinearProgressIndicator(),
            const SizedBox(height: 16),

            // Output Box
            Expanded(
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _translatedText.isEmpty ? 'Translation will appear here' : _translatedText,
                            style: TextStyle(
                              fontSize: 20,
                              color: _translatedText.isEmpty ? Colors.grey : null
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.volume_up, color: Colors.blue),
                            onPressed: () => _speakText(_translatedText, !_isEnglishToArabic),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.blue),
                            onPressed: () {
                              if (_translatedText.isNotEmpty) {
                                Clipboard.setData(ClipboardData(text: _translatedText));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
