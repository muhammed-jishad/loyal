import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'common/shared_class.dart';
import 'pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppPreferences.init();

  runApp(LoginUiApp());
}

class LoginUiApp extends StatelessWidget {
  LoginUiApp();

  final Color _primaryColor = HexColor('#009243');
  final Color _accentColor = HexColor('#063d1f');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: _primaryColor,
        hintColor: _accentColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(), // pass prefs down
    );
  }
}
