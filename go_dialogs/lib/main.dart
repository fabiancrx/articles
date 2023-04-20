import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'license',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return DialogPage(builder: (_) => const AboutDialog());
          },
        ),
        GoRoute(
          path: 'sheet',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CupertinoModalPopupPage(
                builder: (_) => const CupertinoActionSheet(
                      title: Text("Dummy Title"),
                      message: FlutterLogo(),
                    ));
          },
        ),
      ],
    ),
  ],
);

// pageBuilder: (BuildContext context, GoRouterState state) {
//   return DialogPage(builder: (context) => const AboutDialog());
// },
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Navigator playground',
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super important  screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => context.go('/license'),
              child: const Text("See licenses"),
            ),
            OutlinedButton(
              onPressed: () => context.go('/sheet'),
              child: const Text("See sheet"),
            ),
          ],
        ),
      ),
    );
  }
}

/// A dialog page with Material entrance and exit animations, modal barrier color,
/// and modal barrier behavior (dialog is dismissible with a tap on the barrier).
class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes);
}

class CupertinoModalPopupPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String barrierLabel;
  final bool semanticsDismissible;
  final WidgetBuilder builder;
  final ImageFilter? filter;

  const CupertinoModalPopupPage(
      {required this.builder,
      this.anchorPoint,
      this.barrierColor = kCupertinoModalBarrierColor,
      this.barrierDismissible = true,
      this.barrierLabel = "Dismiss",
      this.semanticsDismissible = true,
      this.filter,
      super.key});

  @override
  Route<T> createRoute(BuildContext context) => CupertinoModalPopupRoute<T>(
      builder: builder,
      barrierDismissible: barrierDismissible,
      anchorPoint: anchorPoint,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      filter: filter,
      semanticsDismissible: semanticsDismissible,
      settings: this);
}
