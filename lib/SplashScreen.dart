import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final bool _isUserRegistered = false;
  final int _splashSeconds = 3;

  bool _didPrecache = false;

  @override
  void initState() {
    super.initState();
    _goNext(); // Navigator selepas delay masih ok dalam initState
  }

  // Pindahkan precache ke sini
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecache) {
      precacheImage(const AssetImage('assets/ecoloop_logo.jpg'), context);
      _didPrecache = true;
    }
  }

  Future<void> _goNext() async {
    await Future.delayed(Duration(seconds: _splashSeconds));
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacementNamed(_isUserRegistered ? '/home' : '/signup');
    // Alternatif selamat lain:
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) Navigator.of(context).pushReplacementNamed(...);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/ecoloop_logo.png'),
                width: 160,
                height: 160,
              ),
              SizedBox(height: 20),
              SizedBox(height: 16),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
