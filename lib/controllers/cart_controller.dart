import 'package:get/get.dart';
import 'package:myapp/models/product.dart';

class CartController extends GetxController {
  final items = <Product>[].obs;
  final itemCount = 0.obs;

  void addItem(Product product) {
    items.add(product);
    itemCount.value = items.length;
  }

  void clearCart() {
    items.clear();
    itemCount.value = 0;
  }
}
