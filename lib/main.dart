import 'package:flutter/material.dart';

import 'screens/main_shell.dart';
import 'services/drop_box_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SmartDropBoxApp(service: MockDropBoxService()));
}

class SmartDropBoxApp extends StatefulWidget {
  const SmartDropBoxApp({super.key, required this.service});

  final DropBoxService service;

  @override
  State<SmartDropBoxApp> createState() => _SmartDropBoxAppState();
}

class _SmartDropBoxAppState extends State<SmartDropBoxApp> {
  @override
  void dispose() {
    widget.service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Drop Box',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: MainShell(service: widget.service),
    );
  }
}
