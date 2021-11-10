import 'package:eventmanagment/Screens/Event_Screen.dart';
import 'package:eventmanagment/Screens/auth_screen.dart';
import 'package:eventmanagment/Screens/event_details_screen.dart';
import 'package:eventmanagment/Screens/upload_pdf_screen.dart';
import 'package:eventmanagment/models/auth.dart';
import 'package:eventmanagment/models/uploadPDf.dart';
import 'package:eventmanagment/models/userInfo.dart';
import 'package:eventmanagment/widgets/event_add_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'models/event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Events>(
          create: (context) => Events(),
        ),
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider<UploadPdf>(
          create: (context) => UploadPdf(),
        ),
        ChangeNotifierProvider<UserInfo>(
          create: (context) => UserInfo(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            home: User(),
            routes: {
              UploadPdfScreen.routeName: (ctx) => UploadPdfScreen(),
              AddEventPage.routeName: (ctx) => AddEventPage(),
              EventDetailScreen.routeName: (ctx) => EventDetailScreen(),
              // EventScreen.routeName: (ctx) => EventScreen(),
            },
          );
        },
      ),
    );
  }
}

class User extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<Auth>(context).authstateChanges,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isloggedin = snapshot.hasData;
          return isloggedin ? EventScreen() : AuthScreen();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
