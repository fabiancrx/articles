---
title: "Accessing iOS settings bundle from Flutter"
datePublished: Fri Dec 09 2022 00:34:16 GMT+0000 (Coordinated Universal Time)
cuid: clbfrzmy9000808l442zb5ykd
slug: accessing-ios-settings-bundle-from-flutter
tags: dart, ios, flutter, android, mobile-development

---

## Overview

Sometimes we need to create a settings page to show some information, like app version, environment or just to tweak some knobs inside our apps. We will explore how to create a [SettingsBundle](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UserDefaults/Preferences/Preferences.html) (iOS only) and how to access those settings from Flutter.

You might be thinking why would want to use that when we could just create a dedicated page inside our apps, which would work for all platforms, the response is discoverability and habits. iOS users are accustomed to modifying certain settings of an app inside the Settings app, and when developing an app for iOS is not that strange to get that as a requirement.

We will be building a simple counter app, where the value of the counter will be persisted and can be edited from within the iOS app settings, really creative huh?

## TLDR

If you want to have a better idea of what to expect at the end of this article you can check out these quick videos of the finished app:

%[https://www.youtube.com/shorts/06FGbEUliG0] 

%[https://www.youtube.com/shorts/NjotYp6No6g] 

## Getting Started

There are several options available to display and persist configurations in a Flutter application, we could do it remotely on a server or locally using a plethora of packages. Most commonly an app will have a :

**Dedicated settings page**

![Google Play in app settings](https://cdn.hashnode.com/res/hashnode/image/upload/v1670352436023/ch6wgx8Aq.jpg?width=400 align="left")

This is what I would prefer most of the time because it's more flexible in terms of UI and it works on all platforms Flutter supports. But it might be the case that you need to display all or some of your app settings on the iOS settings page so we will explore how to store preferences locally, modify them in the iOS settings and access them inside a flutter app.

**iOS settings page:**

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1670352537547/Fdgeusezc.png?width=400 align="left")

## Starter Project

To keep the project simple let's create the default counter app by executing in a terminal `flutter create settings_counter`. We want to store the counter value in the settings so the app always restores from the last counter value and, also be able to edit that value from the Settings.

### Creating a Settings Bundle

> In iOS, the Foundation framework provides a low-level mechanism for storing preferences data. To add a settings bundle to our app we will need to open our project in Xcode, just open the `ios` folder inside `settings_counter`.

1.  Choose "File &gt; New &gt; New File".
    

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1670270539967/S5EUJGPRO.png align="left")

2.  Under iOS, choose "Resource", and then select the Settings Bundle template.
    

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1670270616833/38gNQD7CD.png align="left")

2.  Name the file "Settings.bundle".
    

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1670254301953/P-3dvswwg.png align="left")

The default Settings bundle created will look like this:

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1670254324135/DKvJ6jm5x.png align="left")

We will need to trim it down and remove all the items we don't use to only include the counter setting that we are interested in. So well delete items 1 trough 3.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1670254459181/bHOfjo5HG.png align="left")

Note that the identifier of any setting MUST be prefixed by "flutter." eg: "flutter.counter", this is because the [shared\_preferences](https://pub.dev/packages/shared_preferences) package prefixes all keys by default with "flutter.". So if an identifier is not prefixed it won't be accessible in flutter using this plugin.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1670255106299/Jfl5MEg2D.png?width=400 align="left")

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1670255123297/CmPk8NpDn.png?width=400 align="left")

### Accessing settings from Flutter

Now we have added the Settings bundle, but we have to read it from the app, firstly we will need to add the shared preferences plugin by running on the terminal `flutter pub add shared_preferences`. This should add a line like the following to your `pubspec.yaml`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.0.15
```

Now with our dependencies sorted out, we can continue to create a class that uses the `shared_preferences` plugin to access the user settings. The following code defines a `SettingsService` that stores and retrieves user settings.

%[https://gist.github.com/fabiancrx/dfc3dd6d4dd939e8559f15647e2b5253] 

Then we will create a `SettingsController` class that uses the SettingsService to store and retrieve user settings. The SettingsController extends `ChangeNotifier` (aka: Observable), allowing it to notify listeners(generally widgets) when a change to the settings occurs.

%[https://gist.github.com/fabiancrx/5ddf1f095157335ac14661937e29a385] 

### Gluing it all together

We already have all the pieces to access, persist and update the counter, now we need to integrate it to our widgets. We initialize a `SettingsController` and use it to load the settings. The `runApp()` method is then called to launch the app with the `settingsController` injected via the constructor.

```dart
void main() async {
  // Ensures plugins can be accessed.
  WidgetsFlutterBinding.ensureInitialized();
// Initialize the SharedPreferences
  final sp = await SharedPreferences.getInstance();
// Create the settingsController that will in the end glue the settings with the UI.
  final settingsController = SettingsController(SettingsService(sp))
    ..loadSettings();

  runApp(MaterialApp(
    title: 'Settings Demo',
    theme: ThemeData(primarySwatch: Colors.indigo),
    home: MyHomePage(controller: settingsController, title: 'Settings Demo'),
  ));
}
```

We slightly modify the default home page to use the methods from the `SettingsController` instead of the local state and the job is done! Note that `_incrementCounter` now calls the controller instead of managing the state internally.

```dart
class MyHomePage extends StatelessWidget {
  final SettingsController controller;

  const MyHomePage({super.key, required this.title, required this.controller});

  final String title;

  int get counter => controller.counter;

  void _incrementCounter() {
    controller.updateCounter(counter + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Text('$counter',
                      style: Theme.of(context).textTheme.headline4);
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

And we're done, you can access the code shown here at my [Gihtub](https://github.com/fabiancrx/articles/tree/master/settings_counter) and you can have a look again at the [videos](https://croxx5f.hashnode.dev/accessing-ios-settings-bundle-from-flutter#TLDR).

## Conclusion

Settings Bundles can be useful for displaying settings to end users in a familiar manner, as well as for helping developers and QA teams reduce confusion around different environments and builds. The goal of this article is to provide readers with the necessary information to start using Settings Bundles for their development needs and take advantage of them in Flutter.

Thank you for reading 🌟 and feel free to comment with any doubts or errata.