import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_project/models/menu_item.dart';
import 'package:new_project/services/firebase_service.dart';
import 'package:new_project/services/sqlite_services.dart';
import 'package:uuid/uuid.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({Key? key}) : super(key: key);

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _MenuItem {
  TextEditingController menuNameController = TextEditingController();
  TextEditingController menuPriceController = TextEditingController();
  TextEditingController menuDescController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  bool showDesc = false;

  _MenuItem({
    String initialMenuName = '',
    String initialMenuPrice = '',
    String initialMenuDesc = '',
    String initialDateTime = '',
    this.showDesc = false,
  }) {
    menuNameController.text = initialMenuName;
    menuPriceController.text = initialMenuPrice;
    menuDescController.text = initialMenuDesc;
    dateTimeController.text = initialDateTime;
  }
}

class _DateItem {
  DateTime time = DateTime.now();
  bool hideAllMenu = false;
  bool showDeleteBtn = false;

  _DateItem({
    required this.time,
    required this.hideAllMenu,
    required this.showDeleteBtn,
  });
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  List<_DateItem> dateRange = [];
  List<List<_MenuItem>> menuItemsList = [[]];
  final db = SqliteService.instance;
  var uuid = const Uuid();

  void addDay(DateTime dateTime) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    List<MenuItem> menuItemList = await FirebaseService()
        .fetchMenuItemsFromFirebase(insertdate: formattedDate);
    if (menuItemsList.isEmpty) {
      setState(() {
        dateRange.add(_DateItem(
            time: dateTime, hideAllMenu: false, showDeleteBtn: false));
        menuItemsList.add([]);
        menuItemsList[dateRange.length - 1].add(_MenuItem(
          initialMenuName: '',
          initialMenuPrice: '',
          initialMenuDesc: '',
          initialDateTime: formattedDate,
          showDesc: false,
        ));
      });
    } else {
      dateRange.add(
          _DateItem(time: dateTime, hideAllMenu: false, showDeleteBtn: false));
      menuItemsList.add([]);
      for (var menuItem in menuItemList) {
        menuItemsList[dateRange.length - 1].add(_MenuItem(
          initialMenuName: menuItem.menuname,
          initialMenuPrice: menuItem.menuprice,
          initialMenuDesc: menuItem.menudesc,
          initialDateTime: formattedDate,
          showDesc: false,
        ));
      }
    }
  }

  void removeDay(DateTime dateTime) {
    setState(() {
      int indexToRemove = -1;
      for (int i = 0; i < dateRange.length; i++) {
        if (dateRange[i].time == dateTime) {
          indexToRemove = i;
          break;
        }
      }

      if (indexToRemove != -1) {
        dateRange.removeAt(indexToRemove);
        menuItemsList.removeAt(indexToRemove);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    dateRange.add(_DateItem(
        time: DateTime.now(), hideAllMenu: false, showDeleteBtn: false));
    addDay(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Menu'),
        actions: [
          IconButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: dateRange.last.time,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  addDay(selectedDate);
                }
              },
              icon: const Icon(Icons.edit_calendar_outlined)),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  save();
                },
                child: ElevatedButton(
                  onPressed: () {
                    save();
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: dateRange.length,
              itemBuilder: (context, index) {
                final currentDate = dateRange[index].time;
                final hideAllItem = dateRange[index].hideAllMenu;
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(currentDate);
                return Column(
                  children: [
                    Card(
                      elevation: 2,
                      color: Colors.lightBlueAccent,
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formattedDate),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: const Icon(Icons.delete_forever),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                if (dateRange.length > 1)
                                  GestureDetector(
                                    onTap: () {
                                      removeDay(currentDate);
                                    },
                                    child: const Icon(Icons.cancel_rounded),
                                  ),
                                const SizedBox(
                                  width: 5,
                                ),
                                hideAllItem
                                    ? GestureDetector(
                                        child: const Icon(Icons.arrow_drop_up),
                                        onTap: () {
                                          dateRange[index].hideAllMenu =
                                              !dateRange[index].hideAllMenu;
                                          setState(() {});
                                        },
                                      )
                                    : GestureDetector(
                                        child:
                                            const Icon(Icons.arrow_drop_down),
                                        onTap: () {
                                          dateRange[index].hideAllMenu =
                                              !dateRange[index].hideAllMenu;
                                          setState(() {});
                                        },
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: !hideAllItem,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: menuItemsList[index].length,
                          itemBuilder: (context, innerIndex) {
                            final menuItem = menuItemsList[index][innerIndex];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.all(5),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                menuItem.menuNameController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5),
                                              hintText: 'Food Or Vegetables',
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                menuItem.menuPriceController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5),
                                              hintText: 'Price',
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            splashRadius: 1.0,
                                            onPressed: () {
                                              menuItem.showDesc =
                                                  !menuItem.showDesc;
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.blueAccent[100],
                                              size: 30,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: menuItem.showDesc,
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade500),
                                          color: Colors.white,
                                        ),
                                        child: TextField(
                                          controller:
                                              menuItem.menuDescController,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.all(8),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                    Visibility(
                        visible: !hideAllItem,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (menuItemsList[index].length > 1)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      menuItemsList[index].removeLast();
                                    });
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                  ),
                                ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  final formattedDate = DateFormat('yyyy-MM-dd')
                                      .format(currentDate);
                                  setState(() {
                                    menuItemsList[index].add(_MenuItem(
                                      initialMenuName: '',
                                      initialMenuPrice: '',
                                      initialMenuDesc: '',
                                      initialDateTime: formattedDate,
                                      showDesc: false,
                                    ));
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void save() {
    for (int i = 0; i < dateRange.length; i++) {
      final currentDate = dateRange[i].time;
      final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
      for (int j = 0; j < menuItemsList[i].length; j++) {
        final menuItem = menuItemsList[i][j];
        final menuName = menuItem.menuNameController.text;
        final menuPrice = menuItem.menuPriceController.text;
        final menuDesc = menuItem.menuDescController.text;
        String menuid = uuid.v4();
        MenuItem item = MenuItem(
            menuid: menuid,
            menuname: menuName,
            menuprice: menuPrice,
            menudesc: menuDesc,
            menuitemdate: formattedDate,
            shareStatus: "true");
        db.saveMenuItem(item);
        FirebaseService().saveMenuItemToFirebase(item);
      }
    }
  }
}
