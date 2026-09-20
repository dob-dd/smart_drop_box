enum ParcelPlatform { lazada, tiktokShop, shopee }

enum ParcelStatus { pending, inDelivery, completed }

class Parcel {
  const Parcel({
    required this.id,
    required this.platform,
    required this.shipmentNumber,
    required this.expectedDeliveryDate,
    required this.status,
  });

  final String id;
  final ParcelPlatform platform;
  final String shipmentNumber;
  final DateTime expectedDeliveryDate;
  final ParcelStatus status;

  String get platformLabel => switch (platform) {
        ParcelPlatform.lazada => 'Lazada',
        ParcelPlatform.tiktokShop => 'TikTok Shop',
        ParcelPlatform.shopee => 'Shopee',
      };

  String get statusLabel => switch (status) {
        ParcelStatus.pending => 'Pending',
        ParcelStatus.inDelivery => 'In Delivery',
        ParcelStatus.completed => 'Completed',
      };
}
