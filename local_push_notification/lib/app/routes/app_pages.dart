import 'package:get/get.dart';

import 'package:local_push_notification/app/modules/home/bindings/home_binding.dart';
import 'package:local_push_notification/app/modules/home/views/home_view.dart';
import 'package:local_push_notification/app/modules/promo/bindings/promo_binding.dart';
import 'package:local_push_notification/app/modules/promo/views/promo_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROMO,
      page: () => PromoView(),
      binding: PromoBinding(),
    ),
  ];
}
