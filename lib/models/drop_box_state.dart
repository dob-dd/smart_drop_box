enum DropBoxLockState { secured, unlocked }

enum ConnectionChannel { bluetooth, wifi, none }

class SensorSnapshot {
  const SensorSnapshot({
    required this.payloadKg,
    required this.clearanceCm,
    required this.maxClearanceCm,
  });

  final double payloadKg;
  final double clearanceCm;
  final double maxClearanceCm;

  double get spacePercent =>
      maxClearanceCm <= 0 ? 0 : (clearanceCm / maxClearanceCm * 100).clamp(0, 100);

  bool get isEmpty => payloadKg < 0.01;

  String get payloadLabel => '${payloadKg.toStringAsFixed(2)} KG';

  String get clearanceLabel => '${clearanceCm.toStringAsFixed(1)} CM';
}
