import 'package:flutter/material.dart';
import 'package:settings_counter/settings/settings_controller.dart';
import 'package:settings_counter/settings/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensures plugins can be accessed.
  WidgetsFlutterBinding.ensureInitialized();

  final sp = await SharedPreferences.getInstance();

  final settingsController = SettingsController(SettingsService(sp))
    ..loadSettings();

  runApp(MaterialApp(
    title: 'Settings Demo',
    theme: ThemeData(primarySwatch: Colors.indigo),
    home: MyHomePage(controller: settingsController, title: 'Settings Demo'),
  ));
}

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
