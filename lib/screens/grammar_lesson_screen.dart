import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/models.dart';
import 'grammar_quiz_screen.dart';
import 'ai_pro_screen.dart';

class GrammarLessonScreen extends StatefulWidget {
  final GrammarLesson lesson;
  final String? nextLessonId;

  const GrammarLessonScreen({super.key, required this.lesson, this.nextLessonId});

  @override
  State<GrammarLessonScreen> createState() => _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends State<GrammarLessonScreen> {
  bool _showDetailed = false;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.4);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          Row(
            children: [
              const Text('Detailed', style: TextStyle(fontSize: 12)),
              Switch(
                value: _showDetailed,
                onChanged: (val) => setState(() => _showDetailed = val),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Text(
                _showDetailed ? widget.lesson.detailedExplanation : widget.lesson.summaryExplanation,
                style: const TextStyle(fontSize: 18, height: 1.6),
                textDirection: TextDirection.rtl,
              ),
            ),

            const SizedBox(height: 32),
            const Text('Examples:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            ...widget.lesson.examples.map((ex) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(ex, style: const TextStyle(fontSize: 18)),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.blue),
                    onPressed: () => _tts.speak(ex),
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(
                   builder: (_) => AiChatScreen(grammarContextPrompt: widget.lesson.aiPracticePrompt)
                 ));
              },
              icon: const Icon(Icons.smart_toy),
              label: const Text('Practice with AI Coach', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(
                   builder: (_) => GrammarQuizScreen(lesson: widget.lesson, nextLessonId: widget.nextLessonId)
                 ));
              },
              icon: const Icon(Icons.quiz),
              label: const Text('Take Post-Lesson Quiz to Unlock Next', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
