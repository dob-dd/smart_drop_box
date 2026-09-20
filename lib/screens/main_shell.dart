import 'package:flutter/material.dart';

import '../services/drop_box_service.dart';
import 'home_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.service});

  final DropBoxService service;

  @override
  Widget build(BuildContext context) {
    return HomeScreen(service: service);
  }
}
