import 'package:climate/network/controller/controller.dart';
import 'package:get/get.dart';

class NetworkBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkController>(() => NetworkController(), fenix: true);
  }
}
