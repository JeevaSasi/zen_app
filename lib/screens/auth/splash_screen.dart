import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // List of karate quotes
  final List<String> _karateQuotes = [
    "The ultimate aim of karate lies not in victory or defeat, but in the perfection of the character of its participants.",
    "Karate is not just about fighting; it's about building character.",
    "In karate, the journey is more important than the destination.",
    "The more you sweat in training, the less you bleed in battle.",
    "Empty your mind, be formless, shapeless, like water.",
    "The belt around your waist only covers two inches of your center. You must cover the rest.",
    "A black belt is a white belt who never gave up.",
    "Karate begins and ends with respect.",
    "The purpose of karate is not to win, but to improve oneself.",
    "The difference between a successful person and others is not a lack of strength, not a lack of knowledge, but rather a lack of will."
  ];

  // Selected random quote
  late String _selectedQuote;

  @override
  void initState() {
    super.initState();

    // Select a random quote
    final random = Random();
    _selectedQuote = _karateQuotes[random.nextInt(_karateQuotes.length)];

    _checkLoginStatus();
  }
  
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GIF Image
            Image.asset(
              'assets/images/logo.jpeg',
              width: double.infinity,
              height: 500,
              fit: BoxFit.contain,
            ),
            
            const SizedBox(height: 24),
            
            // Karate Quote
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 32),
            //   child: Text(
            //     _selectedQuote,
            //     textAlign: TextAlign.center,
            //     style: const TextStyle(
            //       color: Colors.white,
            //       fontSize: 16,
            //       fontStyle: FontStyle.italic,
            //       shadows: [
            //         Shadow(
            //           offset: Offset(0, 1),
            //           blurRadius: 3,
            //           color: Color.fromRGBO(0, 0, 0, 0.3),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            
            // const SizedBox(height: 40),
            
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
} 