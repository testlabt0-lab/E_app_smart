import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/practice_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'screens/games_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/ai_pro_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const EfaProApp(),
    ),
  );
}

class EfaProApp extends StatefulWidget {
  const EfaProApp({super.key});

  @override
  State<EfaProApp> createState() => _EfaProAppState();
}

class _EfaProAppState extends State<EfaProApp> {
  bool _isAuthenticated = false;
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkBiometricAuth();
  }

  Future<void> _checkBiometricAuth() async {
    final storage = const FlutterSecureStorage();
    final auth = LocalAuthentication();

    String? isBiometric = await storage.read(key: 'biometric_enabled');
    if (isBiometric == 'true') {
      bool canAuthenticate = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (canAuthenticate) {
        bool authenticated = false;
        while (!authenticated) {
          try {
            authenticated = await auth.authenticate(
              localizedReason: 'Please authenticate to open EFA Pro',
              options: const AuthenticationOptions(stickyAuth: true, biometricOnly: false),
            );
          } catch (e) {
            // Handle platform exception (e.g. app in background)
            await Future.delayed(const Duration(seconds: 1));
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _isAuthenticated = true;
        _isCheckingAuth = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAuth) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return MaterialApp(
          title: 'EFA Pro',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF3F8FF),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6A11CB),
              primary: const Color(0xFF6A11CB),
              secondary: const Color(0xFF2575FC),
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Color(0xFF2B2D42)),
              titleTextStyle: TextStyle(color: Color(0xFF2B2D42), fontSize: 22, fontWeight: FontWeight.w800),
            ),
            textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF818CF8),
              primary: const Color(0xFF818CF8),
              secondary: const Color(0xFF38BDF8),
              brightness: Brightness.dark,
              surface: const Color(0xFF1E293B),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
            ),
            textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
          ),
          themeMode: userProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainNavigation(),
        );
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PracticeScreen(),
    const GamesScreen(),
    const AiProScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI Pro',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
