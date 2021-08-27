import 'package:climate/country/country.dart';
import 'package:climate/home/home.dart';
import 'package:climate/network/network.dart';
import 'package:get/get.dart';
import '../app.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.APP;

  static final getPages = [
    GetPage(name: AppRoutes.APP, page: () => App()),
    GetPage(
        name: AppRoutes.COUNTRY,
        page: () => CountryPage(),
        binding: CountryBinding(),
        transition: Transition.rightToLeft),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: AppRoutes.NETWORK_ERROR,
      page: () => NetworkErrorPage(),
      binding: NetworkBinding(),
      transition: Transition.downToUp,
    ),
  ];
}
