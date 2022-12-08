import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// This class persists its data via SharedPreferences plugin
class SettingsService {
  final SharedPreferences _sharedPreferences;

  SettingsService(this._sharedPreferences);

  /// Retrieves the last saved counter value
  int counter() => int.parse(_sharedPreferences.getString('counter')??'0');

  /// Updates the counter value
  Future<bool> updateCounter(int newValue) => _sharedPreferences.setString('counter', '$newValue');
}