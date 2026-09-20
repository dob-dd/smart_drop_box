enum ActivityLogKind { unlock, lock, entry, alert }

enum ActivitySource { owner, system, courier, alert }

class ActivityLogEntry {
  const ActivityLogEntry({
    required this.timestamp,
    required this.message,
    required this.kind,
    required this.sourceLabel,
    this.source = ActivitySource.system,
    this.shipmentNumber,
  });

  final DateTime timestamp;
  final String message;
  final ActivityLogKind kind;
  final String sourceLabel;
  final ActivitySource source;
  final String? shipmentNumber;

  bool get isAlert => kind == ActivityLogKind.alert;
}
