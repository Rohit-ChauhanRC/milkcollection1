import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_android/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/cans_db.dart';
import 'package:milkcollection/app/data/local_database/milk_collection_db.dart';
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
// import 'package:sms_advanced/sms_advanced.dart';
// import 'package:telephony_sms/telephony_sms.dart';

class HomeController extends GetxController {
  //
  final box = GetStorage();

  final RateChartDB rateChartDB = RateChartDB();
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

  final RxString _density = "".obs;
  String get density => _density.value;
  set density(String i) => _density.value = i;

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

  final RxInt _totalQty = 0.obs;
  int get totalQty => _totalQty.value;
  set totalQty(int i) => _totalQty.value = i;

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

  final RxString _cowCans = "0".obs;
  String get cowCans => _cowCans.value;
  set cowCans(String b) => _cowCans.value = b;

  final RxString _bufCans = "0".obs;
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

  @override
  void onInit() async {
    super.onInit();
    await checkIp();

    if (DateTime.now().hour < 12) {
      radio = 1;
    } else {
      radio = 2;
    }
    await fetchMilkCollectionDateWise();

    await getRateChart("C").then((value) async {
      await getRateChart("B").then((value) async {
        pd.close();
      });
    });
    // await callApi();

    // await
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getShiftDetails() async {
    cansModel.assignAll(await cansDB.fetchCans(
        DateFormat("dd-MMM-yyyy").format(DateTime.now()),
        radio == 1 ? "Am" : "Pm"));
    print(
        "${await cansDB.fetchCans(DateFormat("dd-MMM-yyyy").format(DateTime.now()), radio == 1 ? "Am" : "Pm")}");
    if (cansModel.isNotEmpty) {
      cowCans = cansModel.first.cowCans != null
          ? cansModel.first.cowCans.toString()
          : "0";
      bufCans = cansModel.first.bufCans != null
          ? cansModel.first.bufCans.toString()
          : "0";
    }
    // printSummary = true;
  }

  Future entryPoint(SendPort sendPort) async {
    var response = await checkIp();
    // sendPort.send(response);
  }

  Future<void> callApi() async {
    var recievePort = ReceivePort();
    await Isolate.spawn(entryPoint, recievePort.sendPort);
    final completer = Completer<Iterable<MilkCollectionModel>>();
    recievePort.listen((data) {
      print(data);
      completer.complete(data);
      recievePort.close();
    });
    // return completer.future;
  }

  Future<void> getRateChart(
    String milkType,
  ) async {
    try {
      var res = await http.get(
        Uri.parse(
            "http://Payment.maklife.in:9019/api/GetRateChart?CollectionCenterId=${box.read("centerId")}&MilkType=$milkType"),
      );

      if (res.statusCode == 200) {
        rateChartData.assignAll([]);

        rateChartData.assignAll(ratechartModelFromMap(res.body));
        if (rateChartData.isNotEmpty) {
          pd.show(
              max: rateChartData.length,
              msgFontSize: 10,
              valueFontSize: 10,
              msgTextAlign: TextAlign.left,
              msg:
                  'Downloading ${milkType == "C" ? "CM" : "BM"} Rate Chart...');
          if (box.read(ratecounterConst) == null) {
            for (var e in rateChartData) {
              await rateChartDB.create(
                collectionCenterId: box.read("centerId"),
                counters: e.counters,
                fat: e.fat,
                insertedDate: e.insertedDate.toIso8601String(),
                milkType: e.milkType,
                price: e.price.toString(),
                snf: e.snf,
              );
            }
            if (milkType == "B") {
              box.write("ratecounter", rateChartData.first.counters);
              pd.close();
            }
          }
          if (box.read(ratecounterConst) != null &&
              (int.tryParse(box.read(ratecounterConst))! <
                  int.tryParse(rateChartData.first.counters)!)) {
            for (var e in rateChartData) {
              pd.show(
                  msgFontSize: 10,
                  valueFontSize: 10,
                  max: rateChartData.length,
                  msgTextAlign: TextAlign.left,
                  msg:
                      'Downloading ${milkType == "C" ? "CM" : "BM"} Rate Chart...');
              await rateChartDB.create(
                collectionCenterId: box.read("centerId"),
                counters: e.counters,
                fat: e.fat,
                insertedDate: e.insertedDate.toIso8601String(),
                milkType: e.milkType,
                price: e.price.toString(),
                snf: e.snf,
              );
            }
            if (milkType == "B") {
              box.write("ratecounter", rateChartData.first.counters);
              pd.close();
            }
          }
        }
        pd.close();
        rateChartData.assignAll([]);
      } else {}
    } catch (e) {}
  }

  Future<void> checkIp() async {
    // var ip;
    for (var interface in await NetworkInterface.list()) {
      // print(interface);
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 &&
            addr.address.startsWith('192') &&
            Platform.isAndroid &&
            (interface.name.startsWith("swlan") ||
                interface.name.startsWith("ap"))) {
          ip = addr.address.split(".").getRange(0, 3).join(".");
          for (var i = 0; i < 255; i++) {
            anaylzerConnection("$ip.$i");

            weighingConnection("$ip.$i");

            printerConnection("$ip.$i");
          }
        } else if (addr.type == InternetAddressType.IPv4 &&
            addr.address.startsWith('172') &&
            Platform.isIOS) {
          addr.address.split(".").getRange(0, 3).join(".");
          for (var i = 0; i < 255; i++) {
            anaylzerConnection("$ip.$i");

            weighingConnection("$ip.$i");

            printerConnection("$ip.$i");
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
    } catch (e) {
      print(e);
    }
  }

  Future<void> anaylzerConnection(String ip) async {
    try {
      final server = await ServerSocket.bind(ip, 8889);
      server.listen((event) {
        analyzerSocketConnection(event);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> printerConnection(String ip) async {
    // final ip = InternetAddress.anyIPv4;
    try {
      final server = await ServerSocket.bind(ip, 8883);
      server.listen((event) {
        // socket = event;

        printerSocketConnection(event);
      });
    } catch (e) {
      print(e);
    }
  }

  void analyzerSocketConnection(Socket client) {
    client.listen(
      (Uint8List data) {
        final message = String.fromCharCodes(data);

        print(" annalyzer $message");

        // if(message.split(" "))

        if (message.split(" ")[1].split("@").length < 4) {
          print("tata: $message");
        } else {
          fat =
              "${message.split(" ")[1].split("@")[1]}.${message.split(" ")[1].split("@")[2]}";
          snf =
              "${message.split(" ")[1].split("@")[3]}.${message.split(" ")[1].split("@")[4]}";

          density =
              "${message.split(" ")[1].split("@")[5]}.${message.split(" ")[1].split("@")[6]}";
          water =
              "${message.split(" ")[1].split("@")[7]}.${message.split(" ")[1].split("@")[8]}";
        }

        update();
      },
      onError: (error) {
        print("error: $error");
        client.destroy();
      },
      onDone: () {
        client.destroy();
      },
    );
  }

  void printerSocketConnection(Socket client) {
    client.listen(
      (Uint8List data) {
        final message = String.fromCharCodes(data);

        print(" printer $message");
        print(" printer ${client.remoteAddress}: ${client.port}");
        // GET Hex@2@7@4@2@8@6@1@6@@
        // client.write("pulkit");

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
      onError: (error) {
        print("error: $error");
        client.destroy();
      },
      onDone: () {
        client.destroy();
      },
    );
  }

  void weighingSocketConnection(Socket client) {
    client.listen(
      (Uint8List data) {
        final message = String.fromCharCodes(data);

        quantity = message.replaceAll("N", "").toString().replaceAll("n", "");
        // collectmilkController.quantity = message.replaceAll("N", "");
        print(message);
        print(quantity);
      },
      onError: (error) {
        print("error: $error");
        client.destroy();
      },
      onDone: () {
        client.destroy();
      },
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
    // homeController.socket!.write("collectionPrint");
  }

  // fetchByDate
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
    print(milkCollectionData);
    if (milkCollectionData.isNotEmpty) {
      // totalMilk = 0.0;
      totalQty = milkCollectionData.length;
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
          "${milkCollectionData[i].farmerId.toString().substring(milkCollectionData[i].farmerId.toString().length - 3, milkCollectionData[i].farmerId.toString().length)} ${milkCollectionData[i].milkType!.replaceAll("M", "")} ${milkCollectionData[i].qty} ${milkCollectionData[i].fat} ${milkCollectionData[i].snf} ${milkCollectionData[i].ratePerLiter} ${milkCollectionData[i].totalAmt!.toPrecision(1)}\n";
    }

    var prin = """
Summary
Centre ID    :   ${box.read(centerIdConst)}
Date         :   ${DateFormat("dd-MMM-yyyy").format(DateTime.parse(fromDate))}
Shift        :   ${radio == 1 ? "Am" : "Pm"}
                
    Cow Milk
Total qty..........$totalQtyCow
Avg Fat............${(totalFatCow / totalMilkCow).toPrecision(2)}
Avg Snf............${(totalSnfCow / totalMilkCow).toPrecision(2)}
Avg Rate...........${(totalPriceCow / totalQtyCow.toDouble()).toPrecision(2)}
Total Amt..........${totalAmtCow.toPrecision(2)}
        
    Buffallo Milk
Total qty..........$totalQtyBuffallo
Avg Fat............${(totalFatBuffallo / totalMilkBuffallo).toPrecision(2)}
Avg Snf............${(totalSnfBuffallo / totalMilkBuffallo).toPrecision(2)}
Avg Rate...........${(totalPriceBuffallo / totalQtyBuffallo.toDouble()).toPrecision(2)}
Total Amt..........${totalAmtBuffallo.toPrecision(2)}

    Total milk
Total qty..........$totalQty
Avg Fat............${(totalFat / totalMilk).toPrecision(2)}
Avg Snf............${(totalSnf / totalMilk).toPrecision(2)}
Avg Rate...........${(totalPrice / totalQty.toDouble()).toPrecision(2)}
Total Amt..........${totalAmt.toPrecision(2)}
--------------------------------
Pro Milk Qty FAT SNF Rate Amnt
--------------------------------
$farmDet
Cow Cans       $cowCans
Buf Cans       $bufCans
Total cans     ${int.parse(bufCans) + int.parse(cowCans)}
        """;

    return prin;
    // return commonPrint() + promMilk() + farmDet.toString() + cansCowBuf();
  }

  Future<void> checkShiftForCans() async {
    await cansDB.fetchCans(DateFormat("dd-MMM-yyyy").format(DateTime.now()),
        radio == 1 ? "Am" : "Pm");
  }

  Future<void> printShiftDetails() async {
    // farmerPrintD
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
        // title: success ? Strings.success : title,
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
                // print(initialValue);
              },
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 10,
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
                // print(initialValue);
              },
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 10,
            ),
          ],
        ),
        // cancel: ,
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
          "${milkCollectionData[i].farmerId.toString().substring(milkCollectionData[i].farmerId.toString().length - 3, milkCollectionData[i].farmerId.toString().length)} ${milkCollectionData[i].milkType} ${milkCollectionData[i].qty} ${milkCollectionData[i].fat} ${milkCollectionData[i].snf} ${milkCollectionData[i].ratePerLiter} ${milkCollectionData[i].totalAmt}\n";
    }

    var prin = """
Summary
Centre ID    :   ${box.read(centerIdConst)}
Date         :   ${DateFormat("dd-MMM-yyyy").format(DateTime.parse(fromDate))}
Shift        :   ${radio == 1 ? "Am" : "Pm"}
                
    Cow Milk
Total qty..........$totalQtyCow
Avg Fat............${(totalFatCow / totalMilkCow).toPrecision(2)}
Avg Snf............${(totalSnfCow / totalMilkCow).toPrecision(2)}
Avg Rate...........${(totalPriceCow / totalQtyCow).toPrecision(2)}
Total Amt..........${totalAmtCow.toPrecision(2)}
        
    Buffallo Milk
Total qty..........$totalQtyBuffallo
Avg Fat............${(totalFatBuffallo / totalMilkBuffallo).toPrecision(2)}
Avg Snf............${(totalSnfBuffallo / totalMilkBuffallo).toPrecision(2)}
Avg Rate...........${(totalPriceBuffallo / totalQtyBuffallo).toPrecision(2)}
Total Amt..........${totalAmtBuffallo.toPrecision(2)}

    Total milk
Total qty..........$totalQty
Avg Fat............${(totalFat / totalMilk).toPrecision(2)}
Avg Snf............${(totalSnf / totalMilk).toPrecision(2)}
Avg Rate...........${(totalPrice / totalQty).toPrecision(2)}
Total Amt..........${totalAmt.toPrecision(2)}

Cow Cans       $cowCans
Buf Cans       $bufCans
Total cans     ${int.parse(bufCans) + int.parse(cowCans)}
        """;

    return prin;
    // return commonPrint() + promMilk() + farmDet.toString() + cansCowBuf();
  }

  Future<void> checkSmsFlag() async {
    // http://Payment.maklife.in:9019/api/getsmsflag
    var res = await http.get(
      Uri.parse(
          "$baseUrlConst/getcenter_mobile?centerid=${box.read(centerIdConst)}"),
    );
    if (res.statusCode == 200) {
      // centerMobileSmsModel
      //     .assignAll(centerMobileSmsModelFromMap(jsonDecode(res.body)));
      final ctx = centerMobileSmsModelFromMap(res.body);
      if (ctx.isNotEmpty) {
        sendMessage(ctx.first.mobile1.toString(), ctx.first.mobile2.toString(),
            ctx.first.mobile3.toString());
      }
    }
  }

  Future<void> sendMessage(String mob1, String mob2, String mob3) async {
    await Permission.sms.request();
    try {
      // final _telephonySMS = TelephonySMS();

      // await _telephonySMS.requestPermission();
      // await _telephonySMS.sendSMS(phone: mob, message: "MESSAGE");
      String message = """
MAK LIFE
Centre ID : ${box.read(centerIdConst)}
(${box.read(centerName)})
Date        : ${DateFormat("dd-MMM-yyyy").format(DateTime.parse(fromDate))}
Shift       : ${radio == 1 ? "Am" : "Pm"}
CM
Total qty   : $totalQtyCow
Avg Fat     : ${(totalFatCow / totalMilkCow).toPrecision(2)}
Avg Snf     : ${(totalSnfCow / totalMilkCow).toPrecision(2)}
Avg Rate    : ${(totalPriceCow / totalQtyCow).toPrecision(2)}
Total Amt   : ${totalAmtCow.toPrecision(2)}
BM
Total qty   : $totalQtyBuffallo
Avg Fat     : ${(totalFatBuffallo / totalMilkBuffallo).toPrecision(2)}
Avg Snf     : ${(totalSnfBuffallo / totalMilkBuffallo).toPrecision(2)}
Avg Rate    : ${(totalPriceBuffallo / totalQtyBuffallo).toPrecision(2)}
Total Amt   : ${totalAmtBuffallo.toPrecision(2)}
Total Ltrs  : $totalQty
Total Amt   : ${totalAmt.toPrecision(2)}
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
      // print(_result);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> canReceivedPost() async {
    try {
      var res = await http.post(Uri.parse(
          //
          "$baseUrlConst/$canReceived"), body: {
        "CenterID": box.read(centerIdConst),
        "Shift": radio == 1 ? "Am" : "Pm",
        "Bm": bufCans,
        "Cm": cowCans,
        "Remark": "",
        "Dated": DateFormat("dd-MMM-yyyy").format(DateTime.parse(fromDate))
      });
      if (res.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  String printPaymentsFarmerList() {
    late String farmDet = "";
    final data = !searchActive ? farmerPaymentList : searchfarmerPaymentList;

    for (var i = 0; i < data.length; i++) {
      farmDet +=
          "${data[i].idNo}      ${data[i].farmerName}\n${data[i].totalQty} ${data[i].totalAmount} ${data[i].paymentId} ${data[i].payGenerationDate.toString().substring(5)}\n";
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
      totalAmt += double.parse(data[i].totalAmount.toString());
      totalQty += double.parse(data[i].quantity.toString());
      farmDet +=
          "${data[i].collectionDate.toString().substring(0, 2)} ${data[i].shift} ${data[i].milkType.toString().substring(0, 1)} ${double.parse(data[i].fat.toString()).toPrecision(1)} ${double.parse(data[i].snf.toString()).toPrecision(1)} ${data[i].quantity.toString()} ${data[i].rate} ${data[i].totalAmount}\n";
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
Total Quantity : $totalQty
Total Amount   : $totalAmt



""";
    printPaymentDetails = true;
    // return prin;
  }
}
