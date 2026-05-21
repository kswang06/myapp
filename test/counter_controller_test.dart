import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/cart_controller.dart';
import 'package:myapp/models/product.dart';

void main() {
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

    test('addItem adds product to items', () {
      final product = Product(id: '1', name: 'Widget');

      controller.addItem(product);

      expect(controller.items, contains(product));
      expect(controller.itemCount.value, 1);
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

    test('adding same product twice results in count 2', () {
      final p = Product(id: '1', name: 'Widget');
      controller.addItem(p);
      controller.addItem(p);
      expect(controller.itemCount.value, 2);
    });
  });
}
