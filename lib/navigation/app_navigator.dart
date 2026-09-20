import 'package:flutter/material.dart';

import 'app_screen_registry.dart';
import 'slide_page_route.dart';

/// Push/pop helper that resolves screens from [lib/screens/] via [AppScreenRegistry].
abstract final class AppNavigator {
  static const Duration transitionDuration = Duration(milliseconds: 300);

  /// Navigate forward to a registered screen (slides in from the right).
  static Future<T?> pushScreen<T extends Object?>(
    BuildContext context, {
    required String screenName,
    Object? arguments,
  }) {
    final builder = AppScreenRegistry.builderFor(screenName);
    if (builder == null) {
      throw ArgumentError.value(
        screenName,
        'screenName',
        'No screen registered. Add it to AppScreenRegistry.',
      );
    }

    return Navigator.of(context).push<T>(
      SlidePageRoute<T>(
        settings: RouteSettings(name: screenName, arguments: arguments),
        builder: (context) => builder(context, arguments),
        transitionDuration: transitionDuration,
        reverseTransitionDuration: transitionDuration,
      ),
    );
  }

  /// Navigate backward (slides out to the right, previous screen from the left).
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  static bool canPop(BuildContext context) => Navigator.of(context).canPop();
}
