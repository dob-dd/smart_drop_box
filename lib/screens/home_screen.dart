import 'package:flutter/material.dart';

import '../models/drop_box_state.dart';
import '../services/drop_box_service.dart';
import '../theme/app_colors.dart';
import '../widgets/activity_feed.dart';
import '../widgets/lock_status_card.dart';
import '../widgets/section_header.dart';
import '../widgets/sensor_cards.dart';
import 'activity_log_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.service});

  final DropBoxService service;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DropBoxLockState _lockState;
  late SensorSnapshot _sensors;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _lockState = widget.service.lockState;
    _sensors = widget.service.sensors;
    _busy = widget.service.isBusy;

    widget.service.lockStream.listen((state) {
      if (mounted) setState(() => _lockState = state);
    });
    widget.service.sensorStream.listen((snapshot) {
      if (mounted) setState(() => _sensors = snapshot);
    });
  }

  Future<void> _onPrimaryAction() async {
    setState(() => _busy = true);
    if (_lockState == DropBoxLockState.secured) {
      await widget.service.unlock();
    } else {
      await widget.service.lock();
    }
    if (mounted) {
      setState(() {
        _busy = widget.service.isBusy;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final logs = widget.service.activityLog;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SMART DROP BOX'),

      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accentBlue,
          onRefresh: () async {
            await Future<void>.delayed(const Duration(milliseconds: 400));
            if (mounted) setState(() {});
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              LockStatusCard(
                lockState: _lockState,
                isBusy: _busy,
                onPrimaryAction: _onPrimaryAction,
              ),
              const SizedBox(height: 28),
              const SectionHeader(title: 'LIVE SENSORS'),
              SensorCardsRow(sensors: _sensors),
              const SizedBox(height: 28),
              SectionHeader(
                title: 'DELIVERY LOG',
                trailing: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ActivityLogScreen(entries: logs),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: ActivityFeed(entries: logs, maxItems: 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
