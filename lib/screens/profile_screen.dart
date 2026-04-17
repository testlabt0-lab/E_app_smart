import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../providers/user_provider.dart';
import '../models/models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _englishWord = '';
  String _arabicTranslation = '';
  String _exampleSentence = '';

  void _showAddCustomWordDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Custom Word'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'English Word'),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    onSaved: (value) => _englishWord = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Arabic Translation'),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    onSaved: (value) => _arabicTranslation = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Example Sentence'),
                    onSaved: (value) => _exampleSentence = value ?? '',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newWord = Word(
                    id: const Uuid().v4(),
                    word: _englishWord,
                    translation: _arabicTranslation,
                    usage: '',
                    example: _exampleSentence,
                    emoji: '📝',
                    synonyms: [],
                    antonyms: [],
                    categoryId: 'custom',
                    levelId: 'custom',
                  );
                  userProvider.addCustomWord(newWord);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Custom word added!')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Calculate mastery data for pie chart based on spaced repetition intervals
    int beginner = 0, intermediate = 0, advanced = 0;
    for (var item in userProvider.savedItems) {
      if (item.interval <= 2) beginner++;
      else if (item.interval <= 7) intermediate++;
      else advanced++;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Stats'),
        actions: [
          IconButton(
            icon: Icon(userProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => userProvider.toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            Text('Learner Profile', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(context, 'Total XP', '${userProvider.xp}', Icons.star, Colors.amber),
                _buildStatCard(context, 'Day Streak', '${userProvider.streak}', Icons.local_fire_department, Colors.orange),
                _buildStatCard(context, 'Saved Words', '${userProvider.savedItems.length}', Icons.bookmark, Colors.blue),
              ],
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(context, 'Total XP', '${userProvider.xp}', Icons.star, Colors.amber),
                _buildStatCard(context, 'Day Streak', '${userProvider.streak}', Icons.local_fire_department, Colors.orange),
                _buildStatCard(context, 'Custom Words', '${userProvider.customWords.length}', Icons.edit_note, Colors.purple),
              ],
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _exportData(userProvider),
              icon: const Icon(Icons.download),
              label: const Text('Export Dictionary (CSV)'),
            ),

            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Study Heatmap (Mock)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            _buildMockHeatmap(),

            const SizedBox(height: 32),
            if (userProvider.savedItems.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Word Mastery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      if (beginner > 0) PieChartSectionData(value: beginner.toDouble(), title: 'Beginner', color: Colors.red.shade300, radius: 50),
                      if (intermediate > 0) PieChartSectionData(value: intermediate.toDouble(), title: 'Learning', color: Colors.orange.shade300, radius: 50),
                      if (advanced > 0) PieChartSectionData(value: advanced.toDouble(), title: 'Mastered', color: Colors.green.shade300, radius: 50),
                    ],
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Weekly XP (Mock Data)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
                          Widget text;
                          switch (value.toInt()) {
                            case 0: text = const Text('Mon', style: style); break;
                            case 1: text = const Text('Tue', style: style); break;
                            case 2: text = const Text('Wed', style: style); break;
                            case 3: text = const Text('Thu', style: style); break;
                            case 4: text = const Text('Fri', style: style); break;
                            case 5: text = const Text('Sat', style: style); break;
                            case 6: text = const Text('Sun', style: style); break;
                            default: text = const Text('', style: style); break;
                          }
                          return SideTitleWidget(axisSide: meta.axisSide, child: text);
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 20, color: Colors.blue)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 50, color: Colors.blue)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 30, color: Colors.blue)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 80, color: Colors.blue)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 40, color: Colors.blue)]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 90, color: Colors.blue)]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 10, color: Colors.blue)]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Daily Missions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.grey),
              title: const Text('Earn 50 XP today'),
              trailing: Text('${userProvider.xp}/50'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Review 5 Flashcards', style: TextStyle(decoration: TextDecoration.lineThrough)),
              trailing: Text('5/5'),
            ),

            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Leaderboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            _buildLeaderboardItem(1, 'Ahmed', 1250, false),
            _buildLeaderboardItem(2, 'Sarah', 980, false),
            _buildLeaderboardItem(3, 'You', userProvider.xp, true),
            _buildLeaderboardItem(4, 'Omar', 420, false),

            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _showAddCustomWordDialog(context, userProvider),
              icon: const Icon(Icons.add),
              label: const Text('Add Custom Word'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(int rank, String name, int xp, bool isCurrentUser) {
    return ListTile(
      tileColor: isCurrentUser ? Colors.blue.withOpacity(0.1) : null,
      leading: CircleAvatar(
        backgroundColor: rank == 1 ? Colors.amber : (rank == 2 ? Colors.grey.shade300 : (rank == 3 ? Colors.orangeAccent : Colors.blue)),
        child: Text('$rank', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
      title: Text(name, style: TextStyle(fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal)),
      trailing: Text('$xp XP', style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Future<void> _exportData(UserProvider userProvider) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_dictionary.csv');

      String csvContent = 'Word,Translation,Example\n';
      for (var w in userProvider.customWords) {
        csvContent += '${w.word},${w.translation},${w.example}\n';
      }

      await file.writeAsString(csvContent);
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to export data')));
      }
    }
  }

  Widget _buildMockHeatmap() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 14,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 42, // Last 6 weeks mock
      itemBuilder: (context, index) {
        int intensity = (index % 5) * 50; // Mock intensity
        return Container(
          decoration: BoxDecoration(
            color: intensity == 0 ? Colors.grey.shade300 : Colors.green.shade500.withOpacity(intensity / 200),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
