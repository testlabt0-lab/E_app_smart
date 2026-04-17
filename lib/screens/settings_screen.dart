import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isBiometricEnabled = false;
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    String? isBiometric = await _secureStorage.read(key: 'biometric_enabled');
    String? apiKey = await _secureStorage.read(key: 'ai_api_key');

    if (mounted) {
      setState(() {
        _isBiometricEnabled = isBiometric == 'true';
        _apiKeyController.text = apiKey ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      bool canAuthenticate = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      if (!canAuthenticate) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometrics not supported on this device')));
        return;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to enable App Lock',
        options: const AuthenticationOptions(stickyAuth: true),
      );

      if (!authenticated) return;
    }

    await _secureStorage.write(key: 'biometric_enabled', value: value.toString());
    setState(() {
      _isBiometricEnabled = value;
    });
  }

  Future<void> _saveApiKey() async {
    await _secureStorage.write(key: 'ai_api_key', value: _apiKeyController.text);
    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API Key securely saved!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Security & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Security', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text('App Lock (Biometrics)'),
            subtitle: const Text('Require fingerprint/face ID to open the app'),
            secondary: const Icon(Icons.fingerprint),
            value: _isBiometricEnabled,
            onChanged: _toggleBiometric,
          ),
          const Divider(height: 40),

          const Text('AI Integrations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 10),
          const Text(
            'Your API key is encrypted and stored locally in the secure enclave of your device. It will never be shared.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _apiKeyController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'OpenAI / Gemini API Key',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.vpn_key),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveApiKey,
            child: const Text('Save API Key Securely'),
          ),
        ],
      ),
    );
  }
}
