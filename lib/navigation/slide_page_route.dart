import 'package:flutter/material.dart';

/// Horizontal slide route: forward pushes from the right; pop reverses direction.
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  SlidePageRoute({
    required WidgetBuilder builder,
    super.settings,
    super.transitionDuration = const Duration(milliseconds: 300),
    super.reverseTransitionDuration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
              reverseCurve: Curves.easeInOut,
            );
            final secondaryCurve = CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeInOut,
              reverseCurve: Curves.easeInOut,
            );

            final incoming = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(curve);

            final outgoingUnderneath = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-1, 0),
            ).animate(secondaryCurve);

            return SlideTransition(
              position: outgoingUnderneath,
              child: SlideTransition(
                position: incoming,
                child: child,
              ),
            );
          },
        );
}
