import 'package:climate/home/home.dart';
import 'package:climate/home/model/model.dart';
import 'package:climate/home/provider/provider.dart';
import 'package:climate/network/network.dart';
import 'package:climate/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var climate = Climate().obs;

  var seatchText = ''.obs;

  late TextEditingController searchController;

  var box = GetStorage();

  // Call controller to recive updated of network connection on home page
  final NetworkController networkController = Get.find();

  var countryCode;

  @override
  void onInit() {
    super.onInit();

    searchController = TextEditingController();

    countryCode = box.read(COUNTRY_CODE_KEY);
  }

  void fetchClimate(String city) async {
    try {
      isLoading(true);

      climate.value = await ClimateProvider.fetchClimate(
          city: city, countryCode: countryCode);

      Get.bottomSheet(
        BottomSheetInfoWidget(),
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        enableDrag: true,
      );
    } catch (e) {
      Get.snackbar("Error", "No data available for city ${seatchText.value}",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          margin: EdgeInsets.all(16));
    } finally {
      isLoading(false);
    }
  }

  void searchTextChanged(String? text) {
    seatchText.value = text!;
  }

  String? validateSearchText(String? value) {
    if (value != null && value.isEmpty) {
      return "Please enter city name";
    }
    return null;
  }

  void searchSubmit() {
    fetchClimate(seatchText.value.trim());
  }

  @override
  void onClose() {
    super.onClose();
  }
}
