import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              // alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              image: Image.asset(
                "assets/images/background.jpg",
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
                scale: 1,
              ).image)),
      child: child,
    );
  }
}
