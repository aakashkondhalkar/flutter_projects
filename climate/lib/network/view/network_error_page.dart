import 'package:climate/network/network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkErrorPage extends StatelessWidget {
  NetworkErrorPage({Key? key}) : super(key: key);

  final NetworkController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        if (controller.connectivityStatus > 0) {
          Get.offAllNamed("/");
        }
        return false;
      },
      child: Scaffold(
        body: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/network.png",
                  width: 100,
                  color: Colors.red.shade500,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "No internet connection",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 1, primary: Colors.red),
                    onPressed: controller.checkConnectivity,
                    child: Text("Reload"))
              ],
            )),
      ),
    ));
  }
}
