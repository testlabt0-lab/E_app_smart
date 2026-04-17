import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import 'word_card_screen.dart';

import 'story_reading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Word> _searchResults = [];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _searchResults = MockData.words.where((word) {
        return word.word.toLowerCase().contains(query.toLowerCase()) ||
               word.translation.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories & Levels', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
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
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
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
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Levels',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: MockData.levels.length,
                itemBuilder: (context, index) {
                  final level = MockData.levels[index];
                  final color = Color(int.parse(level.colorHex));
                  return Card(
                    color: color.withOpacity(0.2),
                    margin: const EdgeInsets.only(right: 12),
                    child: Container(
                      width: 140,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(level.id, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
                          const SizedBox(height: 8),
                          Text(level.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: MockData.categories.length,
              itemBuilder: (context, index) {
                final category = MockData.categories[index];
                return InkWell(
                  onTap: () {
                    if (category.subcategories.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubcategoryScreen(category: category),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryWordsScreen(category: category),
                        ),
                      );
                    }
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(category.icon, style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text(category.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blue.shade100,
              child: ListTile(
                leading: const Icon(Icons.chat, color: Colors.blue, size: 32),
                title: const Text('Quick Phrases', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: const Text('Learn common sentences quickly'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PhrasesScreen()));
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Interactive Stories',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: MockData.stories.length,
              itemBuilder: (context, index) {
                final story = MockData.stories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.menu_book, color: Colors.blue),
                    title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryReadingScreen(story: story),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
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
            child: ListTile(
              leading: Text(sub.icon, style: const TextStyle(fontSize: 24)),
              title: Text(sub.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryWordsScreen(category: category, subcategory: sub),
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

class CategoryWordsScreen extends StatelessWidget {
  final Category category;
  final Subcategory? subcategory;

  const CategoryWordsScreen({super.key, required this.category, this.subcategory});

  @override
  Widget build(BuildContext context) {
    final words = MockData.words.where((w) {
      bool matchCat = w.categoryId == category.id;
      if (subcategory != null) {
        return matchCat && w.subcategoryId == subcategory!.id;
      }
      return matchCat;
    }).toList();

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
  const PhrasesScreen({super.key});

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
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Phrases')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: MockData.phrases.length,
        itemBuilder: (context, index) {
          final phrase = MockData.phrases[index];
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
