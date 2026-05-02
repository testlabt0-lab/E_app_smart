import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import 'grammar_lesson_screen.dart';

class GrammarPathScreen extends StatelessWidget {
  const GrammarPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Grammar Mastery Path 📚')),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: MockData.grammarLessons.length,
        itemBuilder: (context, index) {
          final lesson = MockData.grammarLessons[index];
          final isUnlocked = userProvider.unlockedGrammar.contains(lesson.id);

          bool isLeft = index % 2 == 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 32),
            child: Row(
              mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                if (!isLeft) const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (isUnlocked) {
                       Navigator.push(context, MaterialPageRoute(
                         builder: (_) => GrammarLessonScreen(
                           lesson: lesson,
                           nextLessonId: index + 1 < MockData.grammarLessons.length ? MockData.grammarLessons[index + 1].id : null
                         )
                       ));
                    } else {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complete previous lessons to unlock this one!')));
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 90, height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isUnlocked ? Colors.blue.shade100 : Colors.grey.shade300,
                          border: Border.all(color: isUnlocked ? Colors.blue : Colors.grey, width: 4),
                          boxShadow: isUnlocked ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15, spreadRadius: 2)] : [],
                        ),
                        child: Center(
                          child: Icon(
                            isUnlocked ? Icons.menu_book : Icons.lock,
                            size: 40,
                            color: isUnlocked ? Colors.blue : Colors.grey.shade600
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(lesson.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isUnlocked ? null : Colors.grey)),
                      Text('Level: ${lesson.levelId}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                if (isLeft) const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
