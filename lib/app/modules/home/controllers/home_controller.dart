import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:milkcollection/app/data/local_database/ratechart_db.dart';
import 'dart:convert';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:milkcollection/app/data/models/ratechart_model.dart';

class HomeController extends GetxController {
  //
  final box = GetStorage();

  final RateChartDB rateChartDB = RateChartDB();

  ProgressDialog pd = ProgressDialog(context: Get.context);

  final RxInt _radio = 1.obs;
  int get radio => _radio.value;
  set radio(int i) => _radio.value = i;

  final RxList<RatechartModel> _rateChartData = RxList<RatechartModel>();
  List<RatechartModel> get rateChartData => _rateChartData;
  set rateChartData(List<RatechartModel> lst) => _rateChartData.assignAll(lst);

  @override
  void onInit() {
    super.onInit();
    if (DateTime.now().hour < 12) {
      radio = 1;
    } else {
      radio = 2;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getRaateChart(String milkType) async {
    try {
      var res = await http.get(
        Uri.parse(
            "http://Payment.maklife.in:9019/api/GetRateChart?CollectionCenterId=${box.read("centerId")}&MilkType=$milkType"),
      );

      if (res.statusCode == 200) {
        rateChartData.assignAll([]);

        rateChartData.assignAll(ratechartModelFromMap(res.body));
        if (rateChartData.isNotEmpty) {
          for (var e in rateChartData) {
            if (box.read("ratecounter") == null) {
              pd.show(max: rateChartData.length, msg: 'Downloading...');
              await rateChartDB.create(
                collectionCenterId: box.read("centerId"),
                counters: e.counters,
                fat: e.fat,
                insertedDate: e.insertedDate.toIso8601String(),
                milkType: e.milkType,
                price: e.price.toString(),
                snf: e.snf,
              );
              box.write("ratecounter", e.counters);
            } else if (box.read("ratecounter") != null &&
                box.read("ratecounter") < e.counters) {
              pd.show(max: rateChartData.length, msg: 'Downloading...');
              await rateChartDB.create(
                collectionCenterId: box.read("centerId"),
                counters: e.counters,
                fat: e.fat,
                insertedDate: e.insertedDate.toIso8601String(),
                milkType: e.milkType,
                price: e.price.toString(),
                snf: e.snf,
              );
              box.write("ratecounter", e.counters);
            } else {}
          }
        }
        rateChartData.assignAll([]);
      } else {}
    } catch (e) {}
  }
}
