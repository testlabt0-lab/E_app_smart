import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Commented out to prevent crashes without Firebase initialization
import '../models/models.dart';

class UserProvider with ChangeNotifier {
  int _xp = 0;
  int _streak = 0;
  List<SavedItem> _savedItems = [];
  List<Word> _customWords = [];
  List<String> _unlockedBadges = ['Newbie'];
  List<String> _mistakeWordIds = []; // The Mistake Clinic tracking
  Map<DateTime, int> _activityHeatmap = {}; // Real Activity Heatmap tracking
  bool _isDarkMode = false;
  String _lastLoginDate = DateTime.now().toIso8601String().split('T')[0];

  int get xp => _xp;
  int get streak => _streak;
  List<SavedItem> get savedItems => _savedItems;
  List<Word> get customWords => _customWords;
  List<String> get unlockedBadges => _unlockedBadges;
  List<String> get mistakeWordIds => _mistakeWordIds;
  Map<DateTime, int> get activityHeatmap => _activityHeatmap;
  bool get isDarkMode => _isDarkMode;

  UserProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _xp = prefs.getInt('xp') ?? 0;
    _streak = prefs.getInt('streak') ?? 0;
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _lastLoginDate = prefs.getString('lastLoginDate') ?? DateTime.now().toIso8601String().split('T')[0];

    final savedItemsJson = prefs.getStringList('savedItems') ?? [];
    _savedItems = savedItemsJson.map((e) => SavedItem.fromJson(json.decode(e))).toList();

    final customWordsJson = prefs.getStringList('customWords') ?? [];
    _customWords = customWordsJson.map((e) => Word.fromJson(json.decode(e))).toList();

    _unlockedBadges = prefs.getStringList('badges') ?? ['Newbie'];
    _mistakeWordIds = prefs.getStringList('mistakes') ?? [];

    final heatmapJson = prefs.getString('heatmap');
    if (heatmapJson != null) {
      final decodedMap = json.decode(heatmapJson) as Map<String, dynamic>;
      _activityHeatmap = decodedMap.map((key, value) => MapEntry(DateTime.parse(key), value as int));
    }

    _checkStreak();
    notifyListeners();
  }

  void _checkStreak() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    if (_lastLoginDate != today) {
      final lastLogin = DateTime.parse(_lastLoginDate);
      final difference = DateTime.now().difference(lastLogin).inDays;
      if (difference == 1) {
        _streak++;
      } else if (difference > 1) {
        _streak = 1; // Reset streak, but start at 1 for today
      }
      _lastLoginDate = today;
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('streak', _streak);
      prefs.setString('lastLoginDate', _lastLoginDate);
      notifyListeners();
    }
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  void addXp(int amount) async {
    _xp += amount;
    _checkBadges();
    _logActivity();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('xp', _xp);
  }

  void _logActivity() async {
    final today = DateTime.now();
    // Normalize to midnight
    final dateKey = DateTime(today.year, today.month, today.day);
    _activityHeatmap[dateKey] = (_activityHeatmap[dateKey] ?? 0) + 1;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final stringMap = _activityHeatmap.map((key, value) => MapEntry(key.toIso8601String(), value));
    prefs.setString('heatmap', json.encode(stringMap));
  }

  void _checkBadges() async {
    bool newlyUnlocked = false;
    if (_xp >= 100 && !_unlockedBadges.contains('Centurion')) {
      _unlockedBadges.add('Centurion');
      newlyUnlocked = true;
    }
    if (_xp >= 500 && !_unlockedBadges.contains('Speed Demon')) {
      _unlockedBadges.add('Speed Demon');
      newlyUnlocked = true;
    }
    if (_streak >= 7 && !_unlockedBadges.contains('7 Day Streak')) {
      _unlockedBadges.add('7 Day Streak');
      newlyUnlocked = true;
    }
    if (_savedItems.length >= 10 && !_unlockedBadges.contains('Bookworm')) {
      _unlockedBadges.add('Bookworm');
      newlyUnlocked = true;
    }

    if (newlyUnlocked) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('badges', _unlockedBadges);
    }
  }

  void saveWord(String wordId) async {
    if (!_savedItems.any((item) => item.wordId == wordId)) {
      _savedItems.add(SavedItem(wordId: wordId));
      notifyListeners();
      _saveItemsToPrefs();
    }
  }

  void removeSavedWord(String wordId) async {
    _savedItems.removeWhere((item) => item.wordId == wordId);
    notifyListeners();
    _saveItemsToPrefs();
  }

  void updateReview(String wordId, bool isCorrect) async {
    final index = _savedItems.indexWhere((item) => item.wordId == wordId);
    if (index != -1) {
      final item = _savedItems[index];
      if (isCorrect) {
        item.interval *= 2;
        removeMistake(wordId); // Remove from clinic if they got it right
      } else {
        item.interval = 1;
        logMistake(wordId); // Add to clinic if they got it wrong
      }
      item.nextReviewDate = DateTime.now().add(Duration(days: item.interval));
      notifyListeners();
      _saveItemsToPrefs();
    }
  }

  void logMistake(String wordId) async {
    if (!_mistakeWordIds.contains(wordId)) {
      _mistakeWordIds.add(wordId);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('mistakes', _mistakeWordIds);
    }
  }

  void removeMistake(String wordId) async {
    if (_mistakeWordIds.contains(wordId)) {
      _mistakeWordIds.remove(wordId);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('mistakes', _mistakeWordIds);
    }
  }

  void addCustomWord(Word word) async {
    _customWords.add(word);
    notifyListeners();
    _saveCustomWordsToPrefs();
  }

  void removeCustomWord(String wordId) async {
    _customWords.removeWhere((item) => item.id == wordId);
    notifyListeners();
    _saveCustomWordsToPrefs();
  }

  Future<void> _saveItemsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _savedItems.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList('savedItems', jsonList);
  }

  Future<void> _saveCustomWordsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _customWords.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList('customWords', jsonList);
  }

  // --- Mock Cloud Sync Implementation (Safe Fallback) ---
  // Revert to mocked implementation to prevent app crash without valid google-services.json
  Future<bool> syncWithCloud(String email, String uid) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful sync payload logic
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('xp', _xp);
      prefs.setInt('streak', _streak);
      prefs.setStringList('badges', _unlockedBadges);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Cloud sync failed: $e');
      return false;
    }
  }
}
