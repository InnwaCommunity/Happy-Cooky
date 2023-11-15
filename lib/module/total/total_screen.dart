import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/config/network_info.dart';
import 'package:new_project/config/shared_pref.dart';
import 'package:new_project/config/tools.dart';
import 'package:new_project/models/total_balance_model.dart';
import 'package:new_project/services/firebase_service.dart';
import 'package:new_project/services/sqlite_services.dart';
import 'dart:developer' as dev;

import 'package:uuid/uuid.dart';

class TotalScreen extends StatefulWidget {
  const TotalScreen({Key? key}) : super(key: key);

  @override
  State<TotalScreen> createState() => _TotalScreenState();
}

class _TotalScreenState extends State<TotalScreen> {
  TextEditingController totalBalanceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TotalBalanceModel> totalBalanceList = [];
  final db = SqliteService.instance;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');
  var uuid = const Uuid();

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    final now = DateTime.now();
    fromDate = DateTime(now.year, now.month, 1);
    toDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    NetworkInfo networkInfo = NetworkInfo(Connectivity());
    bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      await FirebaseService().fetchTotalBalanceFromFirestore().then((value) {
        totalBalanceList = value;
        setState(() {});
      });
    } else {
      totalBalanceList = await db.getTotalBalanceList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                  child: const Text('10000 Ks'),
                ),
              ),
            ),
          )
        ],
      ),
      body: totalBalanceList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              controller: ScrollController(),
              itemCount: totalBalanceList.length,
              itemBuilder: (BuildContext context, int index) {
                return makeCard(
                  totalBalanceList[index],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          totalBalanceController.clear();
          descriptionController.clear();
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return addOrEditBalanceWidget();
              });
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  String formatDateToCustomFormat(String dateString) {
    DateTime date = DateTime.parse(dateString);
    DateFormat customFormat = DateFormat('MMM d');
    String formattedDate = customFormat.format(date);
    return formattedDate;
  }

  Widget makeCard(TotalBalanceModel totalBalanceModel) {
    return Card(
      elevation: 5,
      color: totalBalanceModel.sharestatus != "true" ? Colors.blue : null,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '+${totalBalanceModel.totalbalance}',
                  style: const TextStyle(
                    fontSize: 45,
                  ),
                ),
                const Text(
                  ' Ks',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  border: Border.all(color: Colors.white),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              onTap: () {
                totalBalanceController.text = totalBalanceModel.totalbalance;
                descriptionController.text = totalBalanceModel.totaldes;
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return addOrEditBalanceWidget(
                          datamodel: totalBalanceModel);
                    });
              },
            )
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    totalBalanceModel.insertdate,
                  ),
                  Row(
                    children: [
                      Text(
                        formatDateToCustomFormat(
                            totalBalanceModel.starttimerangedate),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Icon(
                        Icons.swap_horiz,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        formatDateToCustomFormat(
                            totalBalanceModel.endtimerangedate),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                totalBalanceModel.totaldes,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addOrEditBalanceWidget({TotalBalanceModel? datamodel}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'New Balance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: widget.key,
            child: SingleChildScrollView(
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: totalBalanceController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Total Balance',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (totalBalanceController.text == '' ||
                            double.parse(Tools.removeCommaSeparator(
                                    totalBalanceController.text)) <=
                                0) {
                          totalBalanceController.clear();
                        }
                      },
                      onTap: () {
                        if (totalBalanceController.text == '' ||
                            double.parse(Tools.removeCommaSeparator(
                                    totalBalanceController.text)) <=
                                0) {
                          totalBalanceController.clear();
                        } else {
                          setState(() {
                            totalBalanceController.text = double.parse(
                                    Tools.removeCommaSeparator(
                                        totalBalanceController.text))
                                .toInt()
                                .toString();
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      maxLines: 5,
                      minLines: 3,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Description',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () {
                          if (datamodel == null) {
                            String time = Tools.ymdhmsDateFormat();
                            TotalBalanceModel totalBalanceModel =
                                TotalBalanceModel(
                                    totalbalanceid: uuid.v4(),
                                    totalbalance: Tools.removeCommaSeparator(
                                        totalBalanceController.text),
                                    totaldes: descriptionController.text,
                                    insertdate: time,
                                    starttimerangedate:
                                        formatter.format(fromDate),
                                    endtimerangedate: formatter.format(toDate),
                                    sharestatus: 'true');
                            dev.log(
                                'Total Balance Model : ${totalBalanceModel.toMap()}');
                            db.saveTotalBalance(totalBalanceModel);
                            SharedPref.setTotalBalance(
                                totalBalance: double.parse(
                                    Tools.removeCommaSeparator(
                                        totalBalanceController.text)));
                            FirebaseService()
                                .saveTotalBalanceToFirestore(totalBalanceModel);
                          } else {
                            TotalBalanceModel totalBalanceModel =
                                TotalBalanceModel(
                                    totalbalanceid: datamodel.totalbalanceid,
                                    totalbalance: Tools.removeCommaSeparator(
                                        totalBalanceController.text),
                                    totaldes: descriptionController.text,
                                    insertdate: datamodel.insertdate,
                                    starttimerangedate:
                                        datamodel.starttimerangedate,
                                    endtimerangedate:
                                        datamodel.endtimerangedate,
                                    sharestatus: 'true');
                            dev.log(
                                'Total Balance Model : ${totalBalanceModel.toMap()}');
                            // db.saveTotalBalance(totalBalanceModel);
                            SharedPref.setTotalBalance(
                                totalBalance: double.parse(
                                    Tools.removeCommaSeparator(
                                        totalBalanceController.text)));
                            // FirebaseService()
                            //     .saveTotalBalanceToFirestore(totalBalanceModel);
                            FirebaseService().updateTotalBalanceInFirestore(
                                totalBalanceModel);
                          }
                          getData();
                          Navigator.of(context).pop();
                        },
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.blueAccent,
                        child: Text(
                          "Add Balance".toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
