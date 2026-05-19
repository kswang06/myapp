import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/counter_controller.dart';
import 'package:myapp/widgets/counter_widget.dart';

void main() {
  setUp(() => Get.put(CounterController()));
  tearDown(() => Get.deleteAll());

  group('CounterWidget', () {
    testWidgets('starts at zero', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: CounterWidget()));
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('increments on tap', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: CounterWidget()));
      await tester.tap(find.text('+'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('does not go below zero', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: CounterWidget()));
      await tester.tap(find.text('-'));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('decrements on tap', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: CounterWidget()));

      await tester.tap(find.text('+'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.text('-'));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('resets on tap', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: CounterWidget()));

      await tester.tap(find.text('+'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.text('+'));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.text('reset'));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });
  });
}
