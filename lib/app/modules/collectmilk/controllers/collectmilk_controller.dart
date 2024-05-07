import 'dart:io';
import 'dart:io' as io;
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/milk_collection_db.dart';
import 'package:milkcollection/app/data/local_database/ratechart_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';
import 'package:milkcollection/app/data/models/ratechart_model.dart';
import 'package:milkcollection/app/modules/home/controllers/home_controller.dart';
import 'dart:convert';
import 'package:path/path.dart';

import 'package:milkcollection/app/data/models/milk_collection_model.dart';
import 'package:milkcollection/app/data/models/pin_manual_model.dart';
import 'package:milkcollection/app/modules/pinverify/controllers/pinverify_controller.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/theme/app_dimens.dart';
import 'package:milkcollection/app/utils/utils.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:share_plus/share_plus.dart';

class CollectmilkController extends GetxController {
  //

  final box = GetStorage();

  final MilkCollectionDB milkCollectionDB = MilkCollectionDB();

  final RateChartDB rateChartDB = RateChartDB();

  final HomeController homeController = Get.find<HomeController>();

  final PinverifyController pinverifyController = Get.find();

  late ServerSocket weightServerSocket;
  late ServerSocket printerServerSocket;
  late ServerSocket serverSocket;
  late Socket socket;
  late Socket weightsocket;
  late Socket printersocket;

  final RxInt _radio = 0.obs;
  int get radio => _radio.value;
  set radio(int i) => _radio.value = i;

  final RxString _farmerId = ''.obs;
  String get farmerId => _farmerId.value;
  set farmerId(String mob) => _farmerId.value = mob;

  final RxList<MilkCollectionModel> _restoreData =
      RxList<MilkCollectionModel>();
  List<MilkCollectionModel> get restoreData => _restoreData;
  set restoreData(List<MilkCollectionModel> lst) => _restoreData.assignAll(lst);

  final RxList<PinnmanualModel> _pinManual = RxList<PinnmanualModel>();
  List<PinnmanualModel> get pinManual => _pinManual;
  set pinManual(List<PinnmanualModel> lst) => _pinManual.assignAll(lst);

  final Rx<FarmerListModel> _farmerData = Rx(FarmerListModel());
  FarmerListModel get farmerData => _farmerData.value;
  set farmerData(FarmerListModel lst) => _farmerData.value = lst;

  final RxBool _check = true.obs;
  bool get check => _check.value;
  set check(bool v) => _check.value = v;

  final RxString _pin = ''.obs;
  String get pin => _pin.value;
  set pin(String mob) => _pin.value = mob;

  final RxString _shift = "AM".obs;
  String get shift => _shift.value;
  set shift(String i) => _shift.value = i;

  final RxList<MilkCollectionModel> _exportData = RxList<MilkCollectionModel>();
  List<MilkCollectionModel> get exportData => _exportData;
  set exportData(List<MilkCollectionModel> lst) => _exportData.assignAll(lst);

  // final RxString _fat = "".obs;
  // String get fat => _fat.value;
  // set fat(String i) => _fat.value = i;
  TextEditingController fat = TextEditingController();
  TextEditingController snf = TextEditingController();
  TextEditingController density = TextEditingController();
  TextEditingController water = TextEditingController();
  TextEditingController quantity = TextEditingController();

  // final RxString _snf = "".obs;
  // String get snf => _snf.value;
  // set snf(String i) => _snf.value = i;

  // final RxString _density = "".obs;
  // String get density => _density.value;
  // set density(String i) => _density.value = i;

  // final RxString _water = "".obs;
  // String get water => _water.value;
  // set water(String i) => _water.value = i;

  // final RxString _quantity = "".obs;
  // String get quantity => _quantity.value;
  // set quantity(String i) => _quantity.value = i;

  final RxList<RatechartModel> _rateChartData = RxList<RatechartModel>();
  List<RatechartModel> get rateChartData => _rateChartData;
  set rateChartData(List<RatechartModel> lst) => _rateChartData.assignAll(lst);

