import 'package:eventmanagment/Screens/upload_pdf_screen.dart';
import 'package:eventmanagment/models/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatelessWidget {
  static const routeName = 'EventDetailSceern';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final event = Provider.of<Events>(context, listen: false).findById(id);
    final date = DateFormat.yMMMd().format(event.dateTime);
    final time = DateFormat.Hm().format(event.selectTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Location: " + event.location,
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Date: " + date,
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Description: " + event.description,
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Event Start Time: " + time,
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(UploadPdfScreen.routeName);
              },
              child: Text(
                "Book Now",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
