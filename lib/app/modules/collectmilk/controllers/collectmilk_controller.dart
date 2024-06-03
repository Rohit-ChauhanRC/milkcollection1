import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/farmer_db.dart';
import 'package:milkcollection/app/data/local_database/milk_collection_db.dart';
import 'package:milkcollection/app/data/local_database/ratechart_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';
import 'package:milkcollection/app/data/models/ratechart_model.dart';
import 'package:milkcollection/app/modules/home/controllers/home_controller.dart';
import 'dart:convert';
import 'package:path/path.dart';

import 'package:milkcollection/app/data/models/milk_collection_model.dart';
import 'package:milkcollection/app/data/models/pin_manual_model.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/theme/app_dimens.dart';
import 'package:milkcollection/app/utils/utils.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:share_plus/share_plus.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class CollectmilkController extends GetxController {
  //

  final box = GetStorage();

  final MilkCollectionDB milkCollectionDB = MilkCollectionDB();

  final RateChartDB rateChartDB = RateChartDB();

  ProgressDialog pd = ProgressDialog(context: Get.context);

  final HomeController homeController =
      Get.put<HomeController>(HomeController());

  // final PinverifyController pinverifyController = Get.find();
  final FarmerDB farmerDB = FarmerDB();

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

  // final RxString _fName = ''.obs;
  // String get fNam => _fName.value;
  // set fName(String mob) => _fName.value = mob;

  final RxList<FarmerListModel> _farmerDataList = RxList<FarmerListModel>();
  List<FarmerListModel> get farmerDataList => _farmerDataList;
  set farmerDataList(List<FarmerListModel> lst) =>
      _farmerDataList.assignAll(lst);

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

  TextEditingController fat = TextEditingController();
  TextEditingController snf = TextEditingController();
  TextEditingController density = TextEditingController();
  TextEditingController water = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController farmerIdC = TextEditingController();

  final RxList<RatechartModel> _rateChartData = RxList<RatechartModel>();
  List<RatechartModel> get rateChartData => _rateChartData;
  set rateChartData(List<RatechartModel> lst) => _rateChartData.assignAll(lst);

  final RxString _price = "0.0".obs;
  String get price => _price.value;
  set price(String i) => _price.value = i;

  final RxString _totalAmount = "0.0".obs;
  String get totalAmount => _totalAmount.value;
  set totalAmount(String i) => _totalAmount.value = i;

  final RxInt _shiftTime = 1.obs;
  int get shiftTime => _shiftTime.value;
  set shiftTime(int i) => _shiftTime.value = i;

  // late Rx<Socket> printer;

  final RxBool _printD = false.obs;
  bool get printD => _printD.value;
  set printD(bool v) => _printD.value = v;

  final RxBool _progress = false.obs;
  bool get progress => _progress.value;
  set progress(bool v) => _progress.value = v;

  final RxBool _circularProgress = true.obs;
  bool get circularProgress => _circularProgress.value;
  set circularProgress(bool v) => _circularProgress.value = v;

  @override
  void onInit() async {
    super.onInit();

    // await checkIp();

    farmerDataList.assignAll(await farmerDB.fetchAll());

    if (DateTime.now().hour < 12) {
      shiftTime = 1;
      shift = 'AM';
    } else {
      shiftTime = 2;
      shift = "PM";
    }
    await Permission.storage.request();

    // WidgetsBinding.instance.initInstances();
    // await getCollectionThirtyDaysData();
    await getRateChart();
  }

  @override
  void onReady() async {
    super.onReady();
    // await getRateChart();
  }

  @override
  void onClose() {
    super.onClose();
    _check.close();
    _exportData.clear();
    _farmerData.close();
    _farmerDataList.clear();
    _farmerId.close();
    _pin.close();
    _pinManual.clear();
    _price.close();
    _printD.close();
    _radio.close();
    _rateChartData.clear();
    _restoreData.clear();
    _shift.close();
    _shiftTime.close();
    _totalAmount.close();
    fat.clear();
    snf.clear();
    water.clear();
    farmerIdC.clear();
    quantity.clear();
  }

  Future<void> getRateChart() async {
    rateChartData
        .assignAll(await rateChartDB.fetchByMilkType(radio == 0 ? "C" : "B"));

    print(
        "await rateChartDB.fetchAll(): ${await rateChartDB.fetchByMilkType(radio == 0 ? "C" : "B")}");
  }

  String getPriceData() {
    for (var i = 0; i < rateChartData.length; i++) {
      if (!check) {
        if (fat.text.isNotEmpty &&
            snf.text.isNotEmpty &&
            double.parse(fat.text) == double.parse(rateChartData[i].fat) &&
            double.parse(snf.text) == double.parse(rateChartData[i].snf)) {
          price = (rateChartData[i].price.toPrecision(2)).toString();
          // print(price);
          print("price:$price");
        }
      } else {
        // homeController.
        if (double.parse(homeController.fat) ==
                double.parse(rateChartData[i].fat) &&
            double.parse(homeController.snf) ==
                double.parse(rateChartData[i].snf)) {
          price = (rateChartData[i].price.toPrecision(2)).toString();
          print("price:$price");
        }
      }
    }

    return price;
  }

  String getTotalAmount() {
    totalAmount = "";

    // print("rateChartData: $rateChartData");

    for (var i = 0; i < rateChartData.length; i++) {
      if (!check) {
        // if()
        if (fat.text.isNotEmpty &&
            snf.text.isNotEmpty &&
            double.parse(fat.text) == double.parse(rateChartData[i].fat) &&
            double.parse(snf.text) == double.parse(rateChartData[i].snf) &&
            quantity.text.isNotEmpty &&
            quantity.text != "0.0") {
          totalAmount =
              ((rateChartData[i].price * (double.parse(quantity.text)))
                      .toPrecision(2))
                  .toString();
          // print(totalAmount);
          print("totalAmount:$totalAmount");
        }
        update();
      } else {
        if (double.parse(homeController.fat) ==
                double.parse(rateChartData[i].fat) &&
            double.parse(homeController.snf) ==
                double.parse(rateChartData[i].snf) &&
            homeController.quantity.isNotEmpty &&
            quantity.text != "0.0") {
          totalAmount =
              ((rateChartData[i].price * double.parse(homeController.quantity))
                      .toPrecision(2))
                  .toString();
          print("totalAmount:$totalAmount");
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
        print("res: ${jsonDecode(res.body.toString())}");
        restoreData.assignAll(milkCollectionModelFromMap(res.body));
        if (restoreData.isNotEmpty) {
          pd.show(
              max: restoreData.length,
              msgFontSize: 10,
              valueFontSize: 10,
              msgTextAlign: TextAlign.left,
              msg: 'Recover data!...');
          // print(restoreData.length.toString());
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
          pd.close();
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
          // print(restoreData.length.toString());
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
        // print(jsonDecode(res.body));
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  getFarmerId() async {
    var farmerfinalId = box.read(centerIdConst);
    if (farmerId.length == 1) {
      farmerfinalId = "${box.read(centerIdConst)}000$farmerId";
    } else if (farmerId.length == 2) {
      farmerfinalId = "${box.read(centerIdConst)}00$farmerId";
    } else if (farmerId.length == 3) {
      farmerfinalId = "${box.read(centerIdConst)}0$farmerId";
    } else if (farmerId.length == 4) {
      farmerfinalId = box.read(centerIdConst).toString() + farmerId;
      // }
    }

    for (var i = 0; i < farmerDataList.length; i++) {
      if (farmerDataList[i].farmerId.toString() !=
          farmerfinalId.toString().trim()) {
        farmerData = FarmerListModel(farmerName: "Unknown");
        print("farmerData:${farmerData.farmerName}");

        update();
        // break;
      }

      if (farmerDataList[i].farmerId.toString() ==
          farmerfinalId.toString().trim()) {
        // searchfarmerData.assign(farmerData[i]);
        farmerData = farmerDataList[i];
        print("farmerData:${farmerData.farmerName}");

        update();
        break;
      }
      // else {
      //   farmerData = FarmerListModel(farmerName: "Unknown");
      //   print("farmerData:${farmerData.farmerName}");

      //   update();
      //   break;
      // }
    }
    // farmerData = farmerDataList.where((e) => e.farmerId == farmerfinalId);
  }

  String getFarmerIdFinal() {
    var farmerfinalId = "";
    if (farmerId.length == 1) {
      farmerfinalId = "${box.read(centerIdConst)}000$farmerId";
    } else if (farmerId.length == 2) {
      farmerfinalId = "${box.read(centerIdConst)}00$farmerId";
    } else if (farmerId.length == 3) {
      farmerfinalId = "${box.read(centerIdConst)}0$farmerId";
    } else if (farmerId.length == 4) {
      farmerfinalId = box.read(centerIdConst).toString() + farmerId;
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
        pinManual.assignAll([]);

        pinManual.assignAll(pinnmanualModelFromMap(res.body));
        if (pinManual.isNotEmpty) {
          if (pinManual[0].pin == int.parse(pin)) {
            check = false;
            Utils.closeDialog();
            showDialogSelectShift();
          } else {
            Utils.showSnackbar("Pin Expired Of Your Collection Centre!");
          }
        }
      } else {}
    } catch (e) {}
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
        content: TextFormWidget(
          prefix: const Icon(
            Icons.pin,
            size: 30,
          ),
          initialValue: pin,
          label: "Please enter Pin...",
          onChanged: (val) {
            pin = val;
          },
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
          ),
          inputFormatters: [
            // TextInputFormatter(decimalRange: 1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          maxLength: 10,
        ),
        // cancel: ,
        confirm: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
        ),
      );

  void showDialogSelectShift() => Get.defaultDialog(
        barrierDismissible: false,
        backgroundColor: AppColors.white,
        title: "Please Select Shift",
        titleStyle: Theme.of(Get.context!).textTheme.displayMedium,
        // title: success ? Strings.success : title,
        content: Container(
          margin: const EdgeInsets.all(10),
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
                      shiftTime = 1;
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
                      shiftTime = 2;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // cancel: ,
        confirm: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
        ),
      );

  // export excel
  Future<void> exportExcel() async {
    exportData.assignAll(await milkCollectionDB.fetchAll());

    // milkCollectionModelToMap(await milkCollectionDB.fetchAll());

    if (exportData.isNotEmpty) {
      Excel excel = Excel.createExcel();
      excel.rename(excel.getDefaultSheet()!,
          "CollectionData_${box.read(centerIdConst)}");

      Sheet sheet = excel["CollectionData_${box.read(centerIdConst)}"];

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
            fontSize: 10,
            // bold: true,
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
      "Calculations_ID": (box.read(calculationsId) ?? 0 + 1).toString(),
      "FarmerId": getFarmerIdFinal(),
      "Farmer_Name": farmerData.farmerName,
      "Collection_Mode": !check ? manualConst : autoConst,
      "Scale_Mode": !check ? manualConst : autoConst,
      "Analyze_Mode": !check ? manualConst : autoConst,
      "Milk_Status": "Accepted",
      "Milk_Type": radio == 0 ? "CM" : "BM",
      "Rate_Chart_Name": "1235ABC",
      "Qty": !check ? quantity.text : homeController.quantity,
      "FAT": !check ? fat.text : homeController.fat,
      "SNF": !check ? snf.text : homeController.snf,
      "Added_Water": !check ? water.text : homeController.water,
      "Rate_Per_Liter": !check ? getPriceData() : getPriceData(),
      "Total_Amt": totalAmount,
      "CollectionCenterId": box.read(centerIdConst),
      "CollectionCenterName": box.read(centerName),
      "Shift": shift.capitalizeFirst,
    };

    try {
      var res = await http.post(
          Uri.parse(
            "$baseUrlConst/$dailyCollection",
          ),
          body: _body);
      if (res.statusCode == 200 && jsonDecode(res.body) == "Inserted") {
        // Utils.showSnackbar("accepted!");
        progress = false;
        //  ;
      } else {
        progress = false;
      }
    } catch (e) {
      print(e.toString());
      progress = false;
    }
    // emptyData();
  }

  Future<void> accept() async {
    await milkCollectionDB.create(
        FarmerId: int.parse(getFarmerIdFinal()),
        Added_Water: !check
            ? double.parse(water.text)
            : double.parse(homeController.water),
        Analyze_Mode: !check ? manualConst : autoConst,
        CollectionCenterId: box.read(centerIdConst),
        CollectionCenterName: box.read(centerName),
        Collection_Date: DateFormat("dd-MMM-yyyy").format(DateTime.now()),
        Collection_Mode: !check ? manualConst : autoConst,
        FAT: !check ? double.parse(fat.text) : double.parse(homeController.fat),
        Farmer_Name: farmerData.farmerName,
        Inserted_Time: DateFormat("hh:mm:ss").format(DateTime.now()),
        Milk_Status: "Accepted",
        Milk_Type: radio == 0 ? "CM" : "BM",
        Qty: !check
            ? double.parse(quantity.text)
            : double.parse(homeController.quantity),
        Rate_Chart_Name: "1235ABC",
        Rate_Per_Liter: double.parse(price),
        SNF: !check ? double.parse(snf.text) : double.parse(homeController.snf),
        Scale_Mode: !check ? manualConst : autoConst,
        Shift: shift.capitalizeFirst,
        Total_Amt: !check
            ? double.parse(getTotalAmount())
            : double.parse(getTotalAmount()),
        FUploaded: !check ? 0 : 1);
  }

  void emptyData() {
    // _farmerId.close();
    farmerId = "";
    printD = true;
    fat.clear();
    snf.clear();
    water.clear();
    quantity.clear();
    price = "";
    totalAmount = "";
    farmerData = FarmerListModel();
    // farmerId.clear();
    radio = 0;
    homeController.fat = "";
    homeController.snf = "";
    homeController.water = "";
    homeController.quantity = "";
    farmerIdC.clear();
    // _farmerId.value = farmerId;
    update();
  }

  Future printData() async {
    homeController.printData(
      shift: shift.capitalizeFirst.toString(),
      farmerName: farmerData.farmerName!,
      fat1: !check ? fat.text : homeController.fat,
      getFarmerId: getFarmerIdFinal(),
      milkType: radio == 0 ? "CM" : "BM",
      price: !check ? getPriceData() : getPriceData(),
      quantity1: !check ? quantity.text.toString() : homeController.quantity,
      snf1: !check ? snf.text : homeController.snf,
      totalAmount: totalAmount,
    );
  }

  Future<void> checkSmsFlag() async {
    // http://Payment.maklife.in:9019/api/getsmsflag
    var res = await http.post(Uri.parse("$baseUrlConst/getsmsflag"), body: {
      "CenterId": box.read(centerIdConst),
    });
    if (res.statusCode == 200 && jsonDecode(res.body) == "Y") {
      progress = false;
      await sendMessage();
    }
  }

  Future<void> sendMessage() async {
    try {
      var res = await http.post(Uri.parse(
          //
          "http://sms.autobysms.com/app/smsapi/index.php?key=36365EF4C86D67&campaign=0&routeid=9&type=text&contacts=${farmerData.mobileNumber}&senderid=MAKLIF&msg=MAK LIFE%0D%0AColl. Ctr ID: ${box.read(centerIdConst)}%0D%0AFarmer Id: ${getFarmerIdFinal()}%0D%0ADate: ${DateFormat("dd-MMM-yyyy").format(DateTime.now())}_${shift.capitalizeFirst}%0D%0AMilk Type: ${radio == 0 ? "CM" : "BM"}%0D%0AQty: ${!check ? quantity.text.toString() : homeController.quantity}%0D%0AFAT: ${!check ? fat.text : homeController.fat}%0D%0ASNF: ${!check ? snf.text : homeController.snf}%0D%0AWATER %: ${!check ? water.text : homeController.water}%0D%0ARATE: ${!check ? getPriceData() : getPriceData()}%0D%0ATot Amt.: Rs.$totalAmount%0D%0A&template_id=1207165769139334975"));
      if (res.statusCode == 200) {
        Utils.showSnackbar(jsonDecode(res.body)["message"]);

        // print(jsonDecode(res.body));
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }
}
