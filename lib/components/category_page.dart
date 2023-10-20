import 'package:budget_tracker_app/controller/controller.dart';
import 'package:budget_tracker_app/modals/category_model.dart';
import 'package:budget_tracker_app/utils/helpers/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class categoryPage extends StatefulWidget {
  const categoryPage({Key? key}) : super(key: key);

  @override
  State<categoryPage> createState() => _categoryPageState();
}

class _categoryPageState extends State<categoryPage> {
  List<String> cat_images = [
    "assets/images/bill.png",
    "assets/images/cash.png",
    "assets/images/communication.png",
    "assets/images/deposit.png",
    "assets/images/food.png",
    "assets/images/gift.png",
    "assets/images/health.png",
    "assets/images/other.png",
    "assets/images/rupee.png",
    "assets/images/salary.png",
    "assets/images/shopping.png",
    "assets/images/transport.png",
    "assets/images/wallet.png",
    "assets/images/withdraw.png",
  ];

  final GlobalKey<FormState> catFormKey = GlobalKey<FormState>();
  TextEditingController catnameController = TextEditingController();
  int? selectCatImage;
  String? catname;
  ByteData? imgByteData;

  NavigationController navigationController = Get.find<NavigationController>();

  @override
  void initState() {
    super.initState();
    catnameController.text = (navigationController.selectedCategory == null)
    ? ""
        :navigationController.selectedCategory!.categoryName;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: catFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Cat_Name",
                    hintText: "Enter category name here..",
                  ),
                  controller: catnameController,
                  validator: (value) =>
                      (value!.isEmpty) ? "Enter category name first" : null,
                  onSaved: (newValue) {
                    catname = newValue;
                  },
                ),
                const SizedBox(height: 15),
                const Text("Category Images :"),
                const SizedBox(height: 15),
                Expanded(
                  child: GridView.builder(
                    itemCount: cat_images.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          imgByteData = await rootBundle.load(cat_images[index]);
                          selectCatImage = index;
                          setState(() {
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: (selectCatImage == index)
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                            image: DecorationImage(
                              image: AssetImage(cat_images[index]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                FloatingActionButton.extended(
                  onPressed: () async{
                    Uint8List imgBytes = (imgByteData != null)
                    ?Uint8List.fromList(imgByteData!.buffer.asInt8List())
                        :Uint8List(0);
                   if(catFormKey.currentState!.validate()){
                     catFormKey.currentState!.save();

                     CategoryModel categorymodel = CategoryModel(categoryName: catname!, categoryImage: imgBytes);
                     int res =
                     await DBHelper.dbHelper.insertCategory(data: categorymodel);

                     print(imgBytes);
                     if (res >= 1) {
                       Get.snackbar("Succefully", "Succefully id $res insert",
                           backgroundColor: Colors.green);
                     } else {
                       Get.snackbar(
                           "unSuccefully", "unSuccefully id $res insert",
                           backgroundColor: Colors.red);
                     }
                     catnameController.clear();
                     setState(() {
                       catname = null;
                       selectCatImage = null;
                     });
                   }
                  },
                  label: const Text("Add"),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
