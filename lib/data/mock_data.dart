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
    Category(
      id: 'tech',
      name: 'تقنية',
      icon: '💻',
      subcategories: [
        Subcategory(id: 'tech_prog', categoryId: 'tech', name: 'برمجة', icon: '👨‍💻'),
        Subcategory(id: 'tech_cyber', categoryId: 'tech', name: 'أمن سيبراني', icon: '🛡️'),
        Subcategory(id: 'tech_ai', categoryId: 'tech', name: 'ذكاء اصطناعي', icon: '🤖'),
      ],
    ),
    Category(
      id: 'health',
      name: 'صحة وطب',
      icon: '⚕️',
      subcategories: [
        Subcategory(id: 'health_anatomy', categoryId: 'health', name: 'تشريح', icon: '🦴'),
        Subcategory(id: 'health_pharm', categoryId: 'health', name: 'صيدلة', icon: '💊'),
      ],
    ),
    Category(id: 'business', name: 'أعمال', icon: '💼'),
    Category(id: 'travel', name: 'سفر', icon: '✈️'),
    Category(id: 'daily', name: 'حياة يومية', icon: '☀️'),
    Category(
      id: 'law',
      name: 'قضاء وسياسة',
      icon: '⚖️',
      subcategories: [
        Subcategory(id: 'law_court', categoryId: 'law', name: 'محاكم', icon: '🏛️'),
        Subcategory(id: 'law_politics', categoryId: 'law', name: 'سياسة', icon: '🗳️'),
      ],
    ),
    Category(
      id: 'economy',
      name: 'اقتصاد',
      icon: '📈',
    ),
    Category(
      id: 'food',
      name: 'فواكه وخضار',
      icon: '🍎',
      subcategories: [
        Subcategory(id: 'food_fruits', categoryId: 'food', name: 'فواكه', icon: '🍇'),
        Subcategory(id: 'food_veg', categoryId: 'food', name: 'خضار', icon: '🥦'),
      ],
    ),
  ];

  static List<Phrase> phrases = [
    Phrase(id: 'p1', english: 'Could you please speak a bit slower?', arabic: 'هل يمكنك التحدث ببطء قليلاً من فضلك؟', context: 'عندما لا تفهم شخصاً يتحدث بسرعة.'),
    Phrase(id: 'p2', english: 'I would like to order the daily special.', arabic: 'أود أن أطلب الطبق اليومي الخاص.', context: 'في المطعم عند الطلب.'),
    Phrase(id: 'p3', english: 'How much does this cost?', arabic: 'كم سعر هذا؟', context: 'أثناء التسوق.'),
    Phrase(id: 'p4', english: 'Can you help me find the nearest hospital?', arabic: 'هل يمكنك مساعدتي في العثور على أقرب مستشفى؟', context: 'في حالات الطوارئ أثناء السفر.'),
    Phrase(id: 'p5', english: 'I appreciate your help.', arabic: 'أقدر مساعدتك.', context: 'لشكر شخص ما بلباقة.'),

    // Slangs and Idioms for Cultural Immersion
    Phrase(id: 's1', english: 'Piece of cake', arabic: 'سهل جداً (قطعة كيك)', context: 'Idiom: When something is very easy to do.'),
    Phrase(id: 's2', english: 'Break a leg', arabic: 'حظاً موفقاً', context: 'Idiom: Used to wish someone good luck, especially before a performance.'),
    Phrase(id: 's3', english: 'Bite the bullet', arabic: 'تجرع السم / واجه الصعوبة', context: 'Idiom: To endure a painful or otherwise unpleasant situation that is seen as unavoidable.'),
    Phrase(id: 's4', english: 'Hang out', arabic: 'يقضي وقتاً / يتسكع', context: 'Slang: To spend time relaxing or socializing informally.'),
    Phrase(id: 's5', english: 'Spill the beans', arabic: 'أفشِ السر', context: 'Idiom: To reveal secret information unintentionally or indiscreetly.'),
  ];

  static List<TongueTwister> tongueTwisters = [
    TongueTwister(id: 't1', english: 'Peter Piper picked a peck of pickled peppers.', arabic: 'بيتر بايبر التقط كمية من الفلفل المخلل.'),
    TongueTwister(id: 't2', english: 'She sells seashells by the seashore.', arabic: 'تبيع صدف البحر بجوار شاطئ البحر.'),
    TongueTwister(id: 't3', english: 'I saw a kitten eating chicken in the kitchen.', arabic: 'رأيت قطة تأكل الدجاج في المطبخ.'),
    TongueTwister(id: 't4', english: 'How can a clam cram in a clean cream can?', arabic: 'كيف يمكن لمحار أن يحشر نفسه في علبة كريمة نظيفة؟'),
  ];

  static List<MinimalPair> minimalPairs = [
    MinimalPair(id: 'm1', word1: 'Park', word2: 'Bark', arabic1: 'حديقة', arabic2: 'ينبح'),
    MinimalPair(id: 'm2', word1: 'Ship', word2: 'Sheep', arabic1: 'سفينة', arabic2: 'خروف'),
    MinimalPair(id: 'm3', word1: 'Think', word2: 'Sink', arabic1: 'يفكر', arabic2: 'يغوص / حوض'),
    MinimalPair(id: 'm4', word1: 'Fan', word2: 'Van', arabic1: 'مروحة', arabic2: 'شاحنة مغلقة'),
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
      ipa: '/ˈæl.ɡə.rɪ.ðəm/',
      movieQuote: '"The Matrix algorithm is a complicated set of instructions." - The Matrix',
      categoryId: 'tech',
      subcategoryId: 'tech_prog',
      levelId: 'B2',
    ),
    Word(
      id: 'w_cyber',
      word: 'Firewall',
      translation: 'جدار حماية',
      usage: 'A network security system that monitors and controls network traffic.',
      example: 'The company installed a new firewall to prevent cyber attacks.',
      emoji: '🧱',
      synonyms: ['shield', 'barrier'],
      antonyms: [],
      ipa: '/ˈfaɪr.wɔːl/',
      categoryId: 'tech',
      subcategoryId: 'tech_cyber',
      levelId: 'B1',
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
      ipa: '/nəˌɡoʊ.ʃiˈeɪ.ʃən/',
      movieQuote: '"I am altering the deal. Pray I don\'t alter it any further." (A tough negotiation) - Star Wars',
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
      ipa: '/ˈsɪmp.təm/',
      categoryId: 'health',
      subcategoryId: 'health_anatomy',
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
      ipa: '/aɪˈtɪn.ə.rer.i/',
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
      ipa: '/ˈbrek.fəst/',
      movieQuote: '"What about second breakfast?" - The Lord of the Rings',
      categoryId: 'daily',
      levelId: 'A1',
    ),
    Word(
      id: 'w_law',
      word: 'Jurisdiction',
      translation: 'اختصاص قضائي',
      usage: 'The official power to make legal decisions and judgements.',
      example: 'The court has no jurisdiction in this case.',
      emoji: '⚖️',
      synonyms: ['authority', 'control'],
      antonyms: [],
      ipa: '/ˌdʒʊr.ɪsˈdɪk.ʃən/',
      categoryId: 'law',
      subcategoryId: 'law_court',
      levelId: 'C1',
    ),
    Word(
      id: 'w_econ',
      word: 'Inflation',
      translation: 'تضخم اقتصادي',
      usage: 'A general increase in prices and fall in the purchasing value of money.',
      example: 'High inflation is affecting the cost of living.',
      emoji: '📈',
      synonyms: ['expansion', 'increase'],
      antonyms: ['deflation'],
      ipa: '/ɪnˈfleɪ.ʃən/',
      categoryId: 'economy',
      levelId: 'B2',
    ),
    Word(
      id: 'w_veg',
      word: 'Broccoli',
      translation: 'بروكلي',
      usage: 'A cultivated variety of cabbage bearing heads of green or purplish flower buds.',
      example: 'I like to eat steamed broccoli for dinner.',
      emoji: '🥦',
      synonyms: [],
      antonyms: [],
      ipa: '/ˈbrɑː.kəl.i/',
      categoryId: 'food',
      subcategoryId: 'food_veg',
      levelId: 'A2',
    ),
  ];
}
