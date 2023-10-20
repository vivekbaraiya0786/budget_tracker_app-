import 'package:budget_tracker_app/views/screens/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main(){
  runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        getPages: [
          GetPage(name: '/',page:() => Mainpage(), ),
        ],
      )
  );
}