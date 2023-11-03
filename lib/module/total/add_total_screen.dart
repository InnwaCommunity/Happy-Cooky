import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/config/routes.dart';
import 'package:new_project/config/shared_pref.dart';
import 'package:new_project/config/tools.dart';
import 'package:new_project/models/total_balance_model.dart';
import 'package:new_project/services/firebase_service.dart';
import 'package:new_project/services/sqlite_services.dart';
import 'dart:developer' as dev;

class AddTotalScreen extends StatefulWidget {
  const AddTotalScreen({super.key});

  @override
  State<AddTotalScreen> createState() => _AddTotalScreenState();
}

class _AddTotalScreenState extends State<AddTotalScreen> {
  TextEditingController totalBalanceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<String> items = ['Today', 'Week', 'Month', 'Custom'];
  String selectedOption = 'Month';
  final db = SqliteService.instance;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    fromDate = DateTime(now.year, now.month, 1);
    toDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  }

  @override
  void dispose() {
    super.dispose();
    totalBalanceController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Total Balance'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: ElevatedButton(
                    onPressed: () {
                      String time = Tools.ymdhmsDateFormat();
                      TotalBalanceModel totalBalanceModel = TotalBalanceModel(
                          totalbalance: Tools.removeCommaSeparator(
                              totalBalanceController.text),
                          totaldes: descriptionController.text,
                          insertdate: time,
                          starttimerangedate: formatter.format(fromDate),
                          endtimerangedate: formatter.format(toDate),
                          sharestatus: 'true');
                      dev.log(
                          'Total Balance Model : ${totalBalanceModel.toMap()}');
                      db.saveTotalBalance(totalBalanceModel);
                      SharedPref.setTotalBalance(
                          totalBalance: double.parse(Tools.removeCommaSeparator(
                              totalBalanceController.text)));
                      FirebaseService()
                          .saveTotalBalanceToFirebase(totalBalanceModel);
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                              padding: const EdgeInsets.only(left: 12),
                              color: Colors.white,
                              height: 50,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Time Range",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(width: 5),
                        if (items.isNotEmpty)
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DropdownButton<String>(
                                    value: selectedOption,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black87,
                                    ),
                                    elevation: 2,
                                    underline: Container(),
                                    hint: const SizedBox(
                                      width: 150,
                                    ),
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black87),
                                    items: items.map((String item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) async {
                                      selectedOption = newValue!;
                                      updateDateRange(selectedOption);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (selectedOption == 'Custom')
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: fromDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  fromDate = selectedDate;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration:
                                  buildDatePickerInputDecoration('From'),
                              child: Text(
                                '${fromDate.toLocal()}'.split(' ')[0],
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: toDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  toDate = selectedDate.add(const Duration(
                                      hours: 23, minutes: 59, seconds: 59));
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: buildDatePickerInputDecoration('To'),
                              child: Text(
                                '${toDate.toLocal()}'.split(' ')[0],
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  buildInputFieldRow(
                      'Total Balance', totalBalanceController, 45),
                  buildInputFieldRow('Description', descriptionController, 100),
                ])));
  }

  void updateDateRange(String option) {
    final now = DateTime.now();
    if (option == 'Today') {
      fromDate = DateTime(now.year, now.month, now.day);
      toDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else if (option == 'This Week') {
      final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
      fromDate = DateTime(
          firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
      toDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else if (option == 'This Month') {
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      fromDate = firstDayOfMonth;
      toDate = lastDayOfMonth;
    }
  }

  Widget buildInputFieldRow(
      String label, TextEditingController controller, double height) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              color: Colors.white,
              height: 45,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.only(right: 12),
              color: Colors.white,
              height: height,
              child: TextFormField(
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
                controller: controller,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.only(left: 5),
                  hintText: label,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (controller.text == '' ||
                      double.parse(
                              Tools.removeCommaSeparator(controller.text)) <=
                          0) {
                    controller.clear();
                  }
                },
                onTap: () {
                  if (controller.text == '' ||
                      double.parse(
                              Tools.removeCommaSeparator(controller.text)) <=
                          0) {
                    controller.clear();
                  } else {
                    setState(() {
                      controller.text = double.parse(
                              Tools.removeCommaSeparator(controller.text))
                          .toInt()
                          .toString();
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration buildDatePickerInputDecoration(String hint) {
    return InputDecoration(
      border: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      isDense: true,
      labelText: hint,
      hintText: hint,
      prefixIcon: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.calendar_month,
            color: Colors.blueAccent,
            size: 20,
          ),
          SizedBox(width: 10),
        ],
      ),
      prefixIconConstraints: const BoxConstraints(
        minHeight: 10,
        minWidth: 10,
      ),
      filled: true,
      fillColor: Colors.transparent,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
    );
  }
}
