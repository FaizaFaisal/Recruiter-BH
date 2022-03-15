import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job_search_app/shared/screens.dart';

class CheckRole extends StatefulWidget {
  const CheckRole({Key? key}) : super(key: key);

  @override
  _CheckRoleState createState() => _CheckRoleState();
}

class _CheckRoleState extends State<CheckRole> {
  final storage = new FlutterSecureStorage();
  Future<String> checkRoleStatus() async {
    String? value = await storage.read(key: "role");
    if (value == "Seeker") {
      // Not logged in and then check role
      return "Seeker";
    }
    return "Employer";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkRoleStatus(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        print("Snapshot \t ${snapshot.data}");
        if (snapshot.data == "Seeker") {
          return FlutterZoomDrawerDemo();
        }
        if (snapshot.data == "Employer") {
          return NavZoomDrawer();
        }
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Container(
        //     color: Colors.white,
        //     width: MediaQuery.of(context).size.width,
        //     height: MediaQuery.of(context).size.height,
        //     child: Center(
        //       child: CircularProgressIndicator(
        //         color: Colors.blueAccent.shade700,
        //       ),
        //     ),
        //   );
        // }
        return Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent.shade700,
            ),
          ),
        );
      },
    );
  }
}
