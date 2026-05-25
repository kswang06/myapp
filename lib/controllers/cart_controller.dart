import 'package:get/get.dart';
import 'package:myapp/models/product.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  final _uuid = const Uuid();
  final items = <Product>[].obs;
  final itemCount = 0.obs;

  void addItem(Product product) {
    items.add(Product(id: _uuid.v4(), name: product.name));
    itemCount.value = items.length;
  }

  void removeItemAt(int index) {
    items.removeAt(index);
    itemCount.value = items.length;
  }

  void clearCart() {
    items.clear();
    itemCount.value = 0;
  }
}
