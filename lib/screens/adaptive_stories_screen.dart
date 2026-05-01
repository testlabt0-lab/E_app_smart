import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/user_provider.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import 'story_reading_screen.dart';

class AdaptiveStoriesScreen extends StatefulWidget {
  const AdaptiveStoriesScreen({super.key});

  @override
  State<AdaptiveStoriesScreen> createState() => _AdaptiveStoriesScreenState();
}

class _AdaptiveStoriesScreenState extends State<AdaptiveStoriesScreen> {
  bool _isGenerating = false;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> _generateAdaptiveStory() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.mistakeWordIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to make some mistakes in games/practice first so I know what you need to learn!'))
      );
      return;
    }

    String? apiKey = await _secureStorage.read(key: 'ai_api_key');
    if (apiKey == null || apiKey.isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please set your Gemini API Key in Settings first.')));
      return;
    }

    setState(() => _isGenerating = true);

    // Fetch the actual words they failed on
    final allWords = [...MockData.words, ...userProvider.customWords];
    final weakWords = userProvider.mistakeWordIds.map((id) => allWords.firstWhere((w) => w.id == id, orElse: () => allWords.first)).toList();

    // Pick up to 5 weak words to focus the story on
    final targetWords = weakWords.take(5).map((w) => w.word).toList();

    final String prompt = '''
    Write a short, engaging story (about 100 words) in English.
    The story MUST naturally include these exact words: ${targetWords.join(', ')}.
    Keep the rest of the vocabulary simple (A2/B1 level).
    Return ONLY a JSON object with this exact structure, no markdown formatting or extra text:
    {
      "title": "A creative title here",
      "content": "The full story text here."
    }
    ''';

    try {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": prompt}]}],
          "generationConfig": {"temperature": 0.7}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String textResponse = data['candidates'][0]['content']['parts'][0]['text'];

        // Clean up markdown code blocks if AI included them
        textResponse = textResponse.replaceAll('```json', '').replaceAll('```', '').trim();

        final storyJson = jsonDecode(textResponse);

        // Create vocabulary map for the interactive translation
        Map<String, String> vocabMap = {};
        for (var w in weakWords) {
          vocabMap[w.word.toLowerCase()] = w.translation;
        }

        final generatedStory = Story(
          id: 'gen_${DateTime.now().millisecondsSinceEpoch}',
          title: storyJson['title'] ?? 'Your Adaptive Story',
          content: storyJson['content'] ?? '',
          vocabulary: vocabMap,
        );

        if (mounted) {
          setState(() => _isGenerating = false);
          Navigator.push(context, MaterialPageRoute(builder: (_) => StoryReadingScreen(story: generatedStory)));
        }
      } else {
        if (mounted) {
          setState(() => _isGenerating = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to generate story. API Error.')));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Stories')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_stories, size: 100, color: Colors.indigo),
              const SizedBox(height: 24),
              const Text(
                'Comprehensible Input (i+1)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'We will generate a unique story right now using Artificial Intelligence. This story will focus specifically on the words you have been struggling with in the Mistake Clinic.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              _isGenerating
                ? const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Writing your personal story... ✍️')
                    ],
                  )
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _generateAdaptiveStory,
                    icon: const Icon(Icons.magic_button),
                    label: const Text('Generate My Story', style: TextStyle(fontSize: 18)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
