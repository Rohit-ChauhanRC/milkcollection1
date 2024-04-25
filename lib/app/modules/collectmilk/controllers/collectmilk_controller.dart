import 'dart:io';
import 'dart:io' as io;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/milk_collection_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class CollectmilkController extends GetxController {
  //

  final box = GetStorage();

  final MilkCollectionDB milkCollectionDB = MilkCollectionDB();

  final PinverifyController pinverifyController = Get.find();

  late ServerSocket serverSocket;
  late Socket socket;

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

  @override
  void onInit() async {
    super.onInit();
    await Permission.storage.request();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // void print(String text) {
  //  socket.getRawOption(option);
  // ReadBuffer(ByteData.sublistView(TransferableTypedData.fromList(list)[0].,));
  // }

  // http://Payment.maklife.in:9019/api/RestoreCollectionData?CollectionCenterId=5&FromDate=24-JAN-2024&ToDate=24-APR-2024

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

  // Future<void> connecttionSocket() async {
  //   final ip = InternetAddress.anyIPv4;
  //   final server = await ServerSocket.bind(ip, 8889);
  //   print("Server is running on: ${ip.address}:8889");
  //   server.listen((event) {
  //     handleConnection(event);
  //   });
  // }

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
                        // width: Get.width * 0.18,
                        child: Radio(
                          activeColor: AppColors.yellow,
                          value: "AM",
                          groupValue: shift,
                          onChanged: (String? i) {
                            print(i);
                            shift = i!;
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
                        width: Get.width * 0.18,
                        child: Radio(
                          activeColor: AppColors.yellow,
                          value: "PM",
                          groupValue: shift,
                          onChanged: (String? i) {
                            print(i);
                            shift = i!;
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

      sheet.cell(CellIndex.indexByString(
        "A1",
      ))
        ..value = const TextCellValue("Collection Date")
        ..cellStyle = CellStyle(
          fontSize: 16,
          bold: true,
          backgroundColorHex: ExcelColor.yellow,
          fontColorHex: ExcelColor.black,
        );
      sheet
          .cell(CellIndex.indexByString(
            "B1",
          ))
          .value = const TextCellValue("Inserted Time");
      sheet
          .cell(CellIndex.indexByString(
            "C1",
          ))
          .value = const TextCellValue("Farmer Id");
      sheet
          .cell(CellIndex.indexByString(
            "D1",
          ))
          .value = const TextCellValue("Farmer Name");
      sheet
          .cell(CellIndex.indexByString(
            "E1",
          ))
          .value = const TextCellValue("Collection Mode");
      sheet
          .cell(CellIndex.indexByString(
            "F1",
          ))
          .value = const TextCellValue("Scale Mode");
      sheet
          .cell(CellIndex.indexByString(
            "G1",
          ))
          .value = const TextCellValue("Analyze Mode");
      sheet
          .cell(CellIndex.indexByString(
            "H1",
          ))
          .value = const TextCellValue("Milk Status");
      sheet
          .cell(CellIndex.indexByString(
            "I1",
          ))
          .value = const TextCellValue("Rate Chart");
      sheet
          .cell(CellIndex.indexByString(
            "J1",
          ))
          .value = const TextCellValue("Qty");
      sheet
          .cell(CellIndex.indexByString(
            "K1",
          ))
          .value = const TextCellValue("FAT");
      sheet
          .cell(CellIndex.indexByString(
            "L1",
          ))
          .value = const TextCellValue("SNF");
      sheet
          .cell(CellIndex.indexByString(
            "M1",
          ))
          .value = const TextCellValue("Added Water");
      sheet
          .cell(CellIndex.indexByString(
            "N1",
          ))
          .value = const TextCellValue("Rate Per Liter");
      sheet
          .cell(CellIndex.indexByString(
            "O1",
          ))
          .value = const TextCellValue("Total Amount");
      sheet
          .cell(CellIndex.indexByString(
            "P1",
          ))
          .value = const TextCellValue("Collection Center Id");
      sheet
          .cell(CellIndex.indexByString(
            "Q1",
          ))
          .value = const TextCellValue("Collection Center Name");
      sheet
          .cell(CellIndex.indexByString(
            "R1",
          ))
          .value = const TextCellValue("Shift");

      List.generate(exportData.length, (index) {
        sheet
            .cell(CellIndex.indexByString(
              "A${(index + 2).toString()}",
            ))
            .value = TextCellValue(exportData.elementAt(index).collectionDate!);
        sheet
            .cell(CellIndex.indexByString(
              "B${(index + 2).toString()}",
            ))
            .value = TextCellValue(exportData.elementAt(index).insertedTime!);
        sheet
                .cell(CellIndex.indexByString(
                  "C${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(exportData.elementAt(index).farmerId.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "D${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(exportData.elementAt(index).farmerName.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "E${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(
                exportData.elementAt(index).collectionMode.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "F${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(exportData.elementAt(index).scaleMode.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "G${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(exportData.elementAt(index).analyzeMode.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "H${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(exportData.elementAt(index).milkStatus.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "I${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(exportData.elementAt(index).rateChartName.toString());
        sheet
            .cell(CellIndex.indexByString(
              "J${(index + 2).toString()}",
            ))
            .value = TextCellValue(exportData.elementAt(index).qty.toString());
        sheet
            .cell(CellIndex.indexByString(
              "K${(index + 2).toString()}",
            ))
            .value = TextCellValue(exportData.elementAt(index).fat.toString());
        sheet
            .cell(CellIndex.indexByString(
              "L${(index + 2).toString()}",
            ))
            .value = TextCellValue(exportData.elementAt(index).snf.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "M${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(exportData.elementAt(index).addedWater.toString());

        sheet
                .cell(CellIndex.indexByString(
                  "N${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(exportData.elementAt(index).ratePerLiter.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "O${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(exportData.elementAt(index).totalAmt.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "P${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(
                exportData.elementAt(index).collectionCenterId.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "Q${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(
                exportData.elementAt(index).collectionCenterName.toString());
        sheet
                .cell(CellIndex.indexByString(
                  "R${(index + 2).toString()}",
                ))
                .value =
            TextCellValue(exportData.elementAt(index).shift.toString());
      });
      var fileBytes = excel.save();

      var directory = await getApplicationDocumentsDirectory();

      File(join('${directory.path}/output_file_name2.xlsx'))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      OpenFilex.open('${directory.path}/output_file_name2.xlsx');

      // }
    }
  }

  getSheet(
      {required Sheet sheet,
      required String cellIndex,
      required String value}) {
    // Sheet sheet = excel["CollectionData"];

    sheet
        .cell(CellIndex.indexByString(
          "A1",
        ))
        .value = TextCellValue(value.toString());
  }
}



// List<Socket> clients = [];

// void handleConnection(Socket client) {
//   client.listen(
//     (Uint8List data) {
//       final message = String.fromCharCodes(data);

//       for (var c in clients) {
//         c.write("Server: $message joined the party!");
//       }

//       clients.add(client);
//       client.write("server you are logged in $message");
//     },
//     onError: (error) {
//       print(error);
//       client.close();
//     },
//     onDone: () {
//       print("Server: Client left");
//       client.close();
//     },
//   );
// }
