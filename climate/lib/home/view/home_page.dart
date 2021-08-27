import 'package:climate/home/controller/controller.dart';
import 'package:climate/home/home.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget _searchWidget = _SearchClimate();

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
          gradient:
              LinearGradient(colors: [Colors.orange, Colors.orange.shade400]),
          color: Colors.green.shade50,
        ),
        padding: EdgeInsets.only(top: 120),
        child: Column(
          children: [
            Text(
              "SEARCH CLIMATE",
              style: TextStyle(
                  shadows: [
                    Shadow(color: Colors.grey, offset: Offset.fromDirection(20))
                  ],
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 32,
            ),
            _searchWidget,
          ],
        ),
      ),
    );
  }
}

class _SearchClimate extends StatelessWidget {
  _SearchClimate({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                autofocus: false,
                style: TextStyle(color: Colors.black),
                decoration:
                    _formInputTextFieldDecoration(label: "Enter city name"),
                controller: controller.searchController,
                onChanged: controller.searchTextChanged,
                validator: (value) => controller.validateSearchText(value!),
                onSaved: (value) => controller.searchController.text = value!,
              ),
              SizedBox(
                height: 32,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      shadowColor: Colors.black,
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      side: BorderSide(width: 1.0, color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      controller.searchSubmit();
                    }
                  },
                  child: Text(
                    "Search",
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _formInputTextFieldDecoration({required String label}) {
  final Widget _countryIconWidget = CountryIconWidget();

  return InputDecoration(
      // labelStyle: TextStyle(color: Colors.white),
      // labelText: '$label',

      prefixIcon: _countryIconWidget,
      hintText: "$label",
      hintStyle: TextStyle(color: Colors.black),
      // fillColor: Color.fromRGBO(255, 190, 100, 1),
      fillColor: Color.fromRGBO(255, 255, 255, 0.8),
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.orange.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.orange.shade300,
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      errorStyle: TextStyle(shadows: [
        Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(0, 1))
      ], color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400));
}
