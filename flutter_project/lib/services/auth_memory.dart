import 'dart:html' as html;

class AuthMemory {
  static Future<void> saveToken(String token, String userId, String userType) async {
    html.window.localStorage['jwtToken'] = token;
    html.window.localStorage['userId'] = userId;
    html.window.localStorage['userType'] = userType;
  }

  static Future<String?> getToken() async {
    return html.window.localStorage['jwtToken'];
  }

  static Future<String?> getUserId() async {
    return html.window.localStorage['userId'];
  }

  static Future<String?> getUserType() async {
    return html.window.localStorage['userType'];
  }

  static Future<void> clear() async {
    html.window.localStorage.remove('jwtToken');
    html.window.localStorage.remove('userId');
    html.window.localStorage.remove('userType');
  }

  static Future<bool> isLoggedIn() async {
    return html.window.localStorage['jwtToken'] != null;
  }
}
