import 'package:climate/country/country.dart';
import 'package:climate/storage_keys.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CountryController extends GetxController {
  var selectedTileIndex = 0.obs;
  var selectedCountryCode = ''.obs;
  late List<Country> country;

  var box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    country = [
      Country(name: "India", code: "IN"),
      Country(name: "United States", code: "US"),
      Country(name: "United Kingdom", code: "UK"),
      Country(name: "China", code: "CN"),
    ];

    if (box.read(COUNTRY_CODE_KEY) != null) {
      selectedTileIndex.value = country.indexOf(
          country.firstWhere((c) => c.code == box.read(COUNTRY_CODE_KEY)));
    } else {
      // No country selected by default
      selectedTileIndex.value = -1;
    }
  }

  void countrySelectionChange(int index) {
    var code = country[index].code;
    box.write(COUNTRY_CODE_KEY, code);
    selectedTileIndex.value = index;
  }

  void nextButtonClicked() {
    box.write(COUNTRY_SELECTED_KEY, true);
    Get.offAllNamed("/");
  }

  @override
  void onClose() {
    super.onClose();
  }
}
