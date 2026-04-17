import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class UserProvider with ChangeNotifier {
  int _xp = 0;
  int _streak = 0;
  List<SavedItem> _savedItems = [];
  List<Word> _customWords = [];
  bool _isDarkMode = false;
  String _lastLoginDate = DateTime.now().toIso8601String().split('T')[0];

  int get xp => _xp;
  int get streak => _streak;
  List<SavedItem> get savedItems => _savedItems;
  List<Word> get customWords => _customWords;
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
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('xp', _xp);
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
      } else {
        item.interval = 1;
      }
      item.nextReviewDate = DateTime.now().add(Duration(days: item.interval));
      notifyListeners();
      _saveItemsToPrefs();
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
}
