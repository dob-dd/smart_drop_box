import 'parcel.dart';

typedef AddParcelOnSubmit = void Function({
  required ParcelPlatform platform,
  required String shipmentNumber,
  required DateTime expectedDeliveryDate,
});
