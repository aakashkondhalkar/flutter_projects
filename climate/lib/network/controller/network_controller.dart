import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  var connectivityStatus = 0.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubcription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    _connectivitySubcription = _connectivity.onConnectivityChanged
        .listen((result) => _updateConnectionStatus(result));
  }

  Future<void> initConnectivity() async {
    ConnectivityResult connectivityResult;
    try {
      connectivityResult = await _connectivity.checkConnectivity();
      _updateConnectionStatus(connectivityResult);
    } catch (e) {
      print(e.toString());
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        // Get.snackbar("Network", "Wifi connected", margin: EdgeInsets.all(16));
        connectivityStatus.value = 1;
        break;
      case ConnectivityResult.mobile:
        // Get.snackbar("Network", "Mobile data connected",
        // margin: EdgeInsets.all(16));
        connectivityStatus.value = 2;
        break;
      case ConnectivityResult.ethernet:
        // Get.snackbar("Network", "Ethernet connected",
        //     margin: EdgeInsets.all(16));
        connectivityStatus.value = 3;
        break;
      case ConnectivityResult.none:
        connectivityStatus.value = 0;
        Get.toNamed("/networkerror");
        break;
      default:
        Get.toNamed("/networkerror");
    }
  }

  void checkConnectivity() {
    if (connectivityStatus.value != 0) {
      Get.back();
    }
  }

  @override
  void onClose() {
    _connectivitySubcription.cancel();
    super.onClose();
  }
}
