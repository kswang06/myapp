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

    test('addItem adds product to cart', () {
      final product = Product(id: '1', name: 'Widget');

      controller.addItem(product);

      expect(controller.items, contains(product));
      expect(controller.itemCount.value, 1);
    });

    test('addItem keeps products in the order they were added', () {
      final p1 = Product(id: '1', name: 'Widget');
      final p2 = Product(id: '2', name: 'Gadget');

      controller.addItem(p1);
      controller.addItem(p2);

      expect(controller.items[0], p1);
      expect(controller.items[1], p2);
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
  });
}
