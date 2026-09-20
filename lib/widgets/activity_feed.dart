import 'package:flutter/material.dart';

import '../models/activity_log_entry.dart';
import '../theme/app_colors.dart';
import '../utils/time_format.dart';

class ActivityFeed extends StatelessWidget {
  const ActivityFeed({
    super.key,
    required this.entries,
    this.maxItems,
    this.shrinkWrap = true,
  });

  final List<ActivityLogEntry> entries;
  final int? maxItems;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final visible = maxItems == null ? entries : entries.take(maxItems!).toList();

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
      itemCount: visible.length,
      separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.border),
      itemBuilder: (context, index) => _ActivityRow(entry: visible[index]),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.entry});

  final ActivityLogEntry entry;

  Color get _iconColor {
    return switch (entry.kind) {
      ActivityLogKind.entry => AppColors.logGreen,
      ActivityLogKind.alert => AppColors.logRed,
      ActivityLogKind.unlock || ActivityLogKind.lock => AppColors.accentBlue,
    };
  }

  IconData get _icon {
    return switch (entry.kind) {
      ActivityLogKind.entry => Icons.move_to_inbox_rounded,
      ActivityLogKind.alert => Icons.warning_amber_rounded,
      ActivityLogKind.unlock => Icons.lock_open_rounded,
      ActivityLogKind.lock => Icons.lock_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, size: 20, color: _iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatLogTime(entry.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SourceTag(label: entry.sourceLabel, isAlert: entry.isAlert),
        ],
      ),
    );
  }
}

class _SourceTag extends StatelessWidget {
  const _SourceTag({required this.label, required this.isAlert});

  final String label;
  final bool isAlert;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAlert ? AppColors.alertTagBackground : AppColors.tagBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: isAlert ? AppColors.logRed : AppColors.textSecondary,
        ),
      ),
    );
  }
}
