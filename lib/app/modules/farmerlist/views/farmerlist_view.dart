import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:milkcollection/app/routes/app_pages.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/widgets/backdround_container.dart';
import 'package:milkcollection/app/widgets/custom_button.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';

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
            Obx(() => Container(
                  margin: const EdgeInsets.all(20),
                  child: TextFormWidget(
                    prefix: InkWell(
                      onTap: () {
                        if (controller.search.trim().isNotEmpty) {
                          controller.searchActive = true;
                          controller.getSearchFarmerData();
                        } else {
                          controller.searchActive = false;
                          controller.searchAll();
                        }
                      },
                      child: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                    initialValue: controller.search,
                    label: "Please enter Search...",
                    onChanged: (val) {
                      controller.search = val;
                      if (controller.search.trim().isNotEmpty) {
                        controller.searchActive = true;
                        controller.getSearchFarmerData();
                      } else {
                        controller.searchActive = false;
                        controller.searchAll();
                      }
                    },
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
                          : controller.farmerData.length,
                      itemBuilder: (ctx, i) {
                        return Container(
                          decoration: BoxDecoration(
                              color: AppColors.card.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.FARMER, arguments: [
                                true,
                                controller.searchActive
                                    ? controller.searchfarmerData[i].farmerId
                                    : controller.farmerData[i].farmerId
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
                                          : controller
                                              .farmerData[i].farmerName!,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      controller.searchActive
                                          ? controller
                                              .searchfarmerData[i].farmerId
                                              .toString()
                                          : controller.farmerData[i].farmerId
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
            controller.farmerData[controller.farmerData.length - 1].farmerId
          ]);
        },
        title: "Add Farmer",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
