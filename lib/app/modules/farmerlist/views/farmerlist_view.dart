import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:milkcollection/app/routes/app_pages.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/widgets/backdround_container.dart';
import 'package:milkcollection/app/widgets/custom_button.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';
import 'package:http/http.dart' as http;

import '../controllers/farmerlist_controller.dart';

class FarmerlistView extends GetView<FarmerlistController> {
  const FarmerlistView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer List'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: BackgroundContainer(
        child: Column(
          children: [
            // SizedBox(
            //   height: 10.h,
            // ),
            Obx(() => Container(
                  margin: const EdgeInsets.all(20),
                  // width: Get.width * 0.7,
                  // height: 65.h,
                  child: TextFormWidget(
                    prefix: InkWell(
                      onTap: () {
                        if (controller.search.trim().isNotEmpty) {
                          controller.searchActive = true;
                          controller.getSearchFarmerData();
                        } else {
                          controller.searchActive = false;
                        }
                      },
                      child: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                    initialValue: controller.search,
                    label: "Please enter Search...",
                    onChanged: (val) => controller.search = val,
                    keyboardType: TextInputType.text,
                    maxLength: 10,
                  ),
                )),

            Obx(
              () => Container(
                  margin: const EdgeInsets.only(
                      top: 0, bottom: 20, left: 20, right: 20),
                  height: Get.height * 0.7,
                  // color: Colors.amber,
                  child: ListView.builder(
                      itemCount: controller.searchActive
                          ? controller.searchfarmerData.length
                          : controller.pinverifyController.farmerData.length,
                      itemBuilder: (ctx, i) {
                        return Container(
                          decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.FARMER, arguments: [
                                true,
                                controller.searchActive
                                    ? controller.searchfarmerData[i].farmerId
                                    : controller.pinverifyController
                                        .farmerData[i].farmerId
                              ]);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      controller.searchActive
                                          ? controller
                                              .searchfarmerData[i].farmerName!
                                          : controller.pinverifyController
                                              .farmerData[i].farmerName!,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      controller.searchActive
                                          ? controller
                                              .searchfarmerData[i].farmerId
                                              .toString()
                                          : controller.pinverifyController
                                              .farmerData[i].farmerId
                                              .toString(),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.settings,
                                    color: AppColors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            ),
          ],
        ),
      )),
      floatingActionButton: CustomButton(
        onPressed: () {
          // Get.toNamed(Routes.FARMER);
          Get.toNamed(Routes.FARMER, arguments: [
            false,
            controller
                .pinverifyController
                .farmerData[
                    controller.pinverifyController.farmerData.length - 1]
                .farmerId
          ]);
        },
        title: "Add Farmer",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
