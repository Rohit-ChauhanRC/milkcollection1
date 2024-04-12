import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/collectmilk_controller.dart';

class CollectmilkView extends GetView<CollectmilkController> {
  const CollectmilkView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CollectmilkView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CollectmilkView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
