import 'package:flutter/material.dart';
import 'package:expense_tracker/app.dart';
import 'package:expense_tracker/core/di/injector.dart';
import 'package:expense_tracker/flavour/environment.dart';

import 'core/utils/app_enum.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  Environment.flavor = Flavor.prod;
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // Initialize DI
  runApp(const AppView());
}