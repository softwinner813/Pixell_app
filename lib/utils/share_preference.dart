import 'package:shared_preferences/shared_preferences.dart';

import 'my_constants.dart';

class MySharePreference {
  ///
  /// Instantiation of the SharedPreferences library
  ///

  Future saveStringInPref(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future saveBoolInPref(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future saveIntegerInPref(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<String> getStringInPref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? "";
  }

  Future<bool> getBoolInPref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key) ?? false;
  }

  Future<int> getIntegerInPref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key) ?? 0;
  }

  /// ------------------------------------------------------------
  /// Method that returns the user decision to allow notifications
  /// ------------------------------------------------------------
  clearAllPref() async {
    saveBoolInPref(MyConstants.PREF_KEY_ISLOGIN, false);
    saveIntegerInPref(MyConstants.PREF_KEY_USERID, -1);
    saveStringInPref(MyConstants.PREF_KEY_LOGIN_TOKEN, "");
    saveBoolInPref(MyConstants.PREF_AS_GUEST, true);
    saveStringInPref(MyConstants.PREF_KEY_CURRENCY_NAME, "");
    saveStringInPref(MyConstants.PREF_IS_SELLER, "");
    /*final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();*/
  }
}
