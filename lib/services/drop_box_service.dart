import 'dart:async';

import '../models/activity_log_entry.dart';
import '../models/drop_box_state.dart';

/// Abstraction for solenoid control over BLE or Wi‑Fi. Replace [MockDropBoxService]
/// with a platform implementation when hardware is available.
abstract class DropBoxService {
  Stream<SensorSnapshot> get sensorStream;
  Stream<DropBoxLockState> get lockStream;
  List<ActivityLogEntry> get activityLog;

  DropBoxLockState get lockState;
  SensorSnapshot get sensors;
  ConnectionChannel get preferredChannel;
  bool get isBusy;

  Future<void> unlock({ConnectionChannel? channel});
  Future<void> lock({ConnectionChannel? channel});
  void setPreferredChannel(ConnectionChannel channel);
  void dispose();
}

class MockDropBoxService implements DropBoxService {
  MockDropBoxService() {
    _sensors = const SensorSnapshot(
      payloadKg: 0,
      clearanceCm: 50,
      maxClearanceCm: 50,
    );
    _lockState = DropBoxLockState.unlocked;
    _activityLog = _seedLogs();
    _sensorController = StreamController<SensorSnapshot>.broadcast();
    _lockController = StreamController<DropBoxLockState>.broadcast();
    _tickTimer = Timer.periodic(const Duration(seconds: 4), (_) => _simulateSensorDrift());
  }

  late SensorSnapshot _sensors;
  late DropBoxLockState _lockState;
  late List<ActivityLogEntry> _activityLog;
  late final StreamController<SensorSnapshot> _sensorController;
  late final StreamController<DropBoxLockState> _lockController;
  Timer? _tickTimer;
  bool _busy = false;

  ConnectionChannel _preferredChannel = ConnectionChannel.bluetooth;

  @override
  Stream<SensorSnapshot> get sensorStream => _sensorController.stream;

  @override
  Stream<DropBoxLockState> get lockStream => _lockController.stream;

  @override
  List<ActivityLogEntry> get activityLog => List.unmodifiable(_activityLog);

  @override
  DropBoxLockState get lockState => _lockState;

  @override
  SensorSnapshot get sensors => _sensors;

  @override
  ConnectionChannel get preferredChannel => _preferredChannel;

  @override
  bool get isBusy => _busy;

  @override
  Future<void> unlock({ConnectionChannel? channel}) async {
    if (_busy || _lockState == DropBoxLockState.unlocked) return;
    _busy = true;
    final via = channel ?? _preferredChannel;
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _lockState = DropBoxLockState.unlocked;
    _lockController.add(_lockState);
    _prependLog(
      ActivityLogEntry(
        timestamp: DateTime.now(),
        message: '[UNLOCK] Manual ${_channelLabel(via)} unlock via app',
        kind: ActivityLogKind.unlock,
        sourceLabel: 'OWNER',
        source: ActivitySource.owner,
      ),
    );
    _busy = false;
  }

  @override
  Future<void> lock({ConnectionChannel? channel}) async {
    if (_busy || _lockState == DropBoxLockState.secured) return;
    _busy = true;
    final via = channel ?? _preferredChannel;
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _lockState = DropBoxLockState.secured;
    _lockController.add(_lockState);
    _prependLog(
      ActivityLogEntry(
        timestamp: DateTime.now(),
        message: '[LOCK] Solenoid latch engaged (${_channelLabel(via)})',
        kind: ActivityLogKind.lock,
        sourceLabel: 'SYSTEM',
        source: ActivitySource.system,
      ),
    );
    _busy = false;
  }

  @override
  void setPreferredChannel(ConnectionChannel channel) {
    _preferredChannel = channel;
  }

  void _simulateSensorDrift() {
    if (_sensors.isEmpty) return;
    _sensors = SensorSnapshot(
      payloadKg: _sensors.payloadKg,
      clearanceCm: (_sensors.clearanceCm - 0.05).clamp(0, _sensors.maxClearanceCm),
      maxClearanceCm: _sensors.maxClearanceCm,
    );
    _sensorController.add(_sensors);
  }

  void _prependLog(ActivityLogEntry entry) {
    _activityLog = [entry, ..._activityLog];
  }

  static List<ActivityLogEntry> _seedLogs() {
    final now = DateTime.now();
    return [
      ActivityLogEntry(
        timestamp: now.subtract(const Duration(hours: 2, minutes: 30)),
        message: '[UNLOCK] Manual BLE unlock via owner app',
        kind: ActivityLogKind.unlock,
        sourceLabel: 'OWNER',
        source: ActivitySource.owner,
      ),
      ActivityLogEntry(
        timestamp: now.subtract(const Duration(hours: 5, minutes: 10)),
        message: '[LOCK] Solenoid latch auto-engaged after delivery',
        kind: ActivityLogKind.lock,
        sourceLabel: 'SYSTEM',
        source: ActivitySource.system,
      ),
      ActivityLogEntry(
        timestamp: now.subtract(const Duration(hours: 5, minutes: 13)),
        message: '[ENTRY] Parcel detected (1.25 kg)',
        kind: ActivityLogKind.entry,
        sourceLabel: 'Shopee',
        source: ActivitySource.courier,
      ),
      ActivityLogEntry(
        timestamp: now.subtract(const Duration(hours: 8, minutes: 25)),
        message: '[ALERT] Container lid left open (>5 min)',
        kind: ActivityLogKind.alert,
        sourceLabel: 'ALERT',
        source: ActivitySource.alert,
      ),
    ];
  }

  static String _channelLabel(ConnectionChannel channel) {
    return switch (channel) {
      ConnectionChannel.bluetooth => 'BLE',
      ConnectionChannel.wifi => 'Wi‑Fi',
      ConnectionChannel.none => 'local',
    };
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _sensorController.close();
    _lockController.close();
  }
}