  final RxString _price = "".obs;
  String get price => _price.value;
  set price(String i) => _price.value = i;

  final RxString _totalAmount = "".obs;
  String get totalAmount => _totalAmount.value;
  set totalAmount(String i) => _totalAmount.value = i;

  final RxInt _shiftTime = 1.obs;
  int get shiftTime => _shiftTime.value;
  set shiftTime(int i) => _shiftTime.value = i;

  // late Rx<Socket> printer;

  final RxBool _printD = false.obs;
  bool get printD => _printD.value;
  set printD(bool v) => _printD.value = v;

  @override
  void onInit() async {
    super.onInit();

    // await checkIp();

    if (DateTime.now().hour < 12) {
      shiftTime = 1;
    } else {
      shiftTime = 2;
    }
    await Permission.storage.request();

    // WidgetsBinding.instance.initInstances();
    await getCollectionThirtyDaysData();
    await getRateChart();
  }

  @override
  void onReady() async {
    super.onReady();
    await getRateChart();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getRateChart() async {
    rateChartData.assignAll(await rateChartDB.fetchAll());

    print("await rateChartDB.fetchAll(): ${await rateChartDB.fetchAll()}");
  }

  String getPriceData(bool v) {
    for (var i = 0; i < rateChartData.length; i++) {
      if (v) {
        if (double.tryParse(fat.text) ==
                double.tryParse(rateChartData[i].fat) &&
            double.tryParse(snf.text) ==
                double.tryParse(rateChartData[i].snf)) {
          price = (rateChartData[i].price).toString();
          print(price);
        }
      } else {
        // homeController.
        if (double.tryParse(homeController.fat) ==
                double.tryParse(rateChartData[i].fat) &&
            double.tryParse(homeController.snf) ==
                double.tryParse(rateChartData[i].snf)) {
          price = (rateChartData[i].price).toString();
          print(price);
        }
      }
    }

    return price;
  }

  String getTotalAmount(bool v) {
    totalAmount = "";

    // print("rateChartData: $rateChartData");

    for (var i = 0; i < rateChartData.length; i++) {
      if (v) {
        if (double.tryParse(fat.text) ==
                double.tryParse(rateChartData[i].fat) &&
            double.tryParse(snf.text) ==
                double.tryParse(rateChartData[i].snf)) {
          totalAmount = ((rateChartData[i].price *
                      (double.tryParse(quantity.text) ?? 1.0))
                  .toPrecision(2))
              .toString();
          print(totalAmount);
        }
        update();
      } else {
        if (double.tryParse(homeController.fat) ==
                double.tryParse(rateChartData[i].fat) &&
            double.tryParse(homeController.snf) ==
                double.tryParse(rateChartData[i].snf)) {
          totalAmount = ((rateChartData[i].price *
                      double.tryParse(homeController.quantity)!)
                  .toPrecision(2))
              .toString();
          print(totalAmount);
        }
      }
    }

    return totalAmount;
  }

  dateFormat(DateTime date) {
    return DateFormat("dd-MMM-yyyy").format(date);
  }

  Future<void> getRestoreData() async {
    try {
      var res = await http.get(
          Uri.parse(
            "$baseUrlConst/$restoreDataConst?CollectionCenterId=${box.read("centerId")}&FromDate=${dateFormat(DateTime.now().subtract(const Duration(days: 90)))}&ToDate=${dateFormat(DateTime.now())}",
          ),
          headers: {"Content-Type": "application/json"});

      if (res.statusCode == 200) {
        restoreData.assignAll([]);
        // print("res: ${res}");
        // print("res: ${jsonDecode(res.body.toString())}");
        restoreData.assignAll(milkCollectionModelFromMap(res.body));
        if (restoreData.isNotEmpty) {
          print(restoreData.length.toString());
          for (var e in restoreData) {
            milkCollectionDB.create(
              Added_Water: e.addedWater,
              Analyze_Mode: e.analyzeMode,
              CollectionCenterId: e.collectionCenterId.toString(),
              CollectionCenterName: e.collectionCenterName,
              Collection_Date: e.collectionDate,
              Collection_Mode: e.collectionMode,
              FAT: e.fat,
              FarmerId: e.farmerId,
              Farmer_Name: e.farmerName,
              Inserted_Time: e.insertedTime,
              Milk_Status: e.milkStatus,
              Milk_Type: e.milkType,
              Qty: e.qty,
              Rate_Chart_Name: e.rateChartName,
              Rate_Per_Liter: e.ratePerLiter,
              SNF: e.snf,
              Scale_Mode: e.scaleMode,
              Shift: e.shift,
              Total_Amt: e.totalAmt,
              FUploaded: 1,
            );
          }
        }
        // restoreData.assignAll([]);
      } else {
        print(jsonDecode(res.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getCollectionThirtyDaysData() async {
    try {
      var res = await http.get(
          Uri.parse(
            "$baseUrlConst/$restoreDataConst?CollectionCenterId=${box.read("centerId")}&FromDate=${dateFormat(DateTime.now().subtract(const Duration(days: 30)))}&ToDate=${dateFormat(DateTime.now())}",
          ),
          headers: {"Content-Type": "application/json"});

      if (res.statusCode == 200) {
        restoreData.assignAll([]);
        // print("res: ${res}");
        // print("res: ${jsonDecode(res.body.toString())}");
        restoreData.assignAll(milkCollectionModelFromMap(res.body));
        if (restoreData.isNotEmpty) {
          print(restoreData.length.toString());
          await milkCollectionDB.deleteTable().then((value) async {
            for (var e in restoreData) {
              await milkCollectionDB.create(
                Added_Water: e.addedWater,
                Analyze_Mode: e.analyzeMode,
                CollectionCenterId: e.collectionCenterId.toString(),
                CollectionCenterName: e.collectionCenterName,
                Collection_Date: e.collectionDate,
                Collection_Mode: e.collectionMode,
                FAT: e.fat,
                FarmerId: e.farmerId,
                Farmer_Name: e.farmerName,
                Inserted_Time: e.insertedTime,
                Milk_Status: e.milkStatus,
                Milk_Type: e.milkType,
                Qty: e.qty,
                Rate_Chart_Name: e.rateChartName,
                Rate_Per_Liter: e.ratePerLiter,
                SNF: e.snf,
                Scale_Mode: e.scaleMode,
                Shift: e.shift,
                Total_Amt: e.totalAmt,
                FUploaded: 1,
              );
            }
          });

          box.write(calculationsId, restoreData.last.calculationsId);
        }
        // restoreData.assignAll([]);
      } else {
        print(jsonDecode(res.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  getFarmerId() async {
    var farmerfinalId = box.read(centerIdConst);
    if (farmerId.length == 1) {
      farmerfinalId = "${farmerfinalId}000$farmerId";
    } else if (farmerId.length == 2) {
      farmerfinalId = "${farmerfinalId}00$farmerId";
    } else if (farmerId.length == 3) {
      farmerfinalId = "${farmerfinalId}0$farmerId";
    } else if (farmerId.length == 4) {
      farmerfinalId = farmerfinalId.toString() + farmerId;
      // }
    }
    farmerData =
        await pinverifyController.farmerDB.fetchById(farmerfinalId.toString());
  }

  String getFarmerIdFinal() {
    var farmerfinalId = box.read(centerIdConst);
    if (farmerId.length == 1) {
      farmerfinalId = "${farmerfinalId}000$farmerId";
    } else if (farmerId.length == 2) {
      farmerfinalId = "${farmerfinalId}00$farmerId";
    } else if (farmerId.length == 3) {
      farmerfinalId = "${farmerfinalId}0$farmerId";
    } else if (farmerId.length == 4) {
      farmerfinalId = farmerfinalId.toString() + farmerId;
      // }
    }
    return farmerfinalId;
    // farmerData =
    //     await pinverifyController.farmerDB.fetchById(farmerfinalId.toString());
  }

  Future<void> getVerifyPin() async {
    try {
      var res = await http.get(
          Uri.parse(
            "$baseUrlConst/$pinForManualConst?CollectionCenterId=${box.read("centerId")}&Idate=${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
          ),
          headers: {"Content-Type": "application/json"});

      if (res.statusCode == 200) {
        print(res.body);
        pinManual.assignAll([]);
        // print("res: ${res}");
        // print("res: ${jsonDecode(res.body.toString())}");
        pinManual.assignAll(pinnmanualModelFromMap(res.body));
        if (pinManual.isNotEmpty) {
          print("pin :${pin}");
          if (pinManual[0].pin == int.tryParse(pin)) {
            print(pin);
            check = false;
            // Get.back();
            Utils.closeDialog();
            showDialogSelectShift();
          } else {
            // print("object");
            Utils.showSnackbar("Pin Expired Of Your Collection Centre!");
          }
        }
        // restoreData.assignAll([]);
      } else {
        print(jsonDecode(res.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void showDialogManualPin({
    Function()? onTap,
    String? initialValue,
  }) =>
      Get.defaultDialog(
        barrierDismissible: false,
        backgroundColor: AppColors.white,
        title: "Validate Pin",
        titleStyle: Theme.of(Get.context!).textTheme.displayMedium,
        // title: success ? Strings.success : title,
        content: TextFormWidget(
          prefix: const Icon(
            Icons.pin,
            size: 30,
          ),
          initialValue: pin,
          label: "Please enter Pin...",
          onChanged: (val) {
            pin = val;
            print(initialValue);
          },
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
          ),
          maxLength: 10,
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

  void showDialogSelectShift() => Get.defaultDialog(
        barrierDismissible: false,
        backgroundColor: AppColors.white,
        title: "Please Select Shift",
        titleStyle: Theme.of(Get.context!).textTheme.displayMedium,
        // title: success ? Strings.success : title,
        content: Container(
          margin: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.darkBrown,
              ),
              Text(
                "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                style: Theme.of(Get.context!).textTheme.displaySmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() => SizedBox(
                        width: Get.width * 0.16,
                        child: Radio(
                          activeColor: AppColors.yellow,
                          value: "AM",
                          groupValue: shift,
                          onChanged: (String? i) {
                            print(i);
                            shift = i!;
                            shiftTime = 1;
                          },
                        ),
                      )),
                  InkWell(
                    child: Text(
                      "AM",
                      style: Theme.of(Get.context!).textTheme.displaySmall,
                    ),
                    onTap: () {
                      shift = "AM";
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() => SizedBox(
                        width: Get.width * 0.16,
                        child: Radio(
                          activeColor: AppColors.yellow,
                          value: "PM",
                          groupValue: shift,
                          onChanged: (String? i) {
                            print(i);
                            shift = i!;
                            shiftTime = 2;
                          },
                        ),
                      )),
                  InkWell(
                    child: Text(
                      "PM",
                      style: Theme.of(Get.context!).textTheme.displaySmall,
                    ),
                    onTap: () {
                      shift = "PM";
                    },
                  ),
                ],
              ),
            ],
          ),
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
                onTap: () => Get.back(),
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

  // export excel
  Future<void> exportExcel() async {
    exportData.assignAll(await milkCollectionDB.fetchAll());

    // milkCollectionModelToMap(await milkCollectionDB.fetchAll());

    if (exportData.isNotEmpty) {
      Excel excel = Excel.createExcel();
      excel.rename(excel.getDefaultSheet()!, "CollectionData");

      Sheet sheet = excel["CollectionData"];

      final indexList = [
        {"key": "A1", "value": "Collection Date"},
        {"key": "B1", "value": "Inserted Time"},
        {"key": "C1", "value": "Farmer Id"},
        {"key": "D1", "value": "Farmer Name"},
        {"key": "E1", "value": "Collection Mode"},
        {"key": "F1", "value": "Scale Mode"},
        {"key": "G1", "value": "Analyze Mode"},
        {"key": "H1", "value": "Milk Status"},
        {"key": "I1", "value": "Rate Chart"},
        {"key": "J1", "value": "Qty"},
        {"key": "K1", "value": "FAT"},
        {"key": "L1", "value": "SNF"},
        {"key": "M1", "value": "Added Water"},
        {"key": "N1", "value": "Rate Per Liter"},
        {"key": "O1", "value": "Total Amount"},
        {"key": "P1", "value": "Collection Center Id"},
        {"key": "Q1", "value": "Collection Center Name"},
        {"key": "R1", "value": "Shift"},
      ];

      for (var i = 0; i < indexList.length; i++) {
        sheet.cell(CellIndex.indexByString(
          indexList[i]["key"].toString(),
        ))
          ..value = TextCellValue(
            indexList[i]["value"].toString(),
          )
          ..cellStyle = CellStyle(
            fontSize: 14,
            bold: true,
            backgroundColorHex: ExcelColor.yellow,
            fontColorHex: ExcelColor.black,
          );
      }

      sheetCell({
        required int index,
        required String value,
        required String column,
      }) {
        return sheet
            .cell(CellIndex.indexByString(
              "$column${(index + 2).toString()}",
            ))
            .value = TextCellValue(value);
      }

      for (var index = 0; index < exportData.length; index++) {
        sheetCell(
            index: index,
            column: "A",
            value: exportData.elementAt(index).collectionDate!);
        sheetCell(
            index: index,
            column: "B",
            value: exportData.elementAt(index).insertedTime!);
        sheetCell(
            index: index,
            column: "C",
            value: exportData.elementAt(index).farmerId.toString());
        sheetCell(
            index: index,
            column: "D",
            value: exportData.elementAt(index).farmerName.toString());
        sheetCell(
            index: index,
            column: "E",
            value: exportData.elementAt(index).collectionMode.toString());
        sheetCell(
            index: index,
            column: "F",
            value: exportData.elementAt(index).scaleMode.toString());
        sheetCell(
            index: index,
            column: "G",
            value: exportData.elementAt(index).analyzeMode.toString());
        sheetCell(
            index: index,
            column: "H",
            value: exportData.elementAt(index).milkStatus.toString());
        sheetCell(
            index: index,
            column: "I",
            value: exportData.elementAt(index).rateChartName.toString());
        sheetCell(
            index: index,
            column: "J",
            value: exportData.elementAt(index).qty.toString());
        sheetCell(
            index: index,
            column: "K",
            value: exportData.elementAt(index).fat.toString());
        sheetCell(
            index: index,
            column: "L",
            value: exportData.elementAt(index).snf.toString());
        sheetCell(
            index: index,
            column: "M",
            value: exportData.elementAt(index).addedWater.toString());
        sheetCell(
            index: index,
            column: "N",
            value: exportData.elementAt(index).ratePerLiter.toString());
        sheetCell(
            index: index,
            column: "O",
            value: exportData.elementAt(index).totalAmt.toString());
        sheetCell(
            index: index,
            column: "P",
            value: exportData.elementAt(index).collectionCenterId.toString());
        sheetCell(
            index: index,
            column: "Q",
            value: exportData.elementAt(index).collectionCenterName.toString());
        sheetCell(
            index: index,
            column: "R",
            value: exportData.elementAt(index).shift.toString());
      }

      var fileBytes = excel.save();

      var directory = await getApplicationDocumentsDirectory();

      File(join('${directory.path}/CollectionData.xlsx'))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      // OpenFilex.open('${directory.path}/output_file_name2.xlsx');
      await Share.shareXFiles([XFile('${directory.path}/CollectionData.xlsx')],
          text: 'CollectionData.xlsx');

      // }
    }
  }

  Future<void> sendCollection() async {
    Map<String, dynamic> _body = {
      "Collection_Date":
          DateFormat("dd-MMM-yyyy").format(DateTime.now()).toString(),
      "Inserted_Time": DateFormat("hh:mm:ss").format(DateTime.now()).toString(),
      "Calculations_ID": (box.read(calculationsId) + 1).toString(),
      "FarmerId": getFarmerIdFinal(),
      "Farmer_Name": farmerData.farmerName,
      "Collection_Mode": !check ? manualConst : autoConst,
      "Scale_Mode": !check ? manualConst : autoConst,
      "Analyze_Mode": !check ? manualConst : autoConst,
      "Milk_Status": "Accepted",
      "Milk_Type": radio == 0 ? "CM" : "BM",
      "Rate_Chart_Name": "1235ABC",
      "Qty": !check ? quantity : homeController.quantity,
      "FAT": !check ? fat : homeController.fat,
      "SNF": !check ? snf : homeController.snf,
      "Added_Water": !check ? water : homeController.water,
      "Rate_Per_Liter": !check ? getPriceData(false) : getPriceData(true),
      "Total_Amt": totalAmount,
      "CollectionCenterId": box.read(centerIdConst),
      "CollectionCenterName": box.read(centerName),
      "Shift": shiftTime == 1 ? "Am" : "Pm",
    };
    try {
      var res = await http.post(
          Uri.parse(
            "$baseUrlConst/$dailyCollection",
          ),
          // headers: {
          //   'Content-Type': 'application/json',
          // },
          body: _body);
      if (res.statusCode == 200 && jsonDecode(res.body) == "Inserted") {
        await getCollectionThirtyDaysData();
      } else {
        await accept();
      }
    } catch (e) {
      await accept();

      print(e.toString());
    }
  }

  Future<void> accept() async {
    await milkCollectionDB
        .create(
            FarmerId: int.tryParse(farmerId),
            Added_Water: double.tryParse(water.text),
            Analyze_Mode: !check ? manualConst : autoConst,
            CollectionCenterId: box.read(centerIdConst),
            CollectionCenterName: box.read(centerName),
            Collection_Date: DateFormat("dd-MMM-yyyy").format(DateTime.now()),
            Collection_Mode: !check ? manualConst : autoConst,
            FAT: double.tryParse(fat.text),
            Farmer_Name: farmerData.farmerName,
            Inserted_Time: DateFormat("hh:mm:ss").format(DateTime.now()),
            Milk_Status: "Accepted",
            Milk_Type: radio == 0 ? "CM" : "BM",
            Qty: double.tryParse(quantity.text),
            Rate_Chart_Name: "1235ABC",
            Rate_Per_Liter: double.tryParse(price),
            SNF: double.tryParse(snf.text),
            Scale_Mode: !check ? manualConst : autoConst,
            Shift: shiftTime == 1 ? "AM" : "PM",
            Total_Amt: !check
                ? double.tryParse(getTotalAmount(false))
                : double.tryParse(getTotalAmount(false)),
            FUploaded: !check ? 0 : 1)
        .then((value) async {
      emptyData();
      Utils.showSnackbar("Accepted!");

      // await checkIp();
    });
  }

  void emptyData() {
    printD = true;
    fat.clear();
    snf.clear();
    water.clear();
    quantity.clear();
    price = "";
    totalAmount = "";
    farmerData = FarmerListModel();
    farmerId = "";
    radio = 0;
    homeController.fat = "";
    homeController.snf = "";
    homeController.water = "";
    homeController.quantity = "";
  }

  printData() async {
    String collectionPrint =
        "***Maklife Producer Company Ltd***\n\nDate  :  ${DateFormat("dd-MMM-yyyy").format(DateTime.now())}\nTime  :  ${DateFormat("hh:mm:ss").format(DateTime.now())}\nFarmerName    :     ${farmerData.farmerName}\nFarmer Id     :     ${getFarmerIdFinal()}\nFat           :     $fat\nSnf           :     $snf\nMilk Type     :     ${radio == 0 ? "CM" : "BM"}\nWeight        :     ${!check ? quantity : homeController.quantity}\nPrice         :     ${!check ? getPriceData(false) : getPriceData(true)}\nAmount        :     ${totalAmount}\n          \n                      \n          \n       \n               \n           \n";

    homeController.socket!.write(collectionPrint);
  }
}
