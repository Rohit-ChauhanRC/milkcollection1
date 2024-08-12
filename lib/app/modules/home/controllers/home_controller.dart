import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:milkcollection/app/utils/network_check.dart';
import 'package:milkcollection/app/utils/utils.dart';

import 'package:flutter/services.dart';
import 'package:flutter_sms_android/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/cans_db.dart';
import 'package:milkcollection/app/data/local_database/milk_collection_db.dart';
import 'package:milkcollection/app/data/local_database/rateChartCM_db.dart';
import 'package:milkcollection/app/data/local_database/ratechart_db.dart';
import 'package:milkcollection/app/data/models/cans_model.dart';
import 'package:milkcollection/app/data/models/centerMobileSmsModel.dart';
import 'package:milkcollection/app/data/models/get_farmer_payment_details_model.dart';
import 'package:milkcollection/app/data/models/get_farmer_payment_model.dart';
import 'package:milkcollection/app/data/models/milk_collection_model.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/theme/app_dimens.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:milkcollection/app/data/models/ratechart_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomeController extends GetxController {
  //
  final box = GetStorage();

  final RateChartDB rateChartDB = RateChartDB();
  final RateChartCMDB rateChartCMDB = RateChartCMDB();
  final MilkCollectionDB milkCollectionDB = MilkCollectionDB();
  final CansDB cansDB = CansDB();

  ProgressDialog pd = ProgressDialog(context: Get.context);

  final RxInt _radio = 1.obs;
  int get radio => _radio.value;
  set radio(int i) => _radio.value = i;

  final RxList<RatechartModel> _rateChartData = RxList<RatechartModel>();
  List<RatechartModel> get rateChartData => _rateChartData;
  set rateChartData(List<RatechartModel> lst) => _rateChartData.assignAll(lst);

  final RxList<CenterMobileSmsModel> _centerMobileSmsModel =
      RxList<CenterMobileSmsModel>();
  List<CenterMobileSmsModel> get centerMobileSmsModel => _centerMobileSmsModel;
  set centerMobileSmsModel(List<CenterMobileSmsModel> lst) =>
      _centerMobileSmsModel.assignAll(lst);

  final RxString _fromDate = "${DateTime.now()}".obs;
  String get fromDate => _fromDate.value;
  set fromDate(String str) => _fromDate.value = str;

  final RxString _ip = "".obs;
  String get ip => _ip.value;
  set ip(String i) => _ip.value = i;

  final RxString _fat = "".obs;
  String get fat => _fat.value;
  set fat(String i) => _fat.value = i;

  final RxString _snf = "".obs;
  String get snf => _snf.value;
  set snf(String i) => _snf.value = i;

  final RxString _water = "".obs;
  String get water => _water.value;
  set water(String i) => _water.value = i;

  final RxString _quantity = "".obs;
  String get quantity => _quantity.value;
  set quantity(String i) => _quantity.value = i;

  final RxString _printSummaryData = "".obs;
  String get printSummaryData => _printSummaryData.value;
  set printSummaryData(String i) => _printSummaryData.value = i;

  final RxBool _printStatus = false.obs;
  bool get printStatus => _printStatus.value;
  set printStatus(bool b) => _printStatus.value = b;

  final RxList<MilkCollectionModel> _milkCollectionData =
      RxList<MilkCollectionModel>();
  List<MilkCollectionModel> get milkCollectionData => _milkCollectionData;
  set milkCollectionData(List<MilkCollectionModel> lst) =>
      _milkCollectionData.assignAll(lst);

  final RxList<CansModel> _cansModel = RxList<CansModel>();
  List<CansModel> get cansModel => _cansModel;
  set cansModel(List<CansModel> lst) => _cansModel.assignAll(lst);

  final RxDouble _totalMilk = 0.0.obs;
  double get totalMilk => _totalMilk.value;
  set totalMilk(double i) => _totalMilk.value = i;

  final RxDouble _totalQty = 0.0.obs;
  double get totalQty => _totalQty.value;
  set totalQty(double i) => _totalQty.value = i;

  final RxDouble _totalFat = 0.0.obs;
  double get totalFat => _totalFat.value;
  set totalFat(double i) => _totalFat.value = i;

  final RxDouble _totalWater = 0.0.obs;
  double get totalWater => _totalWater.value;
  set totalWater(double i) => _totalWater.value = i;

  final RxDouble _totalPrice = 0.0.obs;
  double get totalPrice => _totalPrice.value;
  set totalPrice(double i) => _totalPrice.value = i;

  final RxDouble _totalSnf = 0.0.obs;
  double get totalSnf => _totalSnf.value;
  set totalSnf(double i) => _totalSnf.value = i;

  final RxDouble _totalAmt = 0.0.obs;
  double get totalAmt => _totalAmt.value;
  set totalAmt(double i) => _totalAmt.value = i;

  final RxString _totalCowCan = "".obs;
  String get totalCowCan => _totalCowCan.value;
  set totalCowCan(String i) => _totalCowCan.value = i;

  final RxString _totalBuffaloCan = "".obs;
  String get totalBuffaloCan => _totalBuffaloCan.value;
  set totalBuffaloCan(String i) => _totalBuffaloCan.value = i;

  // cow
  final RxDouble _totalMilkCow = 0.0.obs;
  double get totalMilkCow => _totalMilkCow.value;
  set totalMilkCow(double i) => _totalMilkCow.value = i;

  final RxInt _totalQtyCow = 0.obs;
  int get totalQtyCow => _totalQtyCow.value;
  set totalQtyCow(int i) => _totalQtyCow.value = i;

  final RxDouble _totalFatCow = 0.0.obs;
  double get totalFatCow => _totalFatCow.value;
  set totalFatCow(double i) => _totalFatCow.value = i;

  final RxDouble _totalWaterCow = 0.0.obs;
  double get totalWaterCow => _totalWaterCow.value;
  set totalWaterCow(double i) => _totalWaterCow.value = i;

  final RxDouble _totalPriceCow = 0.0.obs;
  double get totalPriceCow => _totalPriceCow.value;
  set totalPriceCow(double i) => _totalPriceCow.value = i;

  final RxDouble _totalSnfCow = 0.0.obs;
  double get totalSnfCow => _totalSnfCow.value;
  set totalSnfCow(double i) => _totalSnfCow.value = i;

  final RxDouble _totalAmtCow = 0.0.obs;
  double get totalAmtCow => _totalAmtCow.value;
  set totalAmtCow(double i) => _totalAmtCow.value = i;
  // Buffallo
  final RxDouble _totalMilkBuffallo = 0.0.obs;
  double get totalMilkBuffallo => _totalMilkBuffallo.value;
  set totalMilkBuffallo(double i) => _totalMilkBuffallo.value = i;

  final RxInt _totalQtyBuffallo = 0.obs;
  int get totalQtyBuffallo => _totalQtyBuffallo.value;
  set totalQtyBuffallo(int i) => _totalQtyBuffallo.value = i;

  final RxDouble _totalFatBuffallo = 0.0.obs;
  double get totalFatBuffallo => _totalFatBuffallo.value;
  set totalFatBuffallo(double i) => _totalFatBuffallo.value = i;

  final RxDouble _totalWaterBuffallo = 0.0.obs;
  double get totalWaterBuffallo => _totalWaterBuffallo.value;
  set totalWaterBuffallo(double i) => _totalWaterBuffallo.value = i;

  final RxDouble _totalPriceBuffallo = 0.0.obs;
  double get totalPriceBuffallo => _totalPriceBuffallo.value;
  set totalPriceBuffallo(double i) => _totalPriceBuffallo.value = i;

  final RxDouble _totalSnfBuffallo = 0.0.obs;
  double get totalSnfBuffallo => _totalSnfBuffallo.value;
  set totalSnfBuffallo(double i) => _totalSnfBuffallo.value = i;

  final RxDouble _totalAmtBuffallo = 0.0.obs;
  double get totalAmtBuffallo => _totalAmtBuffallo.value;
  set totalAmtBuffallo(double i) => _totalAmtBuffallo.value = i;

  final RxList<String> _farmerPrintD = [""].obs;
  List<String> get farmerPrintD => _farmerPrintD;
  set farmerPrintD(List<String> str) => _farmerPrintD.assignAll(str);

  final RxBool _printDetails = false.obs;
  bool get printDetails => _printDetails.value;
  set printDetails(bool b) => _printDetails.value = b;

  final RxBool _printSummary = false.obs;
  bool get printSummary => _printSummary.value;
  set printSummary(bool b) => _printSummary.value = b;

  final RxString _cowCans = "".obs;
  String get cowCans => _cowCans.value;
  set cowCans(String b) => _cowCans.value = b;

  final RxString _bufCans = "".obs;
  String get bufCans => _bufCans.value;
  set bufCans(String b) => _bufCans.value = b;

  final RxBool _printPaymentSummary = false.obs;
  bool get printPaymentSummary => _printPaymentSummary.value;
  set printPaymentSummary(bool b) => _printPaymentSummary.value = b;

  final RxBool _printPaymentDetails = false.obs;
  bool get printPaymentDetails => _printPaymentDetails.value;
  set printPaymentDetails(bool b) => _printPaymentDetails.value = b;

  final RxList<GetFarmerPaymentModel> _farmerPaymentList =
      RxList<GetFarmerPaymentModel>();
  List<GetFarmerPaymentModel> get farmerPaymentList => _farmerPaymentList;
  set farmerPaymentList(List<GetFarmerPaymentModel> lst) =>
      _farmerPaymentList.assignAll(lst);

  final RxList<GetFarmerPaymentModel> _searchfarmerPaymentList =
      RxList<GetFarmerPaymentModel>();
  List<GetFarmerPaymentModel> get searchfarmerPaymentList =>
      _searchfarmerPaymentList;
  set searchfarmerPaymentList(List<GetFarmerPaymentModel> lst) =>
      _searchfarmerPaymentList.assignAll(lst);

  final RxBool _searchActive = false.obs;
  bool get searchActive => _searchActive.value;
  set searchActive(bool v) => _searchActive.value = v;

  final RxString _fromDateP = "".obs;
  String get fromDateP => _fromDateP.value;
  set fromDateP(String str) => _fromDateP.value = str;

  final RxString _toDateP = "".obs;
  String get toDateP => _toDateP.value;
  set toDateP(String str) => _toDateP.value = str;

  final RxString _printDetailsPaymentFarmer = "".obs;
  String get printDetailsPaymentFarmer => _printDetailsPaymentFarmer.value;
  set printDetailsPaymentFarmer(String str) =>
      _printDetailsPaymentFarmer.value = str;

  final RxBool _ipvCheck = false.obs;
  bool get ipvCheck => _ipvCheck.value;
  set ipvCheck(bool b) => _ipvCheck.value = b;

  @override
  void onInit() async {
    super.onInit();

    if (DateTime.now().hour < 12) {
      radio = 1;
    } else {
      radio = 2;
    }

    await getRateChartBM("B");
    await getRateChartCM("C");
  }

  @override
  void onReady() async {
    super.onReady();
    if (Platform.isIOS) {
      await getNetworkType();
    }
    await checkIp();

    await fetchMilkCollectionDateWise();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getNetworkType() async {
    String? networkType1;
    try {
      networkType1 = await NetworkCheck.getNetworkType();
    } on PlatformException {
      networkType1 = 'Failed to get network type.';
    }
    if (networkType1 != "5G") {
      Utils.showDialog(
          "Please use 5G sim or 5G network for printer, analyzer,weighing machine support!");
    }
  }

  Future<void> getShiftDetails() async {
    cansModel.assignAll(await cansDB.fetchCans(
        DateFormat("dd-MMM-yyyy").format(DateTime.now()),
        radio == 1 ? "Am" : "Pm"));
    if (cansModel.isNotEmpty) {
      cowCans = cansModel.first.cowCans != null
          ? cansModel.first.cowCans.toString()
          : "";
      bufCans = cansModel.first.bufCans != null
          ? cansModel.first.bufCans.toString()
          : "";
    }
  }

  Future<void> getRateChartBM(
    String milkType,
  ) async {
    try {
      var res = await http.get(
        Uri.parse(
            "http://Payment.maklife.in:9021/api/GetRateChart?CollectionCenterId=${box.read(centerIdConst)}&MilkType=$milkType"),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
              "true", // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS, GET"
        },
      );

      if (res.statusCode == 200) {
        rateChartData.assignAll([]);

        rateChartData.assignAll(ratechartModelFromMap(res.body));
        if (rateChartData.isNotEmpty) {
          box.read(rateChartBM);

          final counter = rateChartData.map((e) {
            final List lst = [];
            lst.add(int.parse(e.counters));
            return lst.reduce((curr, next) => curr > next ? curr : next);
          });

          if (box.read(rateChartBM) == null) {
            int count = 0;
            pd.show(
                max: rateChartData.length,
                msgFontSize: 10,
                valueFontSize: 10,
                msgTextAlign: TextAlign.left,
                msg: 'Downloading BM Rate Chart');

            for (var e in rateChartData) {
              pd.update(value: count += 1);

              await rateChartDB.create(
                collectionCenterId: box.read("centerId"),
                counters: e.counters,
                fat: e.fat,
                insertedDate: e.insertedDate.toString(),
                milkType: e.milkType,
                price: e.price.toString(),
                snf: e.snf,
              );
            }
            pd.close();
            box.write(rateChartBM, rateChartData.first.counters);
          }
          if (box.read(rateChartBM) != null &&
              (int.tryParse(box.read(rateChartBM))! <
                  int.parse(counter.first.toString()))) {
            await rateChartDB.deleteTable();
            int count = 0;
            count = 0;
            pd.show(
                msgFontSize: 10,
                valueFontSize: 10,
                max: rateChartData.length,
                msgTextAlign: TextAlign.left,
                msg: 'Downloading BM Rate Chart');

            for (var e in rateChartData) {
              pd.update(value: count += 1);

              await rateChartDB.create(
                collectionCenterId: box.read("centerId"),
                counters: e.counters,
                fat: e.fat,
                insertedDate: e.insertedDate.toString(),
                milkType: e.milkType,
                price: e.price.toString(),
                snf: e.snf,
              );
            }
            pd.close();

            box.write(rateChartBM, rateChartData.first.counters);
          }

          rateChartData.assignAll([]);
        }
        rateChartData.assignAll([]);
      }
    } catch (e) {
      rateChartData.assignAll([]);
    }
  }

  Future<void> getRateChartCM(
    String milkType,
  ) async {
    try {
      var res = await http.get(
        Uri.parse(
            "$baseUrlConst/GetRateChart?CollectionCenterId=${box.read("centerId")}&MilkType=$milkType"),
      );

      if (res.statusCode == 200) {
        rateChartData.assignAll([]);

        rateChartData.assignAll(ratechartModelFromMap(res.body));
        if (rateChartData.isNotEmpty) {
          final counter = rateChartData.map((e) {
            final List lst = [];
            lst.add(int.parse(e.counters));
            return lst.reduce((curr, next) => curr > next ? curr : next);
          });

          if (box.read(rateChartCM) == null) {
            int count = 0;
            pd.show(
                max: rateChartData.length,
                msgFontSize: 10,
                valueFontSize: 10,
                msgTextAlign: TextAlign.left,
                msg: 'Downloading CM Rate Chart');

            for (var e in rateChartData) {
              // count += 1;
              pd.update(value: count += 1);

              await rateChartCMDB.create(
                collectionCenterId: box.read("centerId"),
                counters: e.counters,
                fat: e.fat,
                insertedDate: e.insertedDate.toString(),
                milkType: e.milkType,
                price: e.price.toString(),
                snf: e.snf,
              );
              // pd.close();
            }
            pd.close();

            box.write(rateChartCM, rateChartData.first.counters);
          }
          if (box.read(rateChartCM) != null &&
              (int.tryParse(box.read(rateChartCM))! <
                  int.tryParse(counter.first.toString())!)) {
            await rateChartCMDB.deleteTable();
            int count = 0;
            count = 0;
            pd.show(
                msgFontSize: 10,
                valueFontSize: 10,
                max: rateChartData.length,
                msgTextAlign: TextAlign.left,
                msg: 'Downloading CM Rate Chart');

            for (var e in rateChartData) {
              // count += 1;
              pd.update(value: count += 1);

              await rateChartCMDB.create(
                collectionCenterId: box.read("centerId"),
                counters: e.counters,
                fat: e.fat,
                insertedDate: e.insertedDate.toString(),
                milkType: e.milkType,
                price: e.price.toString(),
                snf: e.snf,
              );
            }
            pd.close();

            box.write(rateChartCM, rateChartData.first.counters);
          }

          rateChartData.assignAll([]);
        }
        rateChartData.assignAll([]);
      }
    } catch (e) {
      rateChartData.assignAll([]);
    }
  }

  Future<void> checkIp() async {
    await Permission.locationWhenInUse.request();
    // await Permission.sms.request();

    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 &&
            (addr.address.startsWith('192') ||
                addr.address.startsWith('10') ||
                addr.address.startsWith('172'))) {
          ip = addr.address.split(".").getRange(0, 3).join(".");

          for (var i = 0; i < 255; i++) {
            anaylzerConnection("$ip.$i");

            weighingConnection("$ip.$i");

            printerConnection("$ip.$i");
          }
        } else if (addr.type == InternetAddressType.IPv6) {
          if (interface.name.startsWith("bridge100")) {
            if (interface.addresses[0].address.isIPv6 == true) {
              Utils.showDialog(
                  "Cannot find network for printer, analyzer,weighing machine support!");
            } else if (interface.addresses[0].address.isIPv4 == true) {
              ip = interface.addresses[0].address
                  .split(".")
                  .getRange(0, 3)
                  .join(".");

              for (var i = 0; i < 255; i++) {
                anaylzerConnection("$ip.$i");

                weighingConnection("$ip.$i");

                printerConnection("$ip.$i");
              }
            }
          }
        }
      }
    }
  }

  Future<void> weighingConnection(
    String ip,
  ) async {
    try {
      final server = await ServerSocket.bind(ip, 8881);

      server.listen((event) {
        weighingSocketConnection(event);
      });
    } catch (e) {}
  }

  Future<void> anaylzerConnection(String ip) async {
    try {
      final server = await ServerSocket.bind(ip, 8889);
      server.listen((event) {
        analyzerSocketConnection(event);
      });
    } catch (e) {}
  }

  Future<void> printerConnection(String ip) async {
    try {
      final server = await ServerSocket.bind(ip, 8883, shared: true);
      server.listen((event) {
        printerSocketConnection(event, ip);
      });
    } catch (e) {}
  }

  void analyzerSocketConnection(Socket client) {
    client.listen(
      (Uint8List data) {
        final message = String.fromCharCodes(data);

        print("analyser: $message");

        if (message
                .split(" ")[1]
                .replaceAll("Hex", "")
                .replaceAll("@", "")
                .toString()
                .length <
            6) {
          // if (kDebugMode) {
          print(
              "error: ${message.split(" ")[1].replaceAll("Hex", "").replaceAll("@", "").toString()}");
          // }
        } else if (message
                .split(" ")[1]
                .replaceAll("Hex", "")
                .replaceAll("@", "")
                .toString()
                .length >
            6) {
          fat =
              "${message.split(" ")[1].split("@")[1]}.${message.split(" ")[1].split("@")[2]}";
          snf =
              "${message.split(" ")[1].split("@")[3]}.${message.split(" ")[1].split("@")[4]}";

          water =
              "${message.split(" ")[1].split("@")[7]}.${message.split(" ")[1].split("@")[8]}";
          // }
        }

        update();
      },
      onError: (error) {
        // client.destroy();
      },
      onDone: () {
        // client.destroy();
      },
    );
  }

  void printerSocketConnection(Socket client, String ip) {
    client.listen(
      (Uint8List data) {
        ipvCheck = true;
        final message = String.fromCharCodes(data);

        if (kDebugMode) {
          print("printer :$message");
        }

        if (printStatus) {
          client.write(printSummaryData);
          printStatus = false;
        }

        if (printDetails) {
          client.write(printShift());
          printDetails = false;
        }
        if (printSummary) {
          client.write(printSummaryDetails());
          printSummary = false;
        }
        if (printPaymentSummary) {
          client.write(printPaymentsFarmerList());
          printPaymentSummary = false;
        }
        if (printPaymentDetails) {
          client.write(printDetailsPaymentFarmer);
          printPaymentDetails = false;
        }
      },
      onError: (error) {},
      onDone: () {},
    );
  }

  void weighingSocketConnection(Socket client) {
    client.listen(
      (Uint8List data) {
        final message = String.fromCharCodes(data);

        quantity = message
            .replaceAll(RegExp("[a-zA-Z]"), "")
            .replaceAll("=", "")
            .replaceAll(RegExp(r'[~!@#$%^&*()_+`{}|<>?;:./,=\-[]]'), "")
            .toString();
      },
      onError: (error) {},
      onDone: () {},
    );
  }

  printData({
    required String farmerName,
    required String shift,
    required String getFarmerId,
    required String fat1,
    required String snf1,
    required String quantity1,
    required String milkType,
    required String price,
    required String totalAmount,
  }) async {
    printSummaryData =
        "***Maklife Producer Company Ltd***\n\nDate  :  ${DateFormat("dd-MMM-yyyy").format(DateTime.now())}\nTime  :  $shift\nFarmerName    :     $farmerName\nFarmer Id     :     $getFarmerId\nFat           :     $fat1\nSnf           :     $snf1\nMilk Type     :     $milkType\nWeight        :     $quantity1\nPrice         :     $price\nAmount        :     $totalAmount\n          \n                      \n          \n       \n               \n           \n";
    printStatus = true;
  }

  void dbTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    final db = await milkCollectionDB.fetchByDate(
        DateFormat("dd-MMM-yyyy").format(DateTime.parse(fromDate)).toString(),
        radio == 1 ? "Am" : "Pm");
    sendPort.send(db);
  }

  Future<void> fetchMilkCollectionDateWise() async {
    totalAmt = 0.0;
    totalFat = 0.0;
    totalMilk = 0;
    totalPrice = 0.0;
    totalQty = 0;
    totalSnf = 0.0;
    totalWater = 0.0;

    milkCollectionData.assignAll(await milkCollectionDB.fetchByDate(
        DateFormat("dd-MMM-yyyy").format(DateTime.parse(fromDate)).toString(),
        radio == 1 ? "Am" : "Pm"));
    if (milkCollectionData.isNotEmpty) {
      // totalMilk = 0.0;
      totalAmtCow = 0.0;
      totalAmtBuffallo = 0.0;
      totalMilkBuffallo = 0.0;
      totalMilkCow = 0.0;
      totalMilk = 0.0;
      totalFat = 0.0;
      totalSnf = 0.0;
      totalWater = 0.0;
      totalPrice = 0.0;
      totalAmt = 0.0;
      totalQtyCow = 0;
      totalMilkCow = 0.0;
      totalFatCow = 0.0;
      totalSnfCow = 0.0;
      totalWaterCow = 0.0;
      totalPriceCow = 0.0;
      totalQtyBuffallo = 0;
      totalFatBuffallo = 0.0;
      totalSnfBuffallo = 0.0;
      totalWaterBuffallo = 0.0;
      totalPriceBuffallo = 0.0;

      totalQty = milkCollectionData.length.toDouble();
      for (var i = 0; i < milkCollectionData.length; i++) {
        //
        totalMilk += milkCollectionData[i].qty ?? 1.0;
        totalFat +=
            milkCollectionData[i].fat!.toDouble() * milkCollectionData[i].qty!;
        totalSnf +=
            milkCollectionData[i].snf!.toDouble() * milkCollectionData[i].qty!;
        totalWater += milkCollectionData[i].addedWater!.toDouble();
        totalPrice += milkCollectionData[i].ratePerLiter!.toDouble();
        totalAmt += milkCollectionData[i].totalAmt!.toDouble();
        // farmerPrintD.add(
        // "${milkCollectionData[i].farmerId.toString().substring(milkCollectionData[i].farmerId.toString().length - 3, milkCollectionData[i].farmerId.toString().length)} ${milkCollectionData[i].milkType} ${milkCollectionData[i].qty} ${milkCollectionData[i].fat} ${milkCollectionData[i].snf} ${milkCollectionData[i].ratePerLiter} ${milkCollectionData[i].totalAmt}");
        if (milkCollectionData[i].milkType == "CM") {
          totalQtyCow += 1;
          totalMilkCow += milkCollectionData[i].qty!;
          totalFatCow += milkCollectionData[i].fat!.toDouble() *
              milkCollectionData[i].qty!;
          totalSnfCow += milkCollectionData[i].snf!.toDouble() *
              milkCollectionData[i].qty!;
          totalWaterCow += milkCollectionData[i].addedWater!.toDouble();
          totalPriceCow += milkCollectionData[i].ratePerLiter!;
          totalAmtCow += milkCollectionData[i].totalAmt!;
        }
        if (milkCollectionData[i].milkType == "BM") {
          totalQtyBuffallo += 1;
          totalMilkBuffallo += milkCollectionData[i].qty!;
          totalFatBuffallo +=
              milkCollectionData[i].fat! * milkCollectionData[i].qty!;
          totalSnfBuffallo +=
              milkCollectionData[i].snf! * milkCollectionData[i].qty!;
          totalWaterBuffallo += milkCollectionData[i].addedWater!.toDouble();
          totalPriceBuffallo += milkCollectionData[i].ratePerLiter!.toDouble();
          totalAmtBuffallo += milkCollectionData[i].totalAmt!.toDouble();
        }
      }
    }
  }

  Future<void> fetchMilkCollection() async {
    milkCollectionData.assignAll(await milkCollectionDB.fetchAll());
  }

  String printShift() {
    late String farmDet = "";

    for (var i = 0; i < milkCollectionData.length; i++) {
      farmDet +=
          "${milkCollectionData[i].farmerId.toString().substring(milkCollectionData[i].farmerId.toString().length - 3, milkCollectionData[i].farmerId.toString().length)} ${milkCollectionData[i].milkType!.replaceAll("M", "")} ${milkCollectionData[i].qty!.toPrecision(2)} ${milkCollectionData[i].fat!.toPrecision(1)} ${milkCollectionData[i].snf!.toPrecision(1)} ${milkCollectionData[i].ratePerLiter!.toPrecision(2)} ${milkCollectionData[i].totalAmt!.toPrecision(2)}\n";
    }

    var prin = """
Summary
Centre ID    :   ${box.read(centerIdConst)}
Date         :   ${DateFormat("dd-MMM-yyyy").format(DateTime.parse(fromDate))}
Shift        :   ${radio == 1 ? "Am" : "Pm"}
                
    Cow Milk
Total qty..........${totalMilkCow.toPrecision(2)}
Avg Fat............${totalQtyCow > 0 ? (totalFatCow / totalMilkCow).toPrecision(2) : 0.0}
Avg Snf............${totalQtyCow > 0 ? (totalSnfCow / totalMilkCow).toPrecision(2) : 0.0}
Avg Rate...........${totalQtyCow > 0 ? (totalPriceCow / totalQtyCow.toDouble()).toPrecision(2) : 0.0}
Total Amt..........${totalQtyCow > 0 ? totalAmtCow.toPrecision(2) : 0.0}
        
    Buffallo Milk
Total qty..........${totalMilkBuffallo.toPrecision(2)}
Avg Fat............${totalQtyBuffallo > 0 ? (totalFatBuffallo / totalMilkBuffallo).toPrecision(2) : 0.0}
Avg Snf............${totalQtyBuffallo > 0 ? (totalSnfBuffallo / totalMilkBuffallo).toPrecision(2) : 0.0}
Avg Rate...........${totalQtyBuffallo > 0 ? (totalPriceBuffallo / totalQtyBuffallo.toDouble()).toPrecision(2) : 0.0}
Total Amt..........${totalQtyBuffallo > 0 ? totalAmtBuffallo.toPrecision(2) : 0.0}

    Total milk
Total qty..........${(totalMilkBuffallo + totalMilkCow).toPrecision(2)}
Avg Fat............${totalMilk > 0 ? (totalFat / totalMilk).toPrecision(2) : 0.0}
Avg Snf............${totalMilk > 0 ? (totalSnf / totalMilk).toPrecision(2) : 0.0}
Avg Rate...........${totalQty > 0 ? (totalPrice / totalQty.toDouble()).toPrecision(2) : 0.0}
Total Amt..........${totalQty > 0 ? totalAmt.toPrecision(2) : 0.0}
--------------------------------
Pro Milk Qty FAT SNF Rte Amt
--------------------------------
$farmDet
Cow Cans       ${cowCans.isNotEmpty ? cowCans : "0"}
Buf Cans       ${bufCans.isNotEmpty ? bufCans : "0"}
Total cans     ${int.parse("${bufCans.isNotEmpty ? bufCans : 0}") + int.parse("${cowCans.isNotEmpty ? cowCans : 0}")}
        
        
        
        """;

    return prin;
  }

  Future<void> checkShiftForCans() async {
    await cansDB.fetchCans(DateFormat("dd-MMM-yyyy").format(DateTime.now()),
        radio == 1 ? "Am" : "Pm");
  }

  Future<void> printShiftDetails() async {
    printDetails = true;
    await canReceivedPost();
  }

  void showDialogManualPin({
    Function()? onTap,
  }) =>
      Get.defaultDialog(
        barrierDismissible: false,
        backgroundColor: AppColors.white,
        title: "Total Cans",
        titleStyle: Theme.of(Get.context!).textTheme.displayMedium,
        content: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter Cow Can:",
                style: Theme.of(Get.context!).textTheme.displayMedium,
              ),
            ),
            TextFormWidget(
              prefix: const Icon(
                Icons.pin,
                size: 30,
              ),
              initialValue: cowCans,
              label: "Please enter Pin...",
              onChanged: (val) {
                cowCans = val;
              },
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter Buffallo Can:",
                style: Theme.of(Get.context!).textTheme.displayMedium,
              ),
            ),
            TextFormWidget(
              prefix: const Icon(
                Icons.pin,
                size: 30,
              ),
              initialValue: bufCans,
              label: "Please enter Pin...",
              onChanged: (val) {
                bufCans = val;
              },
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ],
        ),
        confirm: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: AppColors.darkBrown,
                    fontSize: AppDimens.font16,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onTap,
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: AppColors.darkBrown,
                    fontSize: AppDimens.font16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  String printSummaryDetails() {
    late String farmDet = "";

    for (var i = 0; i < milkCollectionData.length; i++) {
      farmDet +=
          "${milkCollectionData[i].farmerId.toString().substring(milkCollectionData[i].farmerId.toString().length - 3, milkCollectionData[i].farmerId.toString().length)} ${milkCollectionData[i].milkType} ${milkCollectionData[i].qty!.toPrecision(2)} ${milkCollectionData[i].fat!.toPrecision(1)} ${milkCollectionData[i].snf!.toPrecision(1)} ${milkCollectionData[i].ratePerLiter!.toPrecision(2)} ${milkCollectionData[i].totalAmt!.toPrecision(2)}\n";
    }

    var prin = """
Summary
Centre ID    :   ${box.read(centerIdConst)}
Date         :   ${DateFormat("dd-MMM-yyyy").format(DateTime.parse(fromDate))}
Shift        :   ${radio == 1 ? "Am" : "Pm"}
                
    Cow Milk
Total qty..........${totalMilkCow.toPrecision(2)}
Avg Fat............${totalQtyCow > 0 ? (totalFatCow / totalMilkCow).toPrecision(2) : 0.0}
Avg Snf............${totalQtyCow > 0 ? (totalSnfCow / totalMilkCow).toPrecision(2) : 0.0}
Avg Rate...........${totalQtyCow > 0 ? (totalPriceCow / totalQtyCow).toPrecision(2) : 0.0}
Total Amt..........${totalQtyCow > 0 ? totalAmtCow.toPrecision(2) : 0.0}
        
    Buffallo Milk
Total qty..........${totalMilkBuffallo.toPrecision(2)}
Avg Fat............${totalQtyBuffallo > 0 ? (totalFatBuffallo / totalMilkBuffallo).toPrecision(2) : 0.0}
Avg Snf............${totalQtyBuffallo > 0 ? (totalSnfBuffallo / totalMilkBuffallo).toPrecision(2) : 0.0}
Avg Rate...........${totalQtyBuffallo > 0 ? (totalPriceBuffallo / totalQtyBuffallo.toDouble()).toPrecision(2) : 0.0}
Total Amt..........${totalQtyBuffallo > 0 ? totalAmtBuffallo.toPrecision(2) : 0.0}

    Total milk
Total qty..........${(totalMilkBuffallo + totalMilkCow).toPrecision(2)}
Avg Fat............${totalMilk > 0 ? (totalFat / totalMilk).toPrecision(2) : 0.0}
Avg Snf............${totalMilk > 0 ? (totalSnf / totalMilk).toPrecision(2) : 0.0}
Avg Rate...........${totalQty > 0 ? (totalPrice / totalQty.toDouble()).toPrecision(2) : 0.0}
Total Amt..........${totalQty > 0 ? totalAmt.toPrecision(2) : 0.0}

Cow Cans       ${cowCans.isNotEmpty ? cowCans : '0'}
Buf Cans       ${bufCans.isNotEmpty ? bufCans : "0"}
Total cans     ${int.parse("${cowCans.isNotEmpty ? cowCans : 0}") + int.parse("${bufCans.isNotEmpty ? bufCans : 0}")}
        
        
        
        """;

    return prin;
  }

  Future<void> checkSmsFlag() async {
    // http://Payment.maklife.in:9019/api/getsmsflag
    var res = await http.get(
      Uri.parse(
          "$baseUrlConst/getcenter_mobile?centerid=${box.read(centerIdConst)}"),
    );
    if (res.statusCode == 200) {
      final ctx = centerMobileSmsModelFromMap(res.body);
      if (ctx.isNotEmpty) {
        sendMessage(ctx.first.mobile1.toString(), ctx.first.mobile2.toString(),
            ctx.first.mobile3.toString());
      }
    }
  }

  Future<void> sendMessage1(String mob1, String mob2, String mob3) async {
    List<String> recipents = [];
    if (mob1.isNotEmpty) {
      recipents.add(mob1);
    }
    if (mob2.isNotEmpty) {
      recipents.add(mob2);
    }
    if (mob3.isNotEmpty) {
      recipents.add(mob3);
    }

    for (var num in recipents) {
      try {
        var res = await http.post(Uri.parse(
            //
            "http://sms.autobysms.com/app/smsapi/index.php?key=36365EF4C86D67&campaign=0&routeid=9&type=text&contacts=$num&senderid=MAKLIF&msg=MAK LIFE%0D%0AColl. Ctr ID: ${box.read(centerIdConst)}%0D%0AFarmer Id: %0D%0ADate: ${DateFormat("dd-MMM-yyyy").format(DateTime.now())}_${radio == 1 ? "Am" : "Pm"}%0D%0AMilk Type: %0D%0AQty: ${(totalMilkCow + totalMilkBuffallo).toPrecision(2)}%0D%0AFAT: ${((totalQtyCow > 0 ? (totalFatCow / totalMilkCow).toPrecision(2) : 0.0) + (totalQtyBuffallo > 0 ? (totalFatBuffallo / totalMilkBuffallo).toPrecision(2) : 0.0)).toPrecision(2)}%0D%0ASNF: ${((totalQtyCow > 0 ? (totalSnfCow / totalMilkCow).toPrecision(2) : 0.0) + (totalQtyBuffallo > 0 ? (totalSnfBuffallo / totalMilkBuffallo).toPrecision(2) : 0.0)).toPrecision(2)}%0D%0AWATER %: %0D%0ARATE: ${((totalQtyCow > 0 ? (totalPriceCow / totalQtyCow).toPrecision(2) : 0.0) + (totalQtyBuffallo > 0 ? (totalPriceBuffallo / totalQtyBuffallo).toPrecision(2) : 0.0)).toPrecision(2)}%0D%0ATot Amt.: Rs.${((totalQtyCow > 0 ? totalAmtCow.toPrecision(2) : 0.0) + (totalQtyBuffallo > 0 ? totalAmtBuffallo.toPrecision(2) : 0.0)).toPrecision(2)}%0D%0A&template_id=1207165769139334975"));
        if (res.statusCode == 200) {
          Utils.showSnackbar(jsonDecode(res.body)["message"]);
        } else {}
      } catch (e) {}
    }
  }

  Future<void> sendMessage(String mob1, String mob2, String mob3) async {
    await Permission.sms.request();
    try {
      String message = """
MAK LIFE
Centre ID : ${box.read(centerIdConst)}
(${box.read(centerName)})
Date         : ${DateFormat("dd-MMM-yyyy").format(DateTime.parse(fromDate))}
Shift         : ${radio == 1 ? "Am" : "Pm"}
- - - - - - - - - - - - - - - - - - - -
CM
Total qty     : ${totalMilkCow.toPrecision(2)}
Avg Fat       : ${totalQtyCow > 0 ? (totalFatCow / totalMilkCow).toPrecision(2) : 0.0}
Avg Snf       : ${totalQtyCow > 0 ? (totalSnfCow / totalMilkCow).toPrecision(2) : 0.0}
Avg Rate     : ${totalQtyCow > 0 ? (totalPriceCow / totalQtyCow).toPrecision(2) : 0.0}
Total Amt    : ${totalQtyCow > 0 ? totalAmtCow.toPrecision(2) : 0.0}
- - - - - - - - - - - - - - - - - - - -
BM
Total qty      : ${totalMilkBuffallo.toPrecision(2)}
Avg Fat        : ${totalQtyBuffallo > 0 ? (totalFatBuffallo / totalMilkBuffallo).toPrecision(2) : 0.0}
Avg Snf        : ${totalQtyBuffallo > 0 ? (totalSnfBuffallo / totalMilkBuffallo).toPrecision(2) : 0.0}
Avg Rate      : ${totalQtyBuffallo > 0 ? (totalPriceBuffallo / totalQtyBuffallo).toPrecision(2) : 0.0}
Total Amt     : ${totalQtyBuffallo > 0 ? totalAmtBuffallo.toPrecision(2) : 0.0}
- - - - - - - - - - - - - - - - - - - -
Total Ltrs      : ${(totalMilkCow + totalMilkBuffallo).toPrecision(2)}
Total Amt      : ${(totalAmtCow + totalAmtBuffallo).toPrecision(2)}
""";
      List<String> recipents = [];
      if (mob1.isNotEmpty) {
        recipents.add(mob1);
      }
      if (mob2.isNotEmpty) {
        recipents.add(mob2);
      }
      if (mob3.isNotEmpty) {
        recipents.add(mob3);
      }

      await sendSMS(message: message, recipients: recipents, sendDirect: true);
    } catch (e) {}
  }

  Future<void> canReceivedPost() async {
    try {
      var res = await http.post(Uri.parse(
          //
          "$baseUrlConst/$canReceived"), body: {
        "CenterID": box.read(centerIdConst),
        "Shift": radio == 1 ? "Am" : "Pm",
        "Bm": bufCans.isNotEmpty ? bufCans : "0",
        "Cm": cowCans.isNotEmpty ? cowCans : "0",
        "Remark": "",
        "Dated": DateFormat("dd-MMM-yyyy").format(DateTime.parse(fromDate))
      });
      if (res.statusCode == 200) {
      } else {}
    } catch (e) {}
  }

  String printPaymentsFarmerList() {
    late String farmDet = "";
    final data = !searchActive ? farmerPaymentList : searchfarmerPaymentList;

    for (var i = 0; i < data.length; i++) {
      farmDet +=
          "${data[i].idNo}      ${data[i].farmerName}\n${double.parse(data[i].totalQty.toString()).toPrecision(2)} ${double.parse(data[i].totalAmount.toString()).toPrecision(2)} ${data[i].paymentId} ${data[i].payGenerationDate.toString().substring(5)}\n";
    }
    var prin = """
Center Id   : ${box.read(centerIdConst)}
Center Name : ${box.read(centerName)} 
From date   : $fromDateP
To Date     : $toDateP
Farmer Id  Farmer Name
Qty   Amt   PI'd   Gdate**********01-10**********
$farmDet


""";
    return prin;
  }

  void printFarmerPaymentDetails({
    required List<GetFarmerPaymentDetailsModel> data,
    required String farmerName,
    required String farmerId,
  }) {
    late String farmDet = "";
    late double totalAmt = 0.0;
    late double totalQty = 0.0;
    for (var i = 0; i < data.length; i++) {
      totalAmt += double.parse(data[i].totalAmount.toString()).toPrecision(2);
      totalQty += double.parse(data[i].quantity.toString()).toPrecision(2);
      farmDet +=
          "${data[i].collectionDate.toString().substring(0, 2)} ${data[i].shift} ${data[i].milkType.toString().substring(0, 1)} ${double.parse(data[i].fat.toString()).toPrecision(1)} ${double.parse(data[i].snf.toString()).toPrecision(1)} ${double.parse(data[i].quantity.toString()).toPrecision(2)} ${double.parse(data[i].rate.toString()).toPrecision(2)} ${double.parse(data[i].totalAmount.toString()).toPrecision(2)}\n";
    }

    printDetailsPaymentFarmer = """
******* Payment Details *******
Date :${DateFormat("dd-MMM-yyyy").format(DateTime.now())} Time :${DateFormat("hh:mm:ss").format(DateTime.now())}
C Id : ${box.read(centerIdConst)}
C Name : ${box.read(centerName)} 
F Id : $farmerId
F Name : $farmerName
From:$fromDateP To:$toDateP 
Dt Sf M Fat Snf Qty Price Amt
$farmDet
Total Quantity : ${totalQty.toPrecision(2)}
Total Amount   : ${totalAmt.toPrecision(2)}



""";
    printPaymentDetails = true;
    // return prin;
  }
}
