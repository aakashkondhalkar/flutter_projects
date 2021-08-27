import 'package:climate/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      bool isCountryPageViewed = box.read(COUNTRY_SELECTED_KEY) ?? false;

      if (!isCountryPageViewed) {
        Get.offAllNamed("/country");
      } else {
        Get.offAllNamed("/");
      }
    });
    return Scaffold(body: Container());
  }
}
