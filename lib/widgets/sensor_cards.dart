import 'package:flutter/material.dart';

import '../models/drop_box_state.dart';
import '../theme/app_colors.dart';

class SensorCardsRow extends StatelessWidget {
  const SensorCardsRow({super.key, required this.sensors});

  final SensorSnapshot sensors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SensorCard(
            title: 'PAYLOAD',
            icon: Icons.inventory_2_outlined,
            value: sensors.payloadLabel,
            detail: sensors.isEmpty ? 'Empty Chamber' : 'Live weight reading',
            detailColor: AppColors.textSecondary,
            showNeutralDot: sensors.isEmpty,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SensorCard(
            title: 'CLEARANCE',
            icon: Icons.straighten_rounded,
            value: sensors.clearanceLabel,
            detail: '${sensors.spacePercent.toStringAsFixed(0)}% Space Left',
            detailColor: AppColors.unlockGreen,
            showNeutralDot: false,
            showGreenDot: true,
          ),
        ),
      ],
    );
  }
}

class _SensorCard extends StatelessWidget {
  const _SensorCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.detail,
    required this.detailColor,
    required this.showNeutralDot,
    this.showGreenDot = false,
  });

  final String title;
  final IconData icon;
  final String value;
  final String detail;
  final Color detailColor;
  final bool showNeutralDot;
  final bool showGreenDot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const Spacer(),
              Icon(icon, size: 18, color: AppColors.accentBlue),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: showGreenDot
                      ? AppColors.unlockGreen
                      : showNeutralDot
                          ? AppColors.textMuted
                          : AppColors.accentBlue,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  detail,
                  style: TextStyle(fontSize: 12, color: detailColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
