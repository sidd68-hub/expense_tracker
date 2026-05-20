import 'package:flutter/material.dart';
import 'package:expense_tracker/app.dart';
import 'package:expense_tracker/core/di/injector.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // Initialize DI
  runApp(const AppView());
}