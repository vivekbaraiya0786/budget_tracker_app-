import 'package:budget_tracker_app/controller/controller.dart';
import 'package:budget_tracker_app/modals/category_model.dart';
import 'package:budget_tracker_app/modals/spending_modal.dart';
import 'package:budget_tracker_app/utils/helpers/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class add_spending_page extends StatefulWidget {
  const add_spending_page({Key? key}) : super(key: key);

  @override
  State<add_spending_page> createState() => _add_spending_pageState();
}

class _add_spending_pageState extends State<add_spending_page> {
  NavigationController navigationController = Get.find<NavigationController>();
  late Future<List<SpendingModel>> getAllspending;

  @override
  void initState() {
    super.initState();
    getAllspending = DBHelper.dbHelper.fetchALlSpending();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Search here...."),
                    onChanged: (value) async {
                      setState(() {
                        getAllspending =
                            DBHelper.dbHelper.fetchSearchspending(data: value);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: FutureBuilder(
                  future: getAllspending,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("ERROR ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      List<SpendingModel>? data = snapshot.data;

                      if (data == null || data.isEmpty) {
                        return const Center(
                          child: Text("No Data available"),
                        );
                      } else {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                height: Get.height * 0.2,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: (data[index].spendingType == "Expenses")
                                      ? Colors.red
                                      : Colors.green,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[index].spendingDesc,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${data[index].spendingAmount}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: Get.height * 0.01,
                                            ),
                                            Text(
                                              data[index].spendingDate,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              data[index].spendingTime,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        FutureBuilder(
                                          future: DBHelper.dbHelper
                                              .fetchSearchCategory(
                                            id: data[index].spendingCategory,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text("ERROR ${snapshot.error}"),
                                              );
                                            } else if (snapshot.hasData) {
                                              List<CategoryModel>? data = snapshot.data;

                                            return (data == null || data.isEmpty)
                                                ?Text("No Data available")
                                                :Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: MemoryImage(
                                                    data[0].categoryImage,
                                                  )
                                                )
                                              ),
                                            );
                                            }
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          },
                                        ),
                                        ActionChip(label: Text(data[index].spendingMode),onPressed: () {

                                        },),
                                        Spacer(),
                                        IconButton(onPressed: () {
                                          Get.dialog(
                                            AlertDialog(
                                              title: const Center(
                                                child: Text(
                                                  "Delete spending",
                                                ),
                                              ),
                                              content: const Text(
                                                  "Are you sure you want to delete this spending?"),
                                              actions: [
                                                OutlinedButton(
                                                  onPressed: () async {
                                                    int res = await DBHelper.dbHelper
                                                        .deleteSpending(
                                                      id: data[index].spendingId!,
                                                    );
                                                    if (res == 1) {
                                                      setState(() {
                                                        getAllspending = DBHelper
                                                            .dbHelper
                                                            .fetchALlSpending();
                                                      });
                                                      Get.back();
                                                      Get.snackbar(
                                                        "Successfully",
                                                        "Successfully deleted",
                                                        backgroundColor: Colors.green,
                                                      );
                                                    } else {
                                                      Get.back();
                                                      Get.snackbar(
                                                        snackPosition: SnackPosition.BOTTOM,
                                                        "Unsuccessfully",
                                                        "Failed to delete",
                                                        backgroundColor: Colors.red,
                                                      );
                                                    }
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text("No"),
                                                ),
                                              ],
                                            ),
                                            barrierDismissible: false,
                                          );
                                        }, icon: Icon(Icons.delete),),
                                        IconButton(onPressed: () {

                                        }, icon: Icon(Icons.edit),),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: data.length,
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
// IconButton(
// onPressed: () {
// Get.dialog(
// AlertDialog(
// title: const Center(
// child: Text(
// "Delete category",
// ),
// ),
// content: const Text(
// "Are you sure you want to delete this category?"),
// actions: [
// OutlinedButton(
// onPressed: () async {
// int res = await DBHelper.dbHelper
//     .deleteCategory(
// id: data[index].spendingId!,
// );
// if (res == 1) {
// setState(() {
// getAllspending = DBHelper
//     .dbHelper
//     .fetchALlSpending();
// });
// Get.back();
// Get.snackbar(
// "Successfully",
// "Successfully deleted",
// backgroundColor: Colors.green,
// );
// } else {
// Get.back();
// Get.snackbar(
// snackPosition: SnackPosition.BOTTOM,
// "Unsuccessfully",
// "Failed to delete",
// backgroundColor: Colors.red,
// );
// }
// },
// child: const Text("Yes"),
// ),
// OutlinedButton(
// onPressed: () {
// Get.back();
// },
// child: const Text("No"),
// ),
// ],
// ),
// barrierDismissible: false,
// );
// },
// icon: const Icon(Icons.delete),
// ),
// IconButton(
// onPressed: () {
// // navigationController.gotAddCategory(
// //     data: data[index]);
// },
// icon: const Icon(Icons.edit),
// ),
