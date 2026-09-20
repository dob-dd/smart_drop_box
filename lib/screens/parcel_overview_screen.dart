import 'package:flutter/material.dart';

import '../models/parcel.dart';
import '../services/parcel_store.dart';
import '../theme/app_colors.dart';
import '../utils/date_format.dart';
import '../navigation/app_navigator.dart';
import '../navigation/app_screens.dart';

enum _ParcelFilter { all, completed, inDelivery, pending }

class ParcelOverviewScreen extends StatefulWidget {
  const ParcelOverviewScreen({super.key, required this.parcelStore});

  final ParcelStore parcelStore;

  @override
  State<ParcelOverviewScreen> createState() => _ParcelOverviewScreenState();
}

class _ParcelOverviewScreenState extends State<ParcelOverviewScreen> {
  _ParcelFilter _filter = _ParcelFilter.all;

  @override
  void initState() {
    super.initState();
    widget.parcelStore.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    widget.parcelStore.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  List<Parcel> get _filtered {
    final all = widget.parcelStore.parcels;
    return switch (_filter) {
      _ParcelFilter.all => all,
      _ParcelFilter.completed =>
        all.where((p) => p.status == ParcelStatus.completed).toList(),
      _ParcelFilter.inDelivery =>
        all.where((p) => p.status == ParcelStatus.inDelivery).toList(),
      _ParcelFilter.pending =>
        all.where((p) => p.status == ParcelStatus.pending).toList(),
    };
  }

  void _openAddParcel() {
    AppNavigator.pushScreen(
      context,
      screenName: AppScreens.addParcel,
      arguments: ({
        required platform,
        required shipmentNumber,
        required expectedDeliveryDate,
      }) {
        widget.parcelStore.addParcel(
          platform: platform,
          shipmentNumber: shipmentNumber,
          expectedDeliveryDate: expectedDeliveryDate,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final parcels = _filtered;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_rounded),
              tooltip: 'Add parcel',
              onPressed: _openAddParcel,
            ),
            const Spacer(),
            const Text('PARCEL OVERVIEW'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _filter == _ParcelFilter.all,
                  onTap: () => setState(() => _filter = _ParcelFilter.all),
                ),
                _FilterChip(
                  label: 'Completed',
                  selected: _filter == _ParcelFilter.completed,
                  onTap: () => setState(() => _filter = _ParcelFilter.completed),
                ),
                _FilterChip(
                  label: 'In Delivery',
                  selected: _filter == _ParcelFilter.inDelivery,
                  onTap: () => setState(() => _filter = _ParcelFilter.inDelivery),
                ),
                _FilterChip(
                  label: 'Pending',
                  selected: _filter == _ParcelFilter.pending,
                  onTap: () => setState(() => _filter = _ParcelFilter.pending),
                ),
              ],
            ),
          ),
          Expanded(
            child: parcels.isEmpty
                ? const Center(
                    child: Text(
                      'No parcels in this filter',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: parcels.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _ParcelTile(parcel: parcels[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? AppColors.textPrimary : AppColors.textSecondary,
        ),
        backgroundColor: AppColors.surfaceElevated,
        selectedColor: AppColors.accentBlue.withValues(alpha: 0.25),
        side: BorderSide(
          color: selected ? AppColors.accentBlue : AppColors.border,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class _ParcelTile extends StatelessWidget {
  const _ParcelTile({required this.parcel});

  final Parcel parcel;

  Color get _statusColor => switch (parcel.status) {
        ParcelStatus.completed => AppColors.unlockGreen,
        ParcelStatus.inDelivery => AppColors.accentBlue,
        ParcelStatus.pending => AppColors.textMuted,
      };

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
                parcel.platformLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  parcel.statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Shipment Number',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 4),
          Text(
            parcel.shipmentNumber,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.accentBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Expected: ${formatDisplayDate(parcel.expectedDeliveryDate)}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
