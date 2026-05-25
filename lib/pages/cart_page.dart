import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final cart = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          TextButton(
            onPressed: cart.clearCart,
            child: const Text('Clear cart'),
          ),
        ],
      ),
      body: Obx(() {
        if (cart.items.isEmpty) {
          return const Center(child: Text('Cart is empty'));
        }

        return ListView.builder(
          itemCount: cart.items.length,
          itemBuilder: (context, index) {
            final product = cart.items[index];

            return ListTile(
              title: Text(product.name),
              trailing: IconButton(
                onPressed: () => cart.removeItemAt(index),
                icon: const Icon(Icons.delete),
              ),
            );
          },
        );
      }),
    );
  }
}
