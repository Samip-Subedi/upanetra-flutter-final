import 'package:flutter/material.dart';
import 'package:shopping_app/features/onboarding/view/onboarding_viewpage.dart';

class SplashScreenViewPage extends StatefulWidget {
  @override
  _SplashScreenViewPageState createState() => _SplashScreenViewPageState();
}

class _SplashScreenViewPageState extends State<SplashScreenViewPage> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/images/splash.gif",
          height: 250,
          width: 250,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
        ),
      ),
    );
  }
}
