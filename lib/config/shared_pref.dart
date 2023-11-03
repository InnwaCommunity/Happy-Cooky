import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences _preferences;

  static const String totalBalanceKey = "totalBalanceKey";

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static void _setValue<T>(String key, T value) {
    if (value is String) {
      _preferences.setString(key, value);
    } else if (value is double) {
      _preferences.setDouble(key, value);
    } else if (value is bool) {
      _preferences.setBool(key, value);
    } else if (value is int) {
      _preferences.setInt(key, value);
    }
  }

  static T? _getValue<T>(String key) {
    return _preferences.containsKey(key) ? _preferences.get(key) as T? : null;
  }

  static void setTotalBalance({required double totalBalance}) {
    _setValue<double>(totalBalanceKey, totalBalance);
  }

  static double getTotalBalance() {
    return _getValue<double>(totalBalanceKey) ?? 0;
  }
}
