import '../models/models.dart';

class MockData {
  static List<Level> levels = [
    Level(id: 'A1', name: 'Pre-A1 Beginner', colorHex: '0xFF4CAF50'),
    Level(id: 'A2', name: 'A2 Elementary', colorHex: '0xFF8BC34A'),
    Level(id: 'B1', name: 'B1 Intermediate', colorHex: '0xFFFFC107'),
    Level(id: 'B2', name: 'B2 Upper Intermediate', colorHex: '0xFFFF9800'),
    Level(id: 'C1', name: 'C1 Advanced', colorHex: '0xFFF44336'),
    Level(id: 'C2', name: 'C2 Mastery', colorHex: '0xFF9C27B0'),
  ];

  static List<Category> categories = [
    Category(id: 'tech', name: 'تقنية', icon: '💻'),
    Category(id: 'business', name: 'أعمال', icon: '💼'),
    Category(id: 'health', name: 'صحة', icon: '⚕️'),
    Category(id: 'travel', name: 'سفر', icon: '✈️'),
    Category(id: 'daily', name: 'حياة يومية', icon: '☀️'),
  ];

  static List<Story> stories = [
    Story(
      id: 's1',
      title: 'A Day at the Park',
      content: 'The sun was shining brightly in the sky. Children were playing on the swings while their parents sat on the benches. A small dog chased a red ball across the green grass. Everyone felt happy and relaxed in the beautiful weather.',
      vocabulary: {
        'brightly': 'بسطوع',
        'swings': 'أراجيح',
        'benches': 'مقاعد',
        'chased': 'طارد',
        'relaxed': 'مسترخٍ',
      },
    ),
    Story(
      id: 's2',
      title: 'The Busy Airport',
      content: 'The airport was crowded with travelers dragging heavy luggage. The departure board displayed flights to London, Tokyo, and Dubai. An announcement echoed through the speakers, reminding passengers to proceed to their boarding gates immediately.',
      vocabulary: {
        'crowded': 'مزدحم',
        'dragging': 'يجر',
        'luggage': 'أمتعة',
        'departure': 'مغادرة',
        'echoed': 'تردد صداه',
        'passengers': 'ركاب',
        'boarding': 'صعود (للطائرة)',
      },
    )
  ];

  static List<Word> words = [
    Word(
      id: 'w1',
      word: 'Algorithm',
      translation: 'خوارزمية',
      usage: 'A process or set of rules to be followed in calculations or other problem-solving operations.',
      example: 'The app uses a complex algorithm to recommend videos.',
      emoji: '🔢',
      synonyms: ['procedure', 'routine'],
      antonyms: [],
      categoryId: 'tech',
      levelId: 'B2',
    ),
    Word(
      id: 'w2',
      word: 'Negotiation',
      translation: 'تفاوض',
      usage: 'Discussion aimed at reaching an agreement.',
      example: 'They are in negotiations to buy the company.',
      emoji: '🤝',
      synonyms: ['discussion', 'bargaining'],
      antonyms: ['disagreement'],
      categoryId: 'business',
      levelId: 'C1',
    ),
    Word(
      id: 'w3',
      word: 'Symptom',
      translation: 'عَرَض',
      usage: 'A physical or mental feature which is regarded as indicating a condition of disease.',
      example: 'Fever is a common symptom of the flu.',
      emoji: '🤒',
      synonyms: ['sign', 'indication'],
      antonyms: [],
      categoryId: 'health',
      levelId: 'B1',
    ),
    Word(
      id: 'w4',
      word: 'Itinerary',
      translation: 'مسار الرحلة',
      usage: 'A planned route or journey.',
      example: 'We planned a detailed itinerary for our trip to Europe.',
      emoji: '🗺️',
      synonyms: ['schedule', 'plan', 'route'],
      antonyms: [],
      categoryId: 'travel',
      levelId: 'B2',
    ),
    Word(
      id: 'w5',
      word: 'Breakfast',
      translation: 'إفطار',
      usage: 'A meal eaten in the morning, the first of the day.',
      example: 'I usually have eggs and toast for breakfast.',
      emoji: '🍳',
      synonyms: [],
      antonyms: ['dinner'],
      categoryId: 'daily',
      levelId: 'A1',
    ),
  ];
}
