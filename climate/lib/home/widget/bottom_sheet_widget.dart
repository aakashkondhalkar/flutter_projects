import 'package:climate/home/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetInfoWidget extends StatelessWidget {
  BottomSheetInfoWidget({Key? key}) : super(key: key);

  final HomeController controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.isLoading.value
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    // height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/weather/${controller.climate.value.weather!.first.main}.jpg"),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 1)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: Container()),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            // Colors.black,
                            Color.fromRGBO(0, 0, 0, 0.5),
                            Colors.transparent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      // color: Color.fromRGBO(255, 255, 255, 255.7),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "http://openweathermap.org/img/w/${controller.climate.value.weather!.first.icon}.png",
                                color: Colors.white,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${controller.climate.value.weather!.first.main}",
                                    style: TextStyle(
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 0.9)
                                      ],
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "${controller.climate.value.weather!.first.description}",
                                    style: TextStyle(
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 0.9)
                                      ],
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Country: ${controller.climate.value.sys!.country}",
                                style: TextStyle(
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 0.9)
                                  ],
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                "City: ${controller.climate.value.name}",
                                style: TextStyle(
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 0.9)
                                  ],
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.thermostat,
                                color: Colors.white,
                                size: 32,
                              ),
                              Text(
                                "${controller.climate.value.main!.temp}",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                    fontSize: 32),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                              "Feels Like: ${controller.climate.value.main!.feelsLike}",
                              style: TextStyle(color: Colors.white)),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                              "Humidity: ${controller.climate.value.main!.humidity}",
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    )
                  ]),
                )
              ],
            ),
          )));
  }
}
