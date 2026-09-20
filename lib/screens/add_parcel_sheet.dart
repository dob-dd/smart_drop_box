import 'package:flutter/material.dart';

import '../models/add_parcel_callback.dart';
import '../theme/app_colors.dart';
import '../widgets/add_parcel_form.dart';

class AddParcelSheet extends StatelessWidget {
  const AddParcelSheet({super.key, required this.onSubmit});

  final AddParcelOnSubmit onSubmit;

  static Future<void> show(
    BuildContext context, {
    required AddParcelOnSubmit onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddParcelSheet(onSubmit: onSubmit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AddParcelForm(
      onSubmit: onSubmit,
      onSaved: () => Navigator.of(context).pop(),
      showHeader: true,
    );
  }
}
