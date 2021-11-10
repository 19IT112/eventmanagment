import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class User with ChangeNotifier {
  String id;
  String name;
  int number;

  User({
    required this.id,
    required this.name,
    required this.number,
  });
}

class UserInfo with ChangeNotifier {
  List<User> _items = [];

  List<User> get item {
    return [..._items];
  }

  Future<void> addUserInfo(String id, String name, int number) async {
    CollectionReference _userInfo =
        FirebaseFirestore.instance.collection("Register UserInfo");
    final body = {
      "id": id,
      "name": name,
      "number": number,
    };

    try {
      await _userInfo.add(body);
    } catch (e) {
      print(e);
    }
  }
}
