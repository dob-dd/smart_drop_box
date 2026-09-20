import 'package:flutter/material.dart';

import '../models/activity_log_entry.dart';
import '../screens/activity_log_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_shell.dart';
import '../services/drop_box_service.dart';
import 'app_screens.dart';

typedef ScreenBuilder = Widget Function(BuildContext context, Object? arguments);

/// Maps [AppScreens] names to widgets in [lib/screens/].
///
/// Register a new file here when you add a screen under `lib/screens/`.
abstract final class AppScreenRegistry {
  static ScreenBuilder? builderFor(String screenName) => _builders[screenName];

  static bool contains(String screenName) => _builders.containsKey(screenName);

  static final Map<String, ScreenBuilder> _builders = {
    AppScreens.activityLog: (context, arguments) {
      final entries = arguments as List<ActivityLogEntry>? ?? const [];
      return ActivityLogScreen(entries: entries);
    },
    AppScreens.home: (context, arguments) {
      final service = arguments as DropBoxService?;
      assert(service != null, 'Home requires DropBoxService');
      return HomeScreen(service: service!);
    },
    AppScreens.mainShell: (context, arguments) {
      final service = arguments as DropBoxService?;
      assert(service != null, 'Main shell requires DropBoxService');
      return MainShell(service: service!);
    },
  };
}
