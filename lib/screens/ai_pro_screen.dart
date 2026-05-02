import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class AiProScreen extends StatelessWidget {
  const AiProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI & Pro Features', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProFeatureCard(
            context,
            'AI Conversation Partner',
            'Chat with an AI to practice real-life scenarios (e.g., Hotel Reception).',
            Icons.chat_bubble_outline,
            Colors.purple,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AiChatScreen())),
          ),
          const SizedBox(height: 16),
          _buildProFeatureCard(
            context,
            'Dynamic AI Stories',
            'AI generates a unique story daily based on words you are struggling with.',
            Icons.menu_book,
            Colors.teal,
            () => _showComingSoonDialog(context, 'Dynamic AI Stories'),
          ),
          const SizedBox(height: 16),
          _buildProFeatureCard(
            context,
            'AR Camera Translator',
            'Point your camera at real-world objects to learn their English names.',
            Icons.view_in_ar,
            Colors.indigo,
            () => _showComingSoonDialog(context, 'AR Camera Translator'),
          ),
          const SizedBox(height: 16),
          _buildProFeatureCard(
            context,
            'Adaptive Placement Test',
            'Take a smart test that adapts to your answers to find your true level.',
            Icons.assessment,
            Colors.deepOrange,
            () => _showComingSoonDialog(context, 'Adaptive Placement Test'),
          ),
        ],
      ),
    );
  }

  Widget _buildProFeatureCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 36, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature (Coming Soon)'),
        content: const Text('This Pro feature is currently under development. Stay tuned for the next update!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }
}

class AiChatScreen extends StatefulWidget {
  final String? grammarContextPrompt;

  const AiChatScreen({super.key, this.grammarContextPrompt});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late stt.SpeechToText _speech;
  final FlutterTts _tts = FlutterTts();

  String _apiKey = '';
  bool _isListening = false;

  final List<Map<String, String>> _messages = [];

  String get _systemPrompt {
    String base = '''
You are a highly empathetic, encouraging, and supportive English language teacher.
Your goal is to lower the student's affective filter (reduce their anxiety about making mistakes).
If the user makes a grammar or vocabulary mistake, DO NOT be harsh. Instead, say something like:
"I totally understood what you meant! Just so you know, native speakers usually say it like this: [correction]".
Always be warm, use emojis occasionally, and keep the conversation flowing naturally.
''';
    if (widget.grammarContextPrompt != null) {
      base += '\n\nIMPORTANT CONTEXT FOR THIS SESSION: ${widget.grammarContextPrompt}';
    }
    return base;
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initTts();
    _loadApiKey();

    if (widget.grammarContextPrompt != null) {
       _messages.add({"role": "ai", "text": "Hello! Let's practice what you just learned. Are you ready?"});
    } else {
       _messages.add({"role": "ai", "text": "Hello! I am your AI language partner. Let's practice! Imagine we are at a restaurant and I am the waiter. What would you like to order?"});
    }
  }

  void _initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _loadApiKey() async {
    String? key = await _secureStorage.read(key: 'ai_api_key');
    if (mounted) {
      setState(() {
        _apiKey = key ?? '';
      });
    }
  }

  void _listenVoice() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _controller.text = val.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_controller.text.isNotEmpty) _sendMessage();
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userText = _controller.text;
    setState(() {
      _messages.add({"role": "user", "text": userText});
    });

    _controller.clear();

    if (_apiKey.isEmpty) {
      if (mounted) {
        setState(() {
          _messages.add({"role": "ai", "text": "[API KEY REQUIRED] Please save your Gemini API key securely in Settings to enable real responses!"});
        });
      }
      return;
    }

    try {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey');

      // Build conversation history for Gemini format
      List<Map<String, dynamic>> contents = [];
      // Inject the system prompt hidden inside the first user message context
      contents.add({
        "role": "user",
        "parts": [{"text": "SYSTEM INSTRUCTION (Do not reply to this directly): $_systemPrompt"}]
      });
      contents.add({
        "role": "model",
        "parts": [{"text": "Understood. I will be highly empathetic and supportive."}]
      });

      for (var msg in _messages) {
        contents.add({
          "role": msg["role"] == "ai" ? "model" : "user",
          "parts": [{"text": msg["text"]}]
        });
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
            "contents": contents,
            "generationConfig": {"temperature": 0.7}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final replyText = data['candidates'][0]['content']['parts'][0]['text'].toString();

        if (mounted) {
          setState(() {
            _messages.add({"role": "ai", "text": replyText});
          });
          _tts.speak(replyText);
        }
      } else {
        if (mounted) {
          setState(() {
            _messages.add({"role": "ai", "text": "Error communicating with AI. Please check your API key."});
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({"role": "ai", "text": "Network error. Please check your connection."});
        });
      }
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Conversation Partner')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_apiKey.isEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade100,
              child: const Text('Warning: AI Features require a valid API Key to be set in Settings.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onLongPress: _listenVoice,
                  onLongPressUp: _listenVoice, // stops listening and sends
                  child: CircleAvatar(
                    backgroundColor: _isListening ? Colors.red : Colors.green,
                    child: const Icon(Icons.mic, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
