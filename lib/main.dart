import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:job_search_app/screens/check_role.dart';
import 'package:job_search_app/shared/screens.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final storage = new FlutterSecureStorage();
  Future<bool> checkLoginStatus() async {
    String? value = await storage.read(key: "uid");
    if (value == null) {
      // Not logged in
      return false;
    }
    return true; //Logged In
  }

  @override
  Widget build(BuildContext context) {
    // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => GoogleSignInController(),
              child: LoginPage(),
            )
          ],
          child: MaterialApp(
            routes: {},
            debugShowCheckedModeBanner: false,
            title: 'Job Search',
            theme: ThemeData(
              textTheme:
                  GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: Brightness.light,
              primaryColor: AppColor.welcomeImageContainer,
              primaryColorBrightness: Brightness.light,
              // accentColor: Colors.white.withOpacity(1),
              // accentColorBrightness: Brightness.light),
            ),
            home: FutureBuilder(
                future: checkLoginStatus(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  // not LoggedIn
                  if (snapshot.data == true) {
                    return CheckRole();
                  }
                  return WelcomeScreen(); // Login UI
                }),
          ),
        );
      },
    );
  }
}
