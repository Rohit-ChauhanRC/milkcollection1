import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/ratechart_db.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:milkcollection/app/data/models/ratechart_model.dart';

class HomeController extends GetxController {
  //
  final box = GetStorage();

  final RateChartDB rateChartDB = RateChartDB();

  // final CollectmilkController collectmilkController =
  //     Get.put(CollectmilkController());

  ProgressDialog pd = ProgressDialog(context: Get.context);

  final RxInt _radio = 1.obs;
  int get radio => _radio.value;
  set radio(int i) => _radio.value = i;

  final RxList<RatechartModel> _rateChartData = RxList<RatechartModel>();
  List<RatechartModel> get rateChartData => _rateChartData;
  set rateChartData(List<RatechartModel> lst) => _rateChartData.assignAll(lst);

  // late Socket analyzer;
  Socket? socket;
  // Socket get analyzer => _analyzer.value;
  // set analyzer(Socket ss) => _analyzer.value = ss;

  // late Rx<Socket> _printer;
  // Socket get printer => _printer.value;
  // set printer(Socket ss) => _printer.value = ss;

  // late Rx<Socket> _weighing;
  // Socket get weighing => _weighing.value;
  // set weighing(Socket ss) => _weighing.value = ss;

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

  @override
  void onInit() async {
    super.onInit();
    if (DateTime.now().hour < 12) {
      radio = 1;
    } else {
      radio = 2;
    }

    await getRateChart("C").then((value) async {
      await getRateChart("B").then((value) async {
        pd.close();
      });
    });

    await checkIp();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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
              msgFontSize: 12,
              valueFontSize: 12,
              msg: 'Downloading Rate Chart ${rateChartData.length}...');
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
                  msgFontSize: 12,
                  valueFontSize: 12,
                  max: rateChartData.length,
                  msg: 'Downloading Rate Chart ${rateChartData.length}...');
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
        // analyzer = client;

        print(message);

        // collectmilkController.fat =
        //     "${message.split(" ")[1].split("@")[1]}.${message.split(" ")[1].split("@")[2]}";
        fat =
            "${message.split(" ")[1].split("@")[1]}.${message.split(" ")[1].split("@")[2]}";
        print(fat);
        // collectmilkController.snf =
        //     "${message.split(" ")[1].split("@")[3]}.${message.split(" ")[1].split("@")[4]}";
        snf =
            "${message.split(" ")[1].split("@")[3]}.${message.split(" ")[1].split("@")[4]}";
        print(snf);
        density =
            "${message.split(" ")[1].split("@")[5]}.${message.split(" ")[1].split("@")[6]}";
        // collectmilkController.density =
        //     "${message.split(" ")[1].split("@")[5]}.${message.split(" ")[1].split("@")[6]}";
        print(density);
        water =
            "${message.split(" ")[1].split("@")[7]}.${message.split(" ")[1].split("@")[8]}";
        // collectmilkController.water =
        //     "${message.split(" ")[1].split("@")[7]}.${message.split(" ")[1].split("@")[8]}";
        print(water);
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
    // client.write("object");

    client.listen(
      (Uint8List data) {
        final message = String.fromCharCodes(data);

        print("message:$message");
        print("printer");

        if (printStatus) {
          client.write(printSummaryData);
          printStatus = false;
        }
        // client.write("Santram");
        // printer = client;
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
}
