import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/milk_collection_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';
import 'dart:convert';

import 'package:milkcollection/app/data/models/milk_collection_model.dart';
import 'package:milkcollection/app/data/models/pin_manual_model.dart';
import 'package:milkcollection/app/modules/pinverify/controllers/pinverify_controller.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/theme/app_dimens.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';

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

  @override
  void onInit() {
    super.onInit();
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

  Future<void> connecttionSocket() async {
    final ip = InternetAddress.anyIPv4;
    final server = await ServerSocket.bind(ip, 8889);
    print("Server is running on: ${ip.address}:8889");
    server.listen((event) {
      handleConnection(event);
    });
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
            Get.back();
          } else {
            print("object");
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
}

List<Socket> clients = [];

void handleConnection(Socket client) {
  client.listen(
    (Uint8List data) {
      final message = String.fromCharCodes(data);

      for (var c in clients) {
        c.write("Server: $message joined the party!");
      }

      clients.add(client);
      client.write("server you are logged in $message");
    },
    onError: (error) {
      print(error);
      client.close();
    },
    onDone: () {
      print("Server: Client left");
      client.close();
    },
  );
}
