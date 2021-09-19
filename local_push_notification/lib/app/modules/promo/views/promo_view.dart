import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/promo_controller.dart';

class PromoView extends GetView<PromoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PromoView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          Get.arguments != null ? Get.arguments : "",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
