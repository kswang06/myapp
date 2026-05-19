import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/counter_controller.dart';

class CounterWidget extends StatelessWidget {
  CounterWidget({super.key});

  final CounterController c = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Text('${c.count}'),
          ElevatedButton(onPressed: c.increment, child: const Text('+')),
          ElevatedButton(onPressed: c.decrement, child: const Text('-')),
          ElevatedButton(onPressed: c.reset, child: const Text('reset')),
        ],
      ),
    );
  }
}
