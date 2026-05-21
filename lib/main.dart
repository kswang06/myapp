import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/cart_controller.dart';
import 'package:myapp/pages/cart_page.dart';
import 'package:myapp/pages/product_list_page.dart';
import 'package:myapp/repositories/post_repository.dart';
import 'package:myapp/widgets/posts_list.dart';

void main() {
  Get.put(CartController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(body: PostsList(repository: HttpPostRepository())),
      getPages: [
        GetPage(name: '/products', page: () => ProductListPage()),
        GetPage(name: '/cart', page: () => CartPage()),
      ],
      initialRoute: '/products',
    );
  }
}
