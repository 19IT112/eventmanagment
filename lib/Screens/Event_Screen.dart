import 'package:eventmanagment/models/event.dart';
import 'package:eventmanagment/widgets/event_add_page.dart';
import 'package:eventmanagment/widgets/event_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);
  // static const routeName = 'EventScreen';

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  var isinit = true;
  var isloading = false;
  var role;
  var uid;

  @override
  void didChangeDependencies() {
    // CollectionReference _user = FirebaseFirestore.instance.collection("users");

    if (isinit) {
      // final email = Provider.of<Auth>(context).auth.currentUser!.email;
      uid = Provider.of<Auth>(context).auth.currentUser!.uid;
      setState(() {
        isloading = true;
      });

      Provider.of<Events>(context).fetchEvent().then((_) {
        setState(() {
          isloading = false;
        });
      });
      Provider.of<Auth>(context).userRole().then((value) {
        setState(() {
          role = value;
        });
      });
    }
    setState(() {
      isinit = false;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Event App'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<Auth>(context, listen: false).logout();
              print(uid);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body:
          isloading ? Center(child: CircularProgressIndicator()) : EventGrid(),
      floatingActionButton: role == 'Admin'
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushNamed(AddEventPage.routeName);
              },
              label: Row(children: [Icon(Icons.add), Text("Add Event")]),
            )
          : null,
    );
  }
}
