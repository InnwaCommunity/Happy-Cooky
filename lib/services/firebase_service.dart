import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_project/models/menu_item.dart';
import 'package:new_project/models/total_balance_model.dart';
import 'dart:developer' as dev;

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> saveTotalBalanceToFirestore(TotalBalanceModel record) async {
    try {
      await _firestore.collection('total_balance').add(record.toMap());
      dev.log('Save Success ### ');
      return true;
    } catch (error) {
      dev.log('Error in save total balance: $error');
      return false;
    }
  }

  Future<bool> saveMenuItemToFirebase(MenuItem menuItem) async {
    try {
      await _firestore.collection('menu_item').add(menuItem.toMap());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<TotalBalanceModel>> fetchTotalBalanceFromFirestore() async {
    try {
      final querySnapshot = await _firestore.collection('total_balance').get();
      final totalBalanceList = querySnapshot.docs
          .map((document) => TotalBalanceModel.fromMap(document.data()))
          .toList();
      dev.log(totalBalanceList.toString());
      return totalBalanceList;
    } catch (error) {
      dev.log('Error in fetching total balance: $error');
      return [];
    }
  }

  Future<List<MenuItem>> fetchMenuItemsFromFirebase(
      {required String insertdate}) async {
    try {
      final querySnapshot = await _firestore
          .collection('menu_item')
          .where('menuitemdate', isEqualTo: insertdate)
          .get();
      final totalBalanceList = querySnapshot.docs
          .map((document) => MenuItem.fromMap(document.data()))
          .toList();
      return totalBalanceList;
    } catch (error) {
      dev.log('Error in fetching total balance: $error');
      return [];
    }
  }

  Future<bool> updateTotalBalanceInFirestore(
      TotalBalanceModel updatedRecord) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('total_balance')
          .where('totalbalanceid', isEqualTo: updatedRecord.totalbalanceid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference documentReference =
            querySnapshot.docs.first.reference;
        await documentReference.update(updatedRecord.toMap());

        dev.log('Update Success ### ');
        return true;
      } else {
        dev.log(
            'Document with insertdate ${updatedRecord.totalbalanceid} not found');
        return false;
      }
    } catch (error) {
      dev.log('Error in update total balance: $error');
      return false;
    }
  }

  Future<bool> updateMenuItemInFirestore(
      String documentId, MenuItem menuItem) async {
    try {
      await _firestore
          .collection('menu_item')
          .doc(documentId)
          .update(menuItem.toMap());
      dev.log('Update Success ### ');
      return true;
    } catch (error) {
      dev.log('Error in update total balance: $error');
      return false;
    }
  }
}
