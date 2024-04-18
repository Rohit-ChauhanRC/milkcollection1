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
                        print("object");
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
                    validator: (val) =>
                        val!.length < 3 ? "Field is required!" : null,
                  ),
                )),

            Obx(
              () => Container(
                  margin: const EdgeInsets.all(20),
                  height: Get.height * 0.7,
                  // color: Colors.amber,
                  child: ListView.builder(
                      itemCount: controller.farmerData.length,
                      itemBuilder: (ctx, i) {
                        return Container(
                          decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(Routes.FARMER, arguments: [
                                true,
                                controller.farmerData[i].farmerId
                              ]);
                            },
                            title: Text(
                              controller.farmerData[i].farmerName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              controller.farmerData[i].farmerId.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.settings,
                                color: AppColors.white,
                              ),
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
