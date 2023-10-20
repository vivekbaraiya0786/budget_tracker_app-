
import 'package:budget_tracker_app/components/add_spending_page.dart';
import 'package:budget_tracker_app/components/spending_page.dart';
import 'package:budget_tracker_app/controller/controller.dart';
import 'package:flutter/material.dart';
import '../../components/category_page.dart';
import '../../components/add_category_page.dart';
import 'package:get/get.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {

  NavigationController navigationController = Get.put(NavigationController());
  final List<Widget> _pages = [
    const spending_page(),
    const add_spending_page(),
    const categoryPage(),
    const Add_category_page(),
  ];

  void onDestinationSelected(int index) {
    setState(() {
      navigationController.intialIndex = index;
      navigationController.pageController.animateToPage(index,curve:Curves.bounceInOut,duration: const Duration(milliseconds: 300));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: navigationController.pageController,
        onPageChanged: (value) {
          setState(() {
            navigationController.intialIndex = value;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationController.intialIndex,
        onDestinationSelected: onDestinationSelected,
        // height: 80,//height provide for bottom navigationbar
        // indicatorColor: Colors.grey,//provide indicator for icon around
        // backgroundColor: Colors.red,//bottom navigationbar  color change
        // elevation: 10,//elevation provide
        // animationDuration: Duration(seconds: 2),//provide indicator in animation
        // indicatorShape: OutlineInputBorder(),//indicator shape provide
        // labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,//label hide or show using this property
        // shadowColor: Colors.yellow,
        // surfaceTintColor: Colors.deepPurpleAccent,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.money), label: 'Spending'),
          NavigationDestination(icon: Icon(Icons.money), label: 'Add Spending'),
          NavigationDestination(icon: Icon(Icons.category_outlined), label: 'Category'),
          NavigationDestination(icon: Icon(Icons.category_outlined), label: 'Add Category'),
        ],
      ),
    );
  }
}
