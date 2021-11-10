import 'package:eventmanagment/Screens/Event_Screen.dart';
import 'package:eventmanagment/Screens/event_details_screen.dart';
import 'package:eventmanagment/models/userInfo.dart';
import 'package:eventmanagment/widgets/event_add_page.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:eventmanagment/models/auth.dart';
import 'package:eventmanagment/models/uploadPDf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class UploadPdfScreen extends StatefulWidget {
  static const routeName = 'UploadPdfScreen';
  @override
  State<UploadPdfScreen> createState() => UploadPdfScreenstate();
}

class UploadPdfScreenstate extends State<UploadPdfScreen> {
  var uid;
  @override
  void didChangeDependencies() async {
    try {
      uid = Provider.of<Auth>(context, listen: false).auth.currentUser!.uid;
    } catch (e) {
      print(e);
    }
    super.didChangeDependencies();
  }

  var demo;
  File? file;
  String? path;
  var name;
  var destination;

  Future<void> select() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        path = result.files.first.name;

        final filename = path;
        destination = '/$uid/$filename';
      });
    } else {
      // User canceled the picker
      return;
    }
  }

  var _isloading = false;
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _PhoneController = TextEditingController();

  Future<void> uploadPdf(String? path) async {
    if (path != null) {
      try {
        setState(() {
          _isloading = true;
        });
        await Provider.of<UploadPdf>(context, listen: false)
            .uploadfile(destination, file!);

        await Provider.of<UserInfo>(context, listen: false).addUserInfo(
          uid,
          _NameController.text,
          int.parse(_PhoneController.text),
        );

        setState(() {
          _isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You have been Succefully Registered"),
          ),
        );
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Select the Certificate"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Name"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                formFields(
                    context, "Enter Name", _NameController, TextInputType.name),
                const SizedBox(
                  height: 15,
                ),
                formFields(context, "Phone no.", _PhoneController,
                    TextInputType.number),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    select();
                  },
                  child: Text(
                    "Select The Certificate",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  child: Text(
                    path == null ? "Not select file" : file!.path,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  child: _isloading
                      ? CircularProgressIndicator()
                      : TextButton(
                          onPressed: () {
                            uploadPdf(path);
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formFields(BuildContext context, String text,
      TextEditingController controller, TextInputType type) {
    return Container(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(hintText: text),
        keyboardType: type,
      ),
    );
  }
}
