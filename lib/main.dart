import 'package:flutter/material.dart';
import 'package:movieapp/app.dart';
import 'package:movieapp/shared/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MyApp());
}
