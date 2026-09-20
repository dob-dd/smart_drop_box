import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drop_box/main.dart';
import 'package:smart_drop_box/services/drop_box_service.dart';

void main() {
  testWidgets('shows lock status and sensors', (tester) async {
    final service = MockDropBoxService();
    addTearDown(service.dispose);

    await tester.pumpWidget(SmartDropBoxApp(service: service));
    await tester.pumpAndSettle();

    expect(find.text('SMART DROP BOX'), findsOneWidget);
    expect(find.text('LIVE SENSORS'), findsOneWidget);
    expect(find.text('TAP TO UNLOCK'), findsNothing);
    expect(find.text('LOCK CONTAINER'), findsOneWidget);
    expect(find.text('0.00 KG'), findsOneWidget);
  });
}
