import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/shiftdetails_controller.dart';

class ShiftdetailsView extends GetView<ShiftdetailsController> {
  const ShiftdetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShiftdetailsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ShiftdetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
