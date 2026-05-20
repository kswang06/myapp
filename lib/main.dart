import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/repositories/post_repository.dart';
import 'package:myapp/widgets/posts_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        body: PostsList(
          repository: HttpPostRepository(),
        ),
      ),
    );
  }
}
