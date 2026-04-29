import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/glass_card.dart';
import '../providers/user_provider.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const AuthScreen({super.key, required this.onLoginSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _submit() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isLoading = true);

    // In a real Firebase app, this would be:
    // UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(...)
    // String token = await cred.user!.getIdToken();

    // We execute the real sync logic structure using the Provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Attempt real cloud sync (will fail since URL is dummy, but tests real logic path)
    bool success = await userProvider.syncWithCloud(_emailController.text, 'mock_firebase_token');

    if (mounted) {
      setState(() => _isLoading = false);
      if (!success) {
         // Show error if backend is unreachable, but fallback to success for UX flow demonstration
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error connecting to cloud server, using local offline profile.')));
         widget.onLoginSuccess();
      } else {
         widget.onLoginSuccess();
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: GlassCard(
              color: Colors.white,
              opacity: 0.15,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school, size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text('EFA Pro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin ? 'Welcome back! Sync your progress.' : 'Create an account to save progress in the cloud.',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white54)
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white54)
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 32),

                  if (_isLoading)
                     const CircularProgressIndicator(color: Colors.white)
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6A11CB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _submit,
                        child: Text(_isLogin ? 'Login & Sync' : 'Register', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),

                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(
                      _isLogin ? 'Don\'t have an account? Sign up' : 'Already have an account? Login',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
