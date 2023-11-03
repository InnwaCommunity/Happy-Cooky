import 'package:firebase_database/firebase_database.dart';
import 'package:new_project/models/menu_item.dart';
import 'package:new_project/models/total_balance_model.dart';
import 'dart:developer' as dev;

class FirebaseService {
  final DatabaseReference _totalBalanceReference =
      FirebaseDatabase.instance.ref().child('total_balance');
  final DatabaseReference _menuItemReference =
      FirebaseDatabase.instance.ref().child('menu_item');

  Future<bool> saveTotalBalanceToFirebase(TotalBalanceModel record) async {
    try {
      await _totalBalanceReference.push().set(record.toMap()).then((value) {
        dev.log('Save Success ### ');
      }).onError((error, stackTrace) {
        dev.log('Error in save total balance  $error');
      });
      return true;
    } catch (error) {
      dev.log('Error in save total balance  $error');
      return false;
    }
  }

  Future<bool> saveMenuItemToFirebase(MenuItem menuItem) async {
    try {
      await _menuItemReference.push().set(menuItem.toMap());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<TotalBalanceModel>> fetchTotalBalanceFromFirebase(
      String userDate) async {
    try {
      DataSnapshot snapshot = await _totalBalanceReference.get();
      Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?;

      List<TotalBalanceModel> totalBalanceList = [];

      if (data != null) {
        data.forEach((key, value) {
          TotalBalanceModel totalBalance = TotalBalanceModel.fromMap(value);
          if (totalBalance.insertdate == userDate) {
            totalBalanceList.add(totalBalance);
          }
        });
      }

      return totalBalanceList;
    } catch (error) {
      print('Error fetching total balance data from Firebase: $error');
      return [];
    }
  }

  Future<List<MenuItem>> fetchMenuItemsFromFirebase(String userDate) async {
    try {
      DataSnapshot snapshot = await _menuItemReference.get();
      Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?;
      List<MenuItem> menuItemList = [];

      if (data != null) {
        data.forEach((key, value) {
          MenuItem menuItem = MenuItem.fromMap(value);
          if (menuItem.menuitemdate == userDate) {
            menuItemList.add(menuItem);
          }
        });
      }

      return menuItemList;
    } catch (error) {
      print('Error fetching menu items data from Firebase: $error');
      return [];
    }
  }
}
