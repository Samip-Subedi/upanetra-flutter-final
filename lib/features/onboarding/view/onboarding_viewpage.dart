import 'package:flutter/material.dart';
import 'package:shopping_app/features/auth/presentation/view/login_view.dart';

import '../../auth/presentation/view/login_view.dart'; // Adjust path as needed

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> images = [
    "assets/images/boardi.jpg",
    "assets/images/boardd.jpg",
    "assets/images/boardd3.jpg",
  ];

  void _goToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Ensure LoginPage exists
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: _currentPage < images.length - 1
                ? TextButton(
              onPressed: _goToLoginPage, // Skip to Login
              child: const Text(
                "Skip",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )
                : const SizedBox(),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    if (_currentPage < images.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _goToLoginPage(); // Navigate after last page
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
