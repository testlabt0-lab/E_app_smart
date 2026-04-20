import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/glass_card.dart';

class GrammarCheckerScreen extends StatefulWidget {
  const GrammarCheckerScreen({super.key});

  @override
  State<GrammarCheckerScreen> createState() => _GrammarCheckerScreenState();
}

class _GrammarCheckerScreenState extends State<GrammarCheckerScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isChecking = false;
  String _feedback = '';
  String _correctedText = '';

  Future<void> _checkGrammar() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isChecking = true;
      _feedback = '';
      _correctedText = '';
    });

    try {
      final url = Uri.parse('https://api.languagetool.org/v2/check');
      final response = await http.post(url, body: {
        'text': _controller.text,
        'language': 'en-US',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final matches = data['matches'] as List;

        if (matches.isEmpty) {
          _correctedText = _controller.text;
          _feedback = "Great job! No grammar issues found. ✅";
        } else {
          String tempText = _controller.text;
          int offsetAdjustment = 0;
          List<String> feedbacks = [];

          for (var match in matches) {
            int offset = match['offset'] + offsetAdjustment;
            int length = match['length'];
            String replacement = match['replacements'].isNotEmpty ? match['replacements'][0]['value'] : '';

            if (replacement.isNotEmpty) {
              tempText = tempText.replaceRange(offset, offset + length, replacement);
              offsetAdjustment += replacement.length - length;
            }
            feedbacks.add('• ${match['message']}');
          }

          _correctedText = tempText;
          _feedback = "I found some issues:\n${feedbacks.join('\n')}";
        }
      } else {
        _feedback = "Error analyzing text. Please try again.";
      }
    } catch (e) {
      _feedback = "Network error. Please check your internet connection.";
    }

    setState(() {
      _isChecking = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grammar Checker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Write a sentence or paragraph, and I will analyze it for grammatical errors.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            GlassCard(
              color: Colors.blue,
              opacity: 0.1,
              child: TextField(
                controller: _controller,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'e.g. He go to the market yesterday...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              text: _isChecking ? 'Analyzing...' : 'Check Grammar',
              icon: Icons.spellcheck,
              onPressed: _isChecking ? () {} : _checkGrammar,
            ),
            if (_isChecking) const Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            if (_correctedText.isNotEmpty) ...[
              const SizedBox(height: 40),
              const Text('Corrected Version:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GlassCard(
                color: Colors.green,
                opacity: 0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_correctedText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Text(_feedback, style: TextStyle(color: Colors.green.shade800)),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
