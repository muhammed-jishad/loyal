import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs => _prefs;

  // Convenience setters
  static Future<void> setLoyalty(String loyaltyNo) async {
    await _prefs.setString('LoyaltyNo', loyaltyNo);
  }

  static Future<void> setName(String name) async {
    await _prefs.setString('name', name);
  }

  static Future<void> setCustomerCode(int code) async {
    await _prefs.setInt('cucode', code);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }
}
