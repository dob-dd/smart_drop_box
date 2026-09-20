import 'package:flutter/material.dart';

import '../models/activity_log_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/activity_feed.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key, required this.entries});

  final List<ActivityLogEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DELIVERY LOG'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: ActivityFeed(
          entries: entries,
          shrinkWrap: false,
        ),
      ),
    );
  }
}
