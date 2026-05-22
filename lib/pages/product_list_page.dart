import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/cart_controller.dart';
import 'package:myapp/models/product.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({super.key});

  final cart = Get.find<CartController>();

  final products = const [
    Product(id: '1', name: 'Apples'),
    Product(id: '2', name: 'Bananas'),
    Product(id: '3', name: 'Oranges'),
    Product(id: '4', name: 'Pears'),
    Product(id: '5', name: 'Strawberries'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          Obx(
            () => TextButton.icon(
              onPressed: () => Get.toNamed('/cart'),
              icon: const Icon(Icons.shopping_cart),
              label: Text('${cart.itemCount.value}'),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ListTile(
            title: Text(product.name),
            trailing: ElevatedButton(
              onPressed: () => cart.addItem(product),
              child: const Text('Add to Cart'),
            ),
          );
        },
      ),
    );
  }
}
