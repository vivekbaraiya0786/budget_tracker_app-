import 'package:budget_tracker_app/controller/controller.dart';
import 'package:budget_tracker_app/modals/category_model.dart';
import 'package:budget_tracker_app/utils/helpers/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Add_category_page extends StatefulWidget {
  const Add_category_page({Key? key}) : super(key: key);

  @override
  State<Add_category_page> createState() => _Add_category_pageState();
}

class _Add_category_pageState extends State<Add_category_page> {
  NavigationController navigationController = Get.find<NavigationController>();
  late Future<List<CategoryModel>> getAllCategories;

  @override
  void initState() {
    super.initState();
    getAllCategories = DBHelper.dbHelper.fetchALlCategories();
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
                      hintText: "Search here...."
                    ),
                    onChanged: (value) async {
                      setState(() {
                        getAllCategories =
                            DBHelper.dbHelper.fetchSearchCategories(data: value);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: FutureBuilder(
                  future: getAllCategories,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("ERROR ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      List<CategoryModel>? data = snapshot.data;

                      if (data == null || data.isEmpty) {
                        return const Center(
                          child: Text("No Data available"),
                        );
                      } else {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Image.memory(data[index].categoryImage),
                              title: Text("${data[index].categoryName}"),
                              trailing: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Get.dialog(
                                        AlertDialog(
                                          title: const Center(
                                            child: Text(
                                              "Delete category",
                                            ),
                                          ),
                                          content: const Text(
                                              "Are you sure you want to delete this category?"),
                                          actions: [
                                            OutlinedButton(
                                              onPressed: () async {
                                                int res = await DBHelper.dbHelper
                                                    .deleteCategory(
                                                  id: data[index].categoryId!,
                                                );
                                                if (res == 1) {
                                                  setState(() {
                                                    getAllCategories = DBHelper
                                                        .dbHelper
                                                        .fetchALlCategories();
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
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      navigationController.gotAddCategory(
                                          data: data[index]);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                ],
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
