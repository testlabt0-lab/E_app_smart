import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';
import '../data/mock_data.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import 'word_card_screen.dart';
import '../widgets/glass_card.dart';
import '../providers/user_provider.dart';

import 'story_reading_screen.dart';
import 'translator_screen.dart';
import 'grammar_checker_screen.dart';
import 'ar_translator_screen.dart';
import 'two_minute_rush_screen.dart';
import 'shadowing_screen.dart';
import 'adaptive_stories_screen.dart';
import 'placement_test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Word> _searchResults = [];
  late Word _wordOfTheDay;

  @override
  void initState() {
    super.initState();
    // Select a random Word of the Day (in a real app, this would be daily seeded)
    _wordOfTheDay = MockData.words[Random().nextInt(MockData.words.length)];
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final allWords = [...MockData.words, ...userProvider.customWords];

    setState(() {
      _searchResults = allWords.where((word) {
        return word.word.toLowerCase().contains(query.toLowerCase()) ||
               word.translation.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EFA Pro'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search words (English or Arabic)...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _searchResults.isNotEmpty
          ? _buildSearchResults()
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Word of the Day - Glassmorphism Card
          GlassCard(
            color: theme.colorScheme.primary,
            opacity: 0.15,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WordCardScreen(word: _wordOfTheDay))),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(_wordOfTheDay.emoji, style: const TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🌟 Word of the Day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange)),
                      Text(_wordOfTheDay.word, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                      Text(_wordOfTheDay.translation, style: TextStyle(fontSize: 16, color: isDark ? Colors.grey[400] : Colors.grey[700])),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: theme.colorScheme.primary),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // 2-Minute Rush Banner
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TwoMinuteRushScreen())),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFF5576C), Color(0xFFF093FB)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: const Row(
                children: [
                  Icon(Icons.bolt, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('2-Minute Rush', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Build your daily habit quickly!', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                  Icon(Icons.play_circle_fill, color: Colors.white, size: 36),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
          const Text('Learning Path', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),

          // Learning Path Timeline Map
          ...List.generate(MockData.categories.length + 1, (index) {
            if (index == MockData.categories.length) {
              // Custom Words Path Node
              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final customWords = Provider.of<UserProvider>(context, listen: false).customWords;
                        if (customWords.isNotEmpty) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryWordsScreen(
                            category: Category(id: 'custom', name: 'كلماتي', icon: '📝'),
                            isCustomWords: true,
                          )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No custom words added yet. Add some in Profile!')));
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary.withOpacity(0.15),
                              border: Border.all(color: theme.colorScheme.primary, width: 4),
                              boxShadow: [
                                BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 15, spreadRadius: 2)
                              ]
                            ),
                            child: const Center(child: Text('📝', style: TextStyle(fontSize: 36))),
                          ),
                          const SizedBox(height: 8),
                          const Text('My Words', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            final category = MockData.categories[index];
            bool isLeft = index % 2 == 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  if (!isLeft) const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (category.subcategories.isNotEmpty) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SubcategoryScreen(category: category)));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryWordsScreen(category: category)));
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.secondary.withOpacity(0.15),
                            border: Border.all(color: theme.colorScheme.secondary, width: 4),
                            boxShadow: [
                              BoxShadow(color: theme.colorScheme.secondary.withOpacity(0.3), blurRadius: 15, spreadRadius: 2)
                            ]
                          ),
                          child: Center(child: Text(category.icon, style: const TextStyle(fontSize: 36))),
                        ),
                        const SizedBox(height: 8),
                        Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  if (isLeft) const Spacer(),
                ],
              ),
            );
          }),

          const SizedBox(height: 32),
          const Text('Quick Tools', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),

          // Modern Action Cards
          _buildToolCard(context, 'Grammar Checker', 'Check your syntax instantly', Icons.spellcheck, Colors.teal, () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const GrammarCheckerScreen()));
          }),
          const SizedBox(height: 12),
          _buildToolCard(context, 'Shadowing Studio', 'Repeat and perfect your accent', Icons.mic_external_on, Colors.indigoAccent, () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const ShadowingScreen()));
          }),
          const SizedBox(height: 12),
          _buildToolCard(context, 'Smart Translator', 'Translate EN/AR offline', Icons.translate, Colors.purple, () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const TranslatorScreen()));
          }),
          const SizedBox(height: 12),
          _buildToolCard(context, 'Quick Phrases', 'Learn common sentences', Icons.chat_bubble_outline, Colors.blue, () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const PhrasesScreen()));
          }),
          const SizedBox(height: 12),
          _buildToolCard(context, 'Interactive Stories', 'Read and translate on tap', Icons.menu_book, Colors.orange, () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const AdaptiveStoriesScreen()));
          }),
          const SizedBox(height: 12),
          _buildToolCard(context, 'AR Camera Lens', 'Point at objects to learn', Icons.camera_alt, Colors.redAccent, () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const ArTranslatorScreen()));
          }),
          const SizedBox(height: 12),
          _buildToolCard(context, 'Placement Test', 'Find your exact level', Icons.school, Colors.green, () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const PlacementTestScreen()));
          }),
          const SizedBox(height: 12),
          _buildToolCard(context, 'Slangs & Idioms', 'Cultural immersion phrases', Icons.groups, Colors.pink, () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const PhrasesScreen(showOnlySlangs: true)));
          }),
        ],
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, String sub, IconData icon, Color color, VoidCallback onTap) {
    return GlassCard(
      opacity: 0.1,
      color: color,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(sub, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final word = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Text(word.emoji, style: const TextStyle(fontSize: 24)),
            title: Text(word.word, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(word.translation),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordCardScreen(word: word),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SubcategoryScreen extends StatelessWidget {
  final Category category;

  const SubcategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${category.icon} ${category.name} - Subcategories')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: category.subcategories.length,
        itemBuilder: (context, index) {
          final sub = category.subcategories[index];
          return Card(
            child: GlassCard(
              opacity: 0.1,
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryWordsScreen(category: category, subcategory: sub),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(sub.icon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 16),
                  Expanded(child: Text(sub.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryWordsScreen extends StatelessWidget {
  final Category category;
  final Subcategory? subcategory;
  final bool isCustomWords;

  const CategoryWordsScreen({super.key, required this.category, this.subcategory, this.isCustomWords = false});

  @override
  Widget build(BuildContext context) {
    List<Word> words = [];
    if (isCustomWords) {
      words = Provider.of<UserProvider>(context).customWords;
    } else {
      words = MockData.words.where((w) {
        bool matchCat = w.categoryId == category.id;
        if (subcategory != null) {
          return matchCat && w.subcategoryId == subcategory!.id;
        }
        return matchCat;
      }).toList();
    }

    String title = subcategory != null ? '${subcategory!.icon} ${subcategory!.name}' : '${category.icon} ${category.name}';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Text(word.emoji, style: const TextStyle(fontSize: 24)),
              title: Text(word.word, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(word.translation),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordCardScreen(word: word),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PhrasesScreen extends StatefulWidget {
  final bool showOnlySlangs;
  const PhrasesScreen({super.key, this.showOnlySlangs = false});

  @override
  State<PhrasesScreen> createState() => _PhrasesScreenState();
}

class _PhrasesScreenState extends State<PhrasesScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPhrases = widget.showOnlySlangs
      ? MockData.phrases.where((p) => p.context.toLowerCase().contains('idiom') || p.context.toLowerCase().contains('slang')).toList()
      : MockData.phrases;

    return Scaffold(
      appBar: AppBar(title: Text(widget.showOnlySlangs ? 'Slangs & Idioms' : 'Quick Phrases')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredPhrases.length,
        itemBuilder: (context, index) {
          final phrase = filteredPhrases[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          phrase.english,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.blue),
                        onPressed: () => flutterTts.speak(phrase.english),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(phrase.arabic, style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(child: Text(phrase.context, style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
