import 'package:flutter/material.dart';

import '../models/add_parcel_callback.dart';
import '../models/parcel.dart';
import '../theme/app_colors.dart';
import '../utils/date_format.dart';

class AddParcelForm extends StatefulWidget {
  const AddParcelForm({
    super.key,
    required this.onSubmit,
    this.onSaved,
    this.showHeader = true,
  });

  final AddParcelOnSubmit onSubmit;
  final VoidCallback? onSaved;
  final bool showHeader;

  @override
  State<AddParcelForm> createState() => _AddParcelFormState();
}

class _AddParcelFormState extends State<AddParcelForm> {
  ParcelPlatform? _platform;
  final _shipmentController = TextEditingController();
  DateTime? _expectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _shipmentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accentBlue,
              surface: AppColors.surfaceElevated,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _expectedDate = picked);
    }
  }

  void _submit() {
    if (_platform == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a platform')),
      );
      return;
    }
    if (!_formKey.currentState!.validate() || _expectedDate == null) {
      if (_expectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select expected delivery date')),
        );
      }
      return;
    }
    widget.onSubmit(
      platform: _platform!,
      shipmentNumber: _shipmentController.text,
      expectedDeliveryDate: _expectedDate!,
    );
    widget.onSaved?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.showHeader) ...[
                const Text(
                  'Add Parcel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              const Text(
                'PLATFORM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _PlatformLogo(
                      assetPath: 'assets/platforms/lazada.png',
                      semanticLabel: 'Lazada',
                      selected: _platform == ParcelPlatform.lazada,
                      onTap: () => setState(() => _platform = ParcelPlatform.lazada),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PlatformLogo(
                      assetPath: 'assets/platforms/tiktok_shop.png',
                      semanticLabel: 'TikTok Shop',
                      selected: _platform == ParcelPlatform.tiktokShop,
                      onTap: () => setState(() => _platform = ParcelPlatform.tiktokShop),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PlatformLogo(
                      assetPath: 'assets/platforms/shopee.png',
                      semanticLabel: 'Shopee',
                      selected: _platform == ParcelPlatform.shopee,
                      onTap: () => setState(() => _platform = ParcelPlatform.shopee),
                    ),
                  ),
                ],
              ),
              if (_platform != null) ...[
                const SizedBox(height: 28),
                TextFormField(
                  controller: _shipmentController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: _inputDecoration('Shipment Number'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter shipment number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: _inputDecoration('Expected Delivery Date'),
                    child: Text(
                      _expectedDate == null
                          ? 'Select date'
                          : formatDisplayDate(_expectedDate!),
                      style: TextStyle(
                        color: _expectedDate == null
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Parcel',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accentBlue),
      ),
    );
  }
}

class _PlatformLogo extends StatelessWidget {
  const _PlatformLogo({
    required this.assetPath,
    required this.semanticLabel,
    required this.selected,
    required this.onTap,
  });

  final String assetPath;
  final String semanticLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 88,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.accentBlue : AppColors.border,
                width: selected ? 2.5 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.accentBlue.withValues(alpha: 0.25),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
