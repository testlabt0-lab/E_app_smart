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
    Category(
      id: 'family',
      name: 'العائلة',
      icon: '👨‍👩‍👧‍👦',
    ),
    Category(
      id: 'education',
      name: 'التعليم',
      icon: '🎓',
    ),
    Category(
      id: 'sports',
      name: 'الرياضة',
      icon: '⚽',
    ),
    Category(
      id: 'weather',
      name: 'الطقس',
      icon: '⛅',
    ),
    Category(
      id: 'emotions',
      name: 'المشاعر',
      icon: '😊',
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

  static List<GrammarLesson> grammarLessons = [
    GrammarLesson(
      id: 'g1',
      title: 'Present Simple (المضارع البسيط)',
      levelId: 'A1',
      summaryExplanation: '''نستخدم المضارع البسيط للتحدث عن العادات (Habits) والحقائق الثابتة (Facts).
نضيف (s) للفعل مع (He, She, It).''',
      detailedExplanation: '''زمن المضارع البسيط (Present Simple) هو من أهم الأزمنة في اللغة الإنجليزية.

1. التكوين (Form):
- مع الضمائر (I, You, We, They): نضع الفعل في المصدر بدون إضافات (Play, Eat).
- مع الضمائر (He, She, It): نضع للفعل حرف (s) أو (es) مثل (Plays, Eats, Goes).

2. النفي (Negative):
- نستخدم (don't) مع (I, You, We, They).
- نستخدم (doesn't) مع (He, She, It) ونعيد الفعل للمصدر.

3. الاستخدام (Usage):
- الحقائق العلمية: The sun rises in the east.
- العادات اليومية: I wake up at 7 AM every day.''',
      examples: [
        'I play tennis every Friday. (عادة)',
        'Water boils at 100 degrees. (حقيقة علمية)',
        'She doesn\'t like coffee. (نفي)'
      ],
      aiPracticePrompt: 'I want to practice the Present Simple tense. Ask me questions about my daily routine and hobbies, and politely correct me if I use the wrong verb tense.',
      quiz: [
        GrammarQuizQuestion(
          question: 'She ___ to school every day.',
          options: ['go', 'goes', 'going', 'gone'],
          correctAnswer: 'goes',
          explanation: 'مع الضمير She في المضارع البسيط نضيف es للفعل.',
        ),
        GrammarQuizQuestion(
          question: 'I ___ like playing football.',
          options: ['don\'t', 'doesn\'t', 'not', 'isn\'t'],
          correctAnswer: 'don\'t',
          explanation: 'مع الضمير I نستخدم don\'t للنفي.',
        ),
      ]
    ),
    GrammarLesson(
      id: 'g2',
      title: 'Past Simple (الماضي البسيط)',
      levelId: 'A2',
      summaryExplanation: '''نستخدم الماضي البسيط للتحدث عن حدث انتهى في الماضي في وقت محدد.
نضيف (ed) للفعل المنتظم، أو نستخدم التصريف الثاني للأفعال الشاذة.''',
      detailedExplanation: '''الماضي البسيط (Past Simple) يُعبر عن أحداث وقعت وانتهت بالكامل.

1. التكوين (Form):
- الأفعال المنتظمة: نضيف لها (ed) مثل (Played, Worked).
- الأفعال الشاذة: يتغير شكلها مثل (Go -> Went) و (See -> Saw).

2. النفي (Negative):
- نستخدم (didn't) مع جميع الضمائر، ويأتي بعدها الفعل في المصدر (بدون إضافات).

3. كلمات دلالية:
Yesterday, Last week, In 2010, Ago.''',
      examples: [
        'I visited my uncle last week. (فعل منتظم)',
        'They went to Paris in 2015. (فعل شاذ)',
        'He didn\'t watch the movie yesterday. (نفي ومصدر)'
      ],
      aiPracticePrompt: 'I want to practice the Past Simple tense. Ask me questions about what I did yesterday or during my last vacation, and correct my past tense verbs if I make mistakes.',
      quiz: [
        GrammarQuizQuestion(
          question: 'We ___ a great movie yesterday.',
          options: ['see', 'seeing', 'saw', 'seen'],
          correctAnswer: 'saw',
          explanation: 'الفعل see من الأفعال الشاذة، وتصريفه الثاني في الماضي هو saw.',
        ),
        GrammarQuizQuestion(
          question: 'He didn\'t ___ his homework.',
          options: ['finished', 'finishes', 'finish', 'finishing'],
          correctAnswer: 'finish',
          explanation: 'بعد didn\'t نستخدم دائماً الفعل في المصدر بدون أي إضافات.',
        ),
      ]
    ),
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
      id: 'w1', word: 'Algorithm', translation: 'خوارزمية',
      usage: 'A process or set of rules to be followed in calculations or other problem-solving operations.',
      example: 'The app uses a complex algorithm to recommend videos.', emoji: '🔢',
      partOfSpeech: 'noun', synonyms: ['procedure', 'routine'], antonyms: [],
      ipa: '/ˈæl.ɡə.rɪ.ðəm/', movieQuote: '"The Matrix algorithm is a complicated set of instructions." - The Matrix',
      categoryId: 'tech', subcategoryId: 'tech_prog', levelId: 'B2',
    ),
    Word(
      id: 'w_cyber', word: 'Firewall', translation: 'جدار حماية',
      usage: 'A network security system that monitors and controls network traffic.',
      example: 'The company installed a new firewall to prevent cyber attacks.', emoji: '🧱',
      partOfSpeech: 'noun', synonyms: ['shield', 'barrier'], antonyms: [],
      ipa: '/ˈfaɪr.wɔːl/', categoryId: 'tech', subcategoryId: 'tech_cyber', levelId: 'B1',
    ),
    Word(
      id: 'w_code', word: 'Compile', translation: 'يجمع برمجيًا',
      usage: 'Convert a program into a machine-code or lower-level form in which the program can be executed.',
      example: 'It takes a few minutes to compile the codebase.', emoji: '⚙️',
      partOfSpeech: 'verb', v2: 'Compiled', v3: 'Compiled',
      synonyms: ['assemble', 'build'], antonyms: ['decompile'],
      ipa: '/kəmˈpaɪl/', categoryId: 'tech', subcategoryId: 'tech_prog', levelId: 'B2',
    ),
    Word(
      id: 'w2', word: 'Negotiate', translation: 'يتفاوض',
      usage: 'Try to reach an agreement or compromise by discussion.',
      example: 'They are trying to negotiate a new contract.', emoji: '🤝',
      partOfSpeech: 'verb', v2: 'Negotiated', v3: 'Negotiated',
      synonyms: ['discuss', 'bargain'], antonyms: ['refuse'],
      ipa: '/nəˈɡoʊ.ʃi.eɪt/', movieQuote: '"I am altering the deal. Pray I don\'t alter it any further." - Star Wars',
      categoryId: 'business', levelId: 'C1',
    ),
    Word(
      id: 'w3', word: 'Symptom', translation: 'عَرَض',
      usage: 'A physical or mental feature which is regarded as indicating a condition of disease.',
      example: 'Fever is a common symptom of the flu.', emoji: '🤒',
      partOfSpeech: 'noun', synonyms: ['sign', 'indication'], antonyms: [],
      ipa: '/ˈsɪmp.təm/', categoryId: 'health', subcategoryId: 'health_anatomy', levelId: 'B1',
    ),
    Word(
      id: 'w_surg', word: 'Operate', translation: 'يجري عملية جراحية',
      usage: 'Perform a surgical operation.',
      example: 'The doctor will operate on him tomorrow morning.', emoji: '🥼',
      partOfSpeech: 'verb', v2: 'Operated', v3: 'Operated',
      synonyms: ['treat', 'perform surgery'], antonyms: [],
      ipa: '/ˈɑː.pə.reɪt/', categoryId: 'health', subcategoryId: 'health_pharm', levelId: 'B2',
    ),
    Word(
      id: 'w4', word: 'Itinerary', translation: 'مسار الرحلة',
      usage: 'A planned route or journey.',
      example: 'We planned a detailed itinerary for our trip to Europe.', emoji: '🗺️',
      partOfSpeech: 'noun', synonyms: ['schedule', 'plan', 'route'], antonyms: [],
      ipa: '/aɪˈtɪn.ə.rer.i/', categoryId: 'travel', levelId: 'B2',
    ),
    Word(
      id: 'w_fly', word: 'Depart', translation: 'يغادر',
      usage: 'Leave, typically in order to start a journey.',
      example: 'The flight will depart at 8 PM.', emoji: '🛫',
      partOfSpeech: 'verb', v2: 'Departed', v3: 'Departed',
      synonyms: ['leave', 'take off'], antonyms: ['arrive'],
      ipa: '/dɪˈpɑːrt/', categoryId: 'travel', levelId: 'A2',
    ),
    Word(
      id: 'w_law1', word: 'Testify', translation: 'يشهد',
      usage: 'Give evidence as a witness in a law court.',
      example: 'He was called to testify in the murder trial.', emoji: '✋',
      partOfSpeech: 'verb', v2: 'Testified', v3: 'Testified',
      synonyms: ['bear witness', 'swear'], antonyms: ['conceal'],
      ipa: '/ˈtes.tə.faɪ/', movieQuote: '"You want answers?! I think I am entitled to them!" - A Few Good Men',
      categoryId: 'law', subcategoryId: 'law_court', levelId: 'C1',
    ),
    Word(
      id: 'w_law2', word: 'Jurisdiction', translation: 'اختصاص قضائي',
      usage: 'The official power to make legal decisions and judgements.',
      example: 'The court has no jurisdiction in this case.', emoji: '⚖️',
      partOfSpeech: 'noun', synonyms: ['authority', 'control'], antonyms: [],
      ipa: '/ˌdʒʊr.ɪsˈdɪk.ʃən/', categoryId: 'law', subcategoryId: 'law_court', levelId: 'C1',
    ),
    Word(
      id: 'w_econ', word: 'Fluctuate', translation: 'يتذبذب',
      usage: 'Rise and fall irregularly in number or amount.',
      example: 'The stock market tends to fluctuate wildly.', emoji: '📉',
      partOfSpeech: 'verb', v2: 'Fluctuated', v3: 'Fluctuated',
      synonyms: ['vary', 'change'], antonyms: ['stabilize'],
      ipa: '/ˈflʌk.tʃu.eɪt/', categoryId: 'economy', levelId: 'C1',
    ),
    Word(
      id: 'w_veg', word: 'Broccoli', translation: 'بروكلي',
      usage: 'A cultivated variety of cabbage bearing heads of green or purplish flower buds.',
      example: 'I like to eat steamed broccoli for dinner.', emoji: '🥦',
      partOfSpeech: 'noun', synonyms: [], antonyms: [],
      ipa: '/ˈbrɑː.kəl.i/', categoryId: 'food', subcategoryId: 'food_veg', levelId: 'A2',
    ),
    Word(
      id: 'w_fam1', word: 'Sibling', translation: 'شقيق/شقيقة',
      usage: 'Each of two or more children or offspring having one or both parents in common.',
      example: 'I have three siblings: two brothers and one sister.', emoji: '👧👦',
      partOfSpeech: 'noun', synonyms: ['brother', 'sister'], antonyms: ['only child'],
      ipa: '/ˈsɪb.lɪŋ/', categoryId: 'family', levelId: 'B1',
    ),
    Word(
      id: 'w_fam2', word: 'Inherit', translation: 'يَرِث',
      usage: 'Receive money, property, or a title as an heir at the death of the previous holder.',
      example: 'She will inherit a large fortune from her grandfather.', emoji: '📜',
      partOfSpeech: 'verb', v2: 'Inherited', v3: 'Inherited',
      synonyms: ['receive', 'take over'], antonyms: ['lose', 'give away'],
      ipa: '/ɪnˈher.ɪt/', categoryId: 'family', levelId: 'B2',
    ),
    Word(
      id: 'w_edu', word: 'Comprehend', translation: 'يستوعب/يفهم',
      usage: 'Grasp mentally; understand.',
      example: 'He couldn\'t comprehend the complexity of the math problem.', emoji: '🧠',
      partOfSpeech: 'verb', v2: 'Comprehended', v3: 'Comprehended',
      synonyms: ['understand', 'grasp'], antonyms: ['misunderstand'],
      ipa: '/ˌkɑːm.prəˈhend/', categoryId: 'education', levelId: 'B2',
    ),
    Word(
      id: 'w_spo', word: 'Compete', translation: 'يتنافس',
      usage: 'Strive to gain or win something by defeating or establishing superiority over others.',
      example: 'Several teams will compete for the championship.', emoji: '🏆',
      partOfSpeech: 'verb', v2: 'Competed', v3: 'Competed',
      synonyms: ['contest', 'contend'], antonyms: ['cooperate'],
      ipa: '/kəmˈpiːt/', categoryId: 'sports', levelId: 'B1',
    ),
    Word(
      id: 'w_wea', word: 'Drizzle', translation: 'رذاذ/مطر خفيف',
      usage: 'Light rain falling in very fine drops.',
      example: 'It was starting to drizzle, so she grabbed her umbrella.', emoji: '🌧️',
      partOfSpeech: 'verb', v2: 'Drizzled', v3: 'Drizzled',
      synonyms: ['sprinkle', 'spit'], antonyms: ['pour'],
      ipa: '/ˈdrɪz.əl/', categoryId: 'weather', levelId: 'B2',
    ),
    Word(
      id: 'w_emo', word: 'Overwhelm', translation: 'يغمر/يقهر شعورياً',
      usage: 'Bury or drown beneath a huge mass.',
      example: 'She was overwhelmed by the amount of homework.', emoji: '😵',
      partOfSpeech: 'verb', v2: 'Overwhelmed', v3: 'Overwhelmed',
      synonyms: ['engulf', 'swamp'], antonyms: ['underwhelm'],
      ipa: '/ˌoʊ.vɚˈwelm/', categoryId: 'emotions', levelId: 'C1',
    ),
    Word(
      id: 'w_verb_irr1', word: 'Speak', translation: 'يتحدث',
      usage: 'Say something in order to convey information, an opinion, or a feeling.',
      example: 'Can you speak louder, please?', emoji: '🗣️',
      partOfSpeech: 'verb', v2: 'Spoke', v3: 'Spoken',
      synonyms: ['talk', 'say'], antonyms: ['listen', 'stay silent'],
      ipa: '/spiːk/', categoryId: 'daily', levelId: 'A1',
    ),
    Word(
      id: 'w_verb_irr2', word: 'Write', translation: 'يكتب',
      usage: 'Mark (letters, words, or other symbols) on a surface, typically paper.',
      example: 'I need to write a letter to my friend.', emoji: '✍️',
      partOfSpeech: 'verb', v2: 'Wrote', v3: 'Written',
      synonyms: ['pen', 'draft'], antonyms: ['read'],
      ipa: '/raɪt/', categoryId: 'daily', levelId: 'A1',
    ),
    Word(
      id: 'w_verb_irr3', word: 'Forget', translation: 'ينسى',
      usage: 'Fail to remember.',
      example: 'Don\'t forget your keys!', emoji: '🤷',
      partOfSpeech: 'verb', v2: 'Forgot', v3: 'Forgotten',
      synonyms: ['blank', 'overlook'], antonyms: ['remember'],
      ipa: '/fɚˈɡet/', categoryId: 'emotions', levelId: 'A2',
    ),
  ];
}
