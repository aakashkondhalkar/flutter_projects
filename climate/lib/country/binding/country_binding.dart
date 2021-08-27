import 'package:climate/country/country.dart';
import 'package:get/get.dart';

class CountryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CountryController>(() => CountryController());
  }
}
