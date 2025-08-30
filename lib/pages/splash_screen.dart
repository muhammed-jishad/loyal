import 'dart:async';

import 'package:flutter/material.dart';

import '../common/shared_class.dart';
import 'login_page.dart';
import 'main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    // Fade effect
    Timer(const Duration(milliseconds: 10), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });

    // Delay to show splash screen
    await Future.delayed(const Duration(milliseconds: 2000));

    // Use the prefs passed from main.dart
    String? loyaltyNo = AppPreferences.prefs.getString('LoyaltyNo');

    if (!mounted) return;

    if (loyaltyNo != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(selectedIndex: 0)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).hintColor, Theme.of(context).primaryColor],
          begin: FractionalOffset(0, 0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: const Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 140.0,
            width: 140.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 2.0,
                  offset: const Offset(5.0, 3.0),
                  spreadRadius: 2.0,
                )
              ],
            ),
            child: Center(
              child: ClipOval(
                child: Image.asset("assets/images.jpg"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
