import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/cart_controller.dart';
import 'package:myapp/models/product.dart';
import 'package:flutter/material.dart';
import 'package:myapp/main.dart';

void main() {
  final uuidPattern = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  );
  late CartController controller;

  setUp(() {
    controller = CartController();
    controller.onInit(); // call manually outside widget tree
  });

  tearDown(() => Get.deleteAll());

  group('CartController', () {
    test('starts with empty cart', () {
      expect(controller.items.isEmpty, true);
      expect(controller.itemCount.value, 0);
    });

    test('addItem increases item count', () {
      controller.addItem(Product(id: '1', name: 'Widget'));
      expect(controller.itemCount.value, 1);
    });

    test('addItem adds product name to cart with a cart UUID', () {
      final product = Product(id: '1', name: 'Widget');

      controller.addItem(product);

      expect(controller.items.first.name, product.name);
      expect(controller.items.first.id, matches(uuidPattern));
      expect(controller.itemCount.value, 1);
    });

    test('addItem keeps products in the order they were added', () {
      final p1 = Product(id: '1', name: 'Widget');
      final p2 = Product(id: '2', name: 'Gadget');

      controller.addItem(p1);
      controller.addItem(p2);

      expect(controller.items[0].name, p1.name);
      expect(controller.items[1].name, p2.name);
    });

    test('itemCount matches cart length after adding products', () {
      controller.addItem(Product(id: '1', name: 'Widget'));
      controller.addItem(Product(id: '2', name: 'Gadget'));

      expect(controller.itemCount.value, controller.items.length);
    });
    test('clearCart empties items', () {
      controller.clearCart();
      expect(controller.items.isEmpty, true);

      controller.addItem(Product(id: '1', name: 'Widget'));
      controller.clearCart();
      expect(controller.items.isEmpty, true);
    });

    test('clearCart resets item count', () {
      controller.addItem(Product(id: '1', name: 'Widget'));
      controller.addItem(Product(id: '2', name: 'Gadget'));

      controller.clearCart();

      expect(controller.items.isEmpty, true);
      expect(controller.itemCount.value, 0);
    });

    test('itemCount matches cart length after clearing cart', () {
      controller.addItem(Product(id: '1', name: 'Widget'));

      controller.clearCart();

      expect(controller.itemCount.value, controller.items.length);
    });

    test('clearCart on empty cart keeps cart empty and count zero', () {
      controller.clearCart();

      expect(controller.items.isEmpty, true);
      expect(controller.itemCount.value, 0);
    });

    test('can add products again after clearing cart', () {
      controller.addItem(Product(id: '1', name: 'Widget'));
      controller.clearCart();

      controller.addItem(Product(id: '2', name: 'Gadget'));

      expect(controller.items.length, 1);
      expect(controller.itemCount.value, 1);
      expect(controller.items.first.name, 'Gadget');
    });

    test('adding same product twice results in count 2', () {
      final p = Product(id: '1', name: 'Widget');
      controller.addItem(p);
      controller.addItem(p);
      expect(controller.itemCount.value, 2);
    });

    test('adding same product twice creates different cart UUIDs', () {
      final p = Product(id: '1', name: 'Widget');

      controller.addItem(p);
      controller.addItem(p);

      expect(controller.items[0].id, isNot(controller.items[1].id));
      expect(controller.items[0].id, matches(uuidPattern));
      expect(controller.items[1].id, matches(uuidPattern));
    });
  });

  group('Cart and Product List Widget Tests', () {
    Future<void> pumpApp(WidgetTester tester) async {
      Get.put(CartController());
      await tester.pumpWidget(const MyApp());
    }

    testWidgets('shows product list items', (tester) async {
      await pumpApp(tester);

      expect(find.text('Apples'), findsOneWidget);
      expect(find.text('Bananas'), findsOneWidget);
      expect(find.text('Oranges'), findsOneWidget);
      expect(find.text('Pears'), findsOneWidget);
      expect(find.text('Strawberries'), findsOneWidget);
    });

    testWidgets('cart count starts at zero', (tester) async {
      await pumpApp(tester);

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('adding item updates cart count', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Add to Cart').first);
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('added item appears in cart', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Add to Cart').first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      expect(find.text('Apples'), findsOneWidget);
    });

    testWidgets('cart item shows uuid subtitle', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Add to Cart').first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      final uuidFinder = find.byWidgetPredicate((widget) {
        if (widget is! Text || widget.data == null) {
          return false;
        }

        return uuidPattern.hasMatch(widget.data!);
      });

      expect(uuidFinder, findsOneWidget);
    });

    testWidgets('delete button removes the specified item from cart', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.tap(find.text('Add to Cart').first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      expect(find.text('Apples'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.text('Apples'), findsNothing);
      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets(
      'deleting one duplicate item in cart leaves cart with one item',
      (tester) async {
        await pumpApp(tester);

        await tester.tap(find.text('Add to Cart').first);
        await tester.pump();
        await tester.tap(find.text('Add to Cart').first);
        await tester.pump();
        await tester.tap(find.byIcon(Icons.shopping_cart));
        await tester.pumpAndSettle();

        expect(find.text('Apples'), findsNWidgets(2));

        await tester.tap(find.byIcon(Icons.delete).first);
        await tester.pump();

        expect(find.text('Apples'), findsOneWidget);
        expect(find.text('Cart is empty'), findsNothing);
      },
    );

    testWidgets(
      'adding same product twice shows two cart rows with different UUIDs',
      (tester) async {
        await pumpApp(tester);

        await tester.tap(find.text('Add to Cart').first);
        await tester.pump();
        await tester.tap(find.text('Add to Cart').first);
        await tester.pump();
        await tester.tap(find.byIcon(Icons.shopping_cart));
        await tester.pumpAndSettle();

        final uuidFinder = find.byWidgetPredicate((widget) {
          if (widget is! Text || widget.data == null) {
            return false;
          }

          return uuidPattern.hasMatch(widget.data!);
        });
        final uuids = <String>[];
        final uuidTextWidgets = tester.widgetList<Text>(uuidFinder);

        for (final uuidTextWidget in uuidTextWidgets) {
          uuids.add(uuidTextWidget.data!);
        }

        expect(find.text('Apples'), findsNWidgets(2));
        expect(uuidFinder, findsNWidgets(2));
        expect(uuids[0], isNot(uuids[1]));
      },
    );
  });
}
