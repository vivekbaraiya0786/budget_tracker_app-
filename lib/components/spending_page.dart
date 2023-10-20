   import 'package:budget_tracker_app/modals/category_model.dart';
import 'package:budget_tracker_app/modals/spending_modal.dart';
import 'package:budget_tracker_app/utils/helpers/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class spending_page extends StatefulWidget {
  const spending_page({Key? key}) : super(key: key);

  @override
  State<spending_page> createState() => _spending_pageState();
}

class _spending_pageState extends State<spending_page> {
  GlobalKey<FormState> spendingformkey = GlobalKey<FormState>();
  TextEditingController desccontroller = TextEditingController();
  TextEditingController amountcontoller = TextEditingController();

  DateTime intialDate = DateTime.now();
  TimeOfDay initalTime = TimeOfDay.now();

  String? desc;
  num? amount;
  String? spendingMode;
  DateTime? date;
  TimeOfDay? time;
  String? spendingType;
  int? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Form(
            key: spendingformkey,
            child: Column(
              children: [
                TextFormField(
                  controller: desccontroller,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter desc here....",
                    labelText: "Description",
                  ),
                  validator: (value) =>
                      (value!.isEmpty) ? "Enter desc first... " : null,
                  onSaved: (newValue) {
                    desc = newValue;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: amountcontoller,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter total amount here....",
                    labelText: "Amount",
                  ),
                  validator: (value) =>
                      (value!.isEmpty) ? "Enter desc first... " : null,
                  onSaved: (newValue) {
                    amount = num.parse(newValue!);
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text("Spending Mode : "),
                    const SizedBox(
                      width: 14,
                    ),
                    DropdownButton(
                      value: spendingMode,
                      hint: const Text("Choose spending mode."),
                      items: const [
                        DropdownMenuItem(
                          value: "Online",
                          child: Text("Online"),
                        ),
                        DropdownMenuItem(
                          value: "Offline",
                          child: Text("Offline"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          spendingMode = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text("Spending Mode : "),
                    const SizedBox(
                      width: 14,
                    ),
                    Radio(value: "Expenses", groupValue: spendingType, onChanged: (value) {
                      setState(() {
                        spendingType = value;
                      });
                    },),
                    const Text("Expenses"),
                    Radio(value: "Income", groupValue: spendingType, onChanged: (value) {
                      setState(() {
                        spendingType = value;
                      });
                    },),
                    const Text("Income"),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text("Pick Date"),
                    IconButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: intialDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(3000),
                        );
                        setState(() {
                          date = pickedDate;
                        });
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                    (date == null)
                        ? Container()
                        : Text("${date!.day} : ${date!.month} : ${date!.year}")
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text("Pick Time"),
                    IconButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: initalTime,
                        );
                        setState(() {
                          time = pickedTime;
                        });
                      },
                      icon: const Icon(Icons.timelapse_outlined),
                    ),
                    (time == null)
                        ? Container()
                        : (time == null)
                            ? (initalTime.hour >= 12)
                                ? Text(
                                    "${initalTime.hour - 12} : ${initalTime.minute}  ${initalTime.period.name}")
                                : Text(
                                    "${initalTime.hour} : ${initalTime.minute}  ${initalTime.period.name}")
                            : (time!.hour > 12)
                                ? Text(
                                    "${time!.hour - 12} : ${time!.minute} ${time!.period.name}")
                                : Text(
                                    "${time!.hour} : ${time!.minute} ${time!.period.name}"),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder(
                    future: DBHelper.dbHelper.fetchALlCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("ERROR : ${snapshot.error}");
                      } else if (snapshot.hasData) {


                        List<CategoryModel>? data = snapshot.data;

                        return (data == null || data.isEmpty)
                            ? const Center(
                                child: Text("No categories avaiable"),
                              )
                            : GridView.builder(
                                itemCount: data.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        selectedCategory = index;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: (selectedCategory == index)
                                              ? Colors.black
                                              : Colors.transparent,
                                        ),
                                        image: DecorationImage(
                                            image: MemoryImage(
                                                data[index].categoryImage),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  );
                                },
                              );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),

                FloatingActionButton.extended(
                  onPressed: () async{

                    if(spendingformkey.currentState!.validate()){
                      spendingformkey.currentState!.save();

                     SpendingModel spendingmodel = SpendingModel(
                       spendingDesc: desc!,
                       spendingAmount: amount!,
                       spendingMode: spendingMode!,
                       spendingType: spendingType!,
                       spendingDate: "${date!.day} : ${date!.month} : ${date!.year}",
                       spendingTime: "${time!.hour}:${time!.minute}",
                       spendingCategory: selectedCategory!,
                     );
                      int res =
                      await DBHelper.dbHelper.insertspenging(data: spendingmodel);

                      if (res >= 1) {
                        Get.snackbar("Successfully", "spending with id $res insert Successfully",
                            backgroundColor: Colors.green);
                      } else {
                        Get.snackbar(
                            "unSuccessfully", "spending with id $res insert unSuccessfully",
                            backgroundColor: Colors.red);
                      }
                      desccontroller.clear();
                      amountcontoller.clear();
                      setState(() {
                        desc = null;
                        amount = null;
                        spendingMode = null;
                        spendingType = null;
                        date = null;
                        time = null;
                        selectedCategory = null;
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
