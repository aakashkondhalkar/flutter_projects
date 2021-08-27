import 'package:climate/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountryIconWidget extends StatelessWidget {
  CountryIconWidget({Key? key}) : super(key: key);
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: () => Get.toNamed("/country"),
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20.0,
                backgroundImage: AssetImage(
                  "assets/images/flags/png/${controller.countryCode.toString().toLowerCase()}.png",
                )),
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
    );
  }
}
