import 'package:flutter/material.dart';

import '../models/activity_log_entry.dart';
import '../models/add_parcel_callback.dart';
import '../screens/activity_log_screen.dart';
import '../screens/add_parcel_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_shell.dart';
import '../screens/parcel_overview_screen.dart';
import '../services/drop_box_service.dart';
import '../services/parcel_store.dart';
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
    AppScreens.addParcel: (context, arguments) {
      final onSubmit = arguments as AddParcelOnSubmit?;
      assert(onSubmit != null, 'Add parcel requires AddParcelOnSubmit callback');
      return AddParcelScreen(onSubmit: onSubmit!);
    },
    AppScreens.home: (context, arguments) {
      final service = arguments as DropBoxService?;
      assert(service != null, 'Home requires DropBoxService');
      return HomeScreen(service: service!);
    },
    AppScreens.mainShell: (context, arguments) {
      final args = arguments as MainShellRouteArgs?;
      assert(args != null, 'Main shell requires MainShellRouteArgs');
      return MainShell(
        service: args!.service,
        parcelStore: args.parcelStore,
      );
    },
    AppScreens.parcelOverview: (context, arguments) {
      final store = arguments as ParcelStore?;
      assert(store != null, 'Parcel overview requires ParcelStore');
      return ParcelOverviewScreen(parcelStore: store!);
    },
  };
}

class MainShellRouteArgs {
  const MainShellRouteArgs({
    required this.service,
    required this.parcelStore,
  });

  final DropBoxService service;
  final ParcelStore parcelStore;
}
