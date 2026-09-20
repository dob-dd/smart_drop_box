import 'package:flutter/material.dart';

import '../models/drop_box_state.dart';
import '../theme/app_colors.dart';

class LockStatusCard extends StatelessWidget {
  const LockStatusCard({
    super.key,
    required this.lockState,
    required this.isBusy,
    required this.onPrimaryAction,
  });

  final DropBoxLockState lockState;
  final bool isBusy;
  final VoidCallback onPrimaryAction;

  bool get isSecured => lockState == DropBoxLockState.secured;

  @override
  Widget build(BuildContext context) {
    final statusColor = isSecured ? AppColors.lockRed : AppColors.unlockGreen;
    final glowColor = isSecured ? AppColors.lockRedGlow : AppColors.unlockGreenGlow;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glowColor,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.35),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(
              isSecured ? Icons.lock_rounded : Icons.lock_open_rounded,
              size: 52,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isSecured ? 'Container Secured' : 'Container Unlocked',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isSecured
                ? 'Drop box is locked and ready for delivery'
                : 'Please close and lock when complete',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: isBusy ? null : onPrimaryAction,
              style: FilledButton.styleFrom(
                backgroundColor: isSecured ? AppColors.unlockGreen : AppColors.lockRed,
                disabledBackgroundColor: AppColors.textMuted,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: isBusy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(isSecured ? Icons.lock_open_rounded : Icons.lock_rounded),
              label: Text(
                isBusy
                    ? 'CONNECTING…'
                    : isSecured
                        ? 'TAP TO UNLOCK'
                        : 'LOCK CONTAINER',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
