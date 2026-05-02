import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/user_provider.dart';

class GrammarQuizScreen extends StatefulWidget {
  final GrammarLesson lesson;
  final String? nextLessonId;

  const GrammarQuizScreen({super.key, required this.lesson, this.nextLessonId});

  @override
  State<GrammarQuizScreen> createState() => _GrammarQuizScreenState();
}

class _GrammarQuizScreenState extends State<GrammarQuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String _selectedOption = '';

  void _submitAnswer(String option) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _selectedOption = option;
      if (option == widget.lesson.quiz[_currentIndex].correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.lesson.quiz.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _selectedOption = '';
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Pass condition: 100% since it's a short quiz
    if (_score == widget.lesson.quiz.length) {
      userProvider.addXp(100);
      userProvider.scheduleGrammarReview(widget.lesson.id);

      if (widget.nextLessonId != null) {
        userProvider.unlockGrammarLesson(widget.nextLessonId!);
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('🎉 Perfect Score!'),
          content: Text('You mastered ${widget.lesson.title} and earned 100 XP! The next lesson is now unlocked.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // dialog
                Navigator.pop(context); // quiz
                Navigator.pop(context); // lesson
              },
              child: const Text('Back to Path'),
            )
          ],
        )
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Almost there!'),
          content: Text('You scored $_score/${widget.lesson.quiz.length}. You need a perfect score to unlock the next lesson. Review the rules and try again!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // dialog
                Navigator.pop(context); // quiz
              },
              child: const Text('Review Lesson'),
            )
          ],
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.lesson.quiz[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz: ${widget.lesson.title}')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Question ${_currentIndex + 1} of ${widget.lesson.quiz.length}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Text(question.question, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            ...question.options.map((opt) {
              Color btnColor = Colors.white;
              Color textColor = Colors.black;

              if (_isAnswered) {
                if (opt == question.correctAnswer) {
                  btnColor = Colors.green;
                  textColor = Colors.white;
                } else if (opt == _selectedOption) {
                  btnColor = Colors.red;
                  textColor = Colors.white;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: btnColor,
                    foregroundColor: textColor,
                    side: const BorderSide(color: Colors.grey),
                  ),
                  onPressed: () => _submitAnswer(opt),
                  child: Text(opt, style: const TextStyle(fontSize: 18)),
                ),
              );
            }),

            if (_isAnswered) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedOption == question.correctAnswer ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _selectedOption == question.correctAnswer ? Colors.green : Colors.red),
                ),
                child: Text(
                  question.explanation,
                  style: const TextStyle(fontSize: 16),
                  textDirection: TextDirection.rtl,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                onPressed: _nextQuestion,
                child: const Text('Next', style: TextStyle(fontSize: 18)),
              )
            ]
          ],
        ),
      ),
    );
  }
}
