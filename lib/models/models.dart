class Word {
  final String id;
  final String word;
  final String translation;
  final String usage;
  final String example;
  final String emoji;
  final List<String> synonyms;
  final List<String> antonyms;
  final String ipa;
  final String categoryId;
  final String subcategoryId;
  final String levelId;

  Word({
    required this.id,
    required this.word,
    required this.translation,
    required this.usage,
    required this.example,
    required this.emoji,
    this.ipa = '',
    required this.synonyms,
    required this.antonyms,
    required this.categoryId,
    this.subcategoryId = '',
    required this.levelId,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      word: json['word'],
      translation: json['translation'],
      usage: json['usage'],
      example: json['example'],
      emoji: json['emoji'],
      ipa: json['ipa'] ?? '',
      synonyms: List<String>.from(json['synonyms']),
      antonyms: List<String>.from(json['antonyms']),
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'] ?? '',
      levelId: json['levelId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'translation': translation,
      'usage': usage,
      'example': example,
      'emoji': emoji,
      'ipa': ipa,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'levelId': levelId,
    };
  }
}

class Subcategory {
  final String id;
  final String categoryId;
  final String name;
  final String icon;

  Subcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.icon,
  });
}

class Category {
  final String id;
  final String name;
  final String icon;
  final List<Subcategory> subcategories;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.subcategories = const [],
  });
}

class Phrase {
  final String id;
  final String english;
  final String arabic;
  final String context;

  Phrase({
    required this.id,
    required this.english,
    required this.arabic,
    required this.context,
  });
}

class Level {
  final String id;
  final String name;
  final String colorHex;

  Level({
    required this.id,
    required this.name,
    required this.colorHex,
  });
}

class SavedItem {
  final String wordId;
  int interval;
  DateTime nextReviewDate;

  SavedItem({
    required this.wordId,
    this.interval = 1,
    DateTime? nextReviewDate,
  }) : nextReviewDate = nextReviewDate ?? DateTime.now().add(const Duration(days: 1));

  factory SavedItem.fromJson(Map<String, dynamic> json) {
    return SavedItem(
      wordId: json['wordId'],
      interval: json['interval'],
      nextReviewDate: DateTime.parse(json['nextReviewDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wordId': wordId,
      'interval': interval,
      'nextReviewDate': nextReviewDate.toIso8601String(),
    };
  }
}

class Story {
  final String id;
  final String title;
  final String content;
  final Map<String, String> vocabulary; // Difficult words and their translations

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.vocabulary,
  });
}
