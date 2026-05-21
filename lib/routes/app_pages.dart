import 'package:get/get.dart';
import 'package:myapp/pages/cart_page.dart';
import 'package:myapp/pages/product_list_page.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.CART, page: () => CartPage()),
    GetPage(name: Routes.PRODUCT_LIST, page: () => ProductListPage()),
  ];
}
