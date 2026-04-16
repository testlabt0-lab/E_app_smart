import 'package:flutter/material.dart';

// IMPORTANT: The user must replace this with their actual Gemini or OpenAI API Key
const String API_KEY = "YOUR_API_KEY_HERE";

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
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"role": "ai", "text": "Hello! I am your AI language partner. Let's practice! Imagine we are at a restaurant and I am the waiter. What would you like to order?"}
  ];

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": _controller.text});
    });

    final userText = _controller.text;
    _controller.clear();

    // Mocking an AI Response because real API requires a valid key
    Future.delayed(const Duration(seconds: 1), () {
      if(mounted) {
        setState(() {
          if (API_KEY == "YOUR_API_KEY_HERE") {
             _messages.add({"role": "ai", "text": "[API KEY REQUIRED] I received: '$userText'. Please add your Gemini/OpenAI API key in the source code to enable real responses!"});
          } else {
             _messages.add({"role": "ai", "text": "That sounds delicious! Would you like anything to drink with that?"});
          }
        });
      }
    });
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
          if (API_KEY == "YOUR_API_KEY_HERE")
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade100,
              child: const Text('Warning: AI Features require a valid API Key to be set in ai_pro_screen.dart', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
