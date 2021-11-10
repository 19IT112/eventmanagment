import 'dart:async';

import 'package:date_count_down/countdown.dart';
import 'package:eventmanagment/Screens/event_details_screen.dart';
import 'package:eventmanagment/models/auth.dart';
import 'package:eventmanagment/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late Timer _timer;
  var docid;
  var uid;
  var role, eventrole;
  var _isloading = false;
  var init = true;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (init) {
      docid = Provider.of<Event>(context).docid;
      uid = Provider.of<Auth>(context).auth.currentUser!.uid;

      eventrole =
          Provider.of<Auth>(context, listen: false).userRole().then((value) {
        setState(() {
          role = value;
        });
      });
      super.didChangeDependencies();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _deleteEvent() async {
    try {
      setState(() {
        _isloading = true;
      });
      await Provider.of<Events>(context, listen: false)
          .deleteEvent(docid, uid)
          .then((_) {
        setState(() {
          _isloading = false;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void navi() {}

  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Event>(context, listen: false);

    final String dateCountDown = CountDown()
        .timeLeft(DateTime.parse(event.dateTime.toString()), "Event Done");
    return GestureDetector(
      onTap: role == 'User'
          ? () {
              Navigator.of(context)
                  .pushNamed(EventDetailScreen.routeName, arguments: docid);
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(
            dateCountDown,
            style: TextStyle(fontSize: 25, wordSpacing: 10),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                event.location,
              )
            ],
          ),
          trailing: role == 'Admin'
              ? IconButton(
                  icon: _isloading
                      ? CircularProgressIndicator()
                      : Icon(Icons.delete),
                  onPressed: _deleteEvent,
                )
              : null,
        ),
      ),
    );
  }
}
