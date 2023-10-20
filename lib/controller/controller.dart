import 'package:budget_tracker_app/modals/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController{
  int intialIndex = 0;

  PageController pageController = PageController();

  CategoryModel? selectedCategory;

  void gotAddCategory({required CategoryModel data}){
    intialIndex = 0;
    selectedCategory = data;
    pageController.animateToPage(2, duration: Duration(milliseconds: 400), curve:Curves.easeInOut);
    update();
  }
}