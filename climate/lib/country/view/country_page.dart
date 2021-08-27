import 'package:climate/country/country.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountryPage extends StatelessWidget {
  CountryPage({Key? key}) : super(key: key);

  final CountryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                "CHOOSE YOUR COUNTRY",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: controller.country.length,
                  itemBuilder: (context, index) => Center(
                    child: Obx(
                      () => Card(
                        child: ListTile(
                          selectedTileColor: Colors.blue.shade100,
                          selected: index == controller.selectedTileIndex.value
                              ? true
                              : false,
                          onTap: () => controller.countrySelectionChange(index),
                          title: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                            alignment: Alignment.center,
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "${controller.country[index].name}(${controller.country[index].code})",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Obx(
          () => Visibility(
            visible: controller.selectedTileIndex.value < 0 ? false : true,
            child: FloatingActionButton(
              onPressed: controller.nextButtonClicked,
              child: Icon(Icons.check, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
