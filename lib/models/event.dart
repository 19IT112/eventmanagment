import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event with ChangeNotifier {
  String? id;
  String title;
  DateTime dateTime;
  String location;
  String description;
  String docid;
  DateTime selectTime;

  Event({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.description,
    required this.docid,
    required this.selectTime,
  });
}

class Events extends ChangeNotifier {
  List<Event> _items = [
    // Event(
    //   id: 'p1',
    //   title: 'Meetings',
    //   dateTime: DateTime.now(),
    //   location: 'Surat',
    //   description: "The Meeting",
    // ),
    // Event(
    //   id: 'p2',
    //   title: 'Party',
    //   dateTime: DateTime.now(),
    //   location: 'Surat',
    //   description: "The Meeting",
    // ),
  ];

  List<Event> get item {
    return [..._items];
  }

  Event findById(id) {
    return _items.firstWhere((prod) => prod.docid == id);
  }

  Future<void> addEvent(String id, String title, DateTime dateTime,
      String location, String description, DateTime time) async {
    CollectionReference _events =
        FirebaseFirestore.instance.collection("Events");
    final body = {
      "id": id,
      "eventName": title,
      "location": location,
      "Description": description,
      "Date": dateTime,
      "selectTime": time,
    };

    // print(time);

    try {
      await _events.add(body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchEvent() async {
    CollectionReference _events =
        FirebaseFirestore.instance.collection("Events");

    final List<Event> fetchEvents = [];

    try {
      await _events.get().then((value) {
        value.docs.forEach((element) {
          var id = (element['id']);
          var title = element['eventName'];
          Timestamp date = element['Date'];
          var location = element['location'];
          var des = element['Description'];
          var eventid = element.id;
          Timestamp selectTime = element['selectTime'];
          fetchEvents.add(
            Event(
              id: id,
              title: title,
              dateTime: date.toDate(),
              location: location,
              description: des,
              docid: eventid,
              selectTime: selectTime.toDate(),
            ),
          );
          // print(DateFormat.Hm().format(selectTime.toDate()));
        });
      });

      _items = fetchEvents;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteEvent(String docid, String uid) async {
    CollectionReference _events =
        FirebaseFirestore.instance.collection("Events");
    final existingEventIndex =
        _items.indexWhere((element) => element.docid == docid);
    Event? existingProduct = _items[existingEventIndex];

    _items.removeAt(existingEventIndex);
    notifyListeners();
    try {
      await _events.doc(docid).delete();
    } catch (e) {
      print(e);
      _items.insert(existingEventIndex, existingProduct);
      notifyListeners();
    }
  }
}
