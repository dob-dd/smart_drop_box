import 'package:flutter/foundation.dart';

import '../models/parcel.dart';

class ParcelStore extends ChangeNotifier {
  ParcelStore() : _parcels = _seedParcels();

  List<Parcel> _parcels;

  List<Parcel> get parcels => List.unmodifiable(_parcels);

  void addParcel({
    required ParcelPlatform platform,
    required String shipmentNumber,
    required DateTime expectedDeliveryDate,
    ParcelStatus status = ParcelStatus.pending,
  }) {
    _parcels = [
      Parcel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        platform: platform,
        shipmentNumber: shipmentNumber.trim(),
        expectedDeliveryDate: expectedDeliveryDate,
        status: status,
      ),
      ..._parcels,
    ];
    notifyListeners();
  }

  static List<Parcel> _seedParcels() {
    final now = DateTime.now();
    return [
      Parcel(
        id: '1',
        platform: ParcelPlatform.shopee,
        shipmentNumber: 'SPX-PH-8829104',
        expectedDeliveryDate: now.add(const Duration(days: 1)),
        status: ParcelStatus.inDelivery,
      ),
      Parcel(
        id: '2',
        platform: ParcelPlatform.lazada,
        shipmentNumber: 'LZD-4412098',
        expectedDeliveryDate: now.subtract(const Duration(days: 1)),
        status: ParcelStatus.completed,
      ),
      Parcel(
        id: '3',
        platform: ParcelPlatform.tiktokShop,
        shipmentNumber: 'TT-9921044',
        expectedDeliveryDate: now.add(const Duration(days: 3)),
        status: ParcelStatus.pending,
      ),
    ];
  }
}
