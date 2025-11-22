import 'package:flutter/material.dart';
import 'core/app/app_initializer.dart';
import 'core/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app
  await AppInitializer.initialize();

  runApp(const MyApp());
}
