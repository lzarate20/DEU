import 'package:shared_preferences/shared_preferences.dart';

class AuthMemory {
  static String? _jwtToken;
  static String? _userId;
  static String? _userType;

  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _jwtToken = prefs.getString('jwtToken');
    _userId = prefs.getString('userId');
    _userType = prefs.getString('userType');
  }

  static Future<void> saveToken(String token, String userId, String userType) async {
    _jwtToken = token;
    _userId = userId;
    _userType = userType;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);
    await prefs.setString('userId', userId);
    await prefs.setString('userType', userType);
  }

  static String? get token => _jwtToken;
  static String? get userId => _userId;
  static String? get userType => _userType;

  static Future<void> clear() async {
    _jwtToken = null;
    _userId = null;
    _userType = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    await prefs.remove('userId');
    await prefs.remove('userType');
  }

  static Future<bool> isLoggedIn() async {
    await loadFromPrefs();
    return _jwtToken != null;
  }
}

