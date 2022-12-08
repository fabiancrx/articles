import 'package:flutter/foundation.dart';
import 'package:settings_counter/settings/settings_service.dart';

/// Interacts with services and provide observables that read or update settings.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  // Make SettingsService a private variable so it is not used directly. " Law of Demeter "
  final SettingsService _settingsService;

  late int counter;

  SettingsController(this._settingsService);

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    counter = _settingsService.counter();
    //Inform listeners a change has occurred.
    notifyListeners();
  }


  /// Update and persist the counter to [newCount]
  Future<void> updateCounter(int newCount) async {
    //Increment the  internal state of the counter
    counter = newCount;
    //Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes
    await _settingsService.updateCounter(newCount);
  }
}