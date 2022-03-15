import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/employer/authenticate/employee_login.dart';

class ResetPasswordEmployer extends StatefulWidget {
  const ResetPasswordEmployer({Key? key}) : super(key: key);

  @override
  _ResetPasswordEmployerState createState() => _ResetPasswordEmployerState();
}

class _ResetPasswordEmployerState extends State<ResetPasswordEmployer> {
  final _formKey = GlobalKey<FormState>();

  var newPassword = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 40.0,
                color: Colors.green[900],
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  "Your Password has been changed. Login again !",
                  style: TextStyle(
                      color: Colors.teal[900],
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {}
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => EmployeeLoginScreen()));
  }

  changePasswordUI(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              child: Center(
                child: Stack(
                  children: [
                    Icon(
                      CupertinoIcons.lock_rotation,
                      color: color.AppColor.welcomeImageContainer,
                      size: 150,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                autofocus: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password: ',
                  hintText: 'Enter New Password',
                  labelStyle: TextStyle(fontSize: 20.0),
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                ),
                controller: newPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Password';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // <-- Radius
                ),
                //shape: StadiumBorder(),
                fixedSize: Size(285, 45),
                primary: color.AppColor.welcomeImageContainer,
              ),
              onPressed: () {
                // Validate returns true if the form is valid, otherwise false.
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    newPassword = newPasswordController.text;
                  });
                  changePassword();
                }
              },
              child: Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 20,
                  color: color.AppColor.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: color.AppColor.welcomeImageContainer),
        actionsIconTheme:
            IconThemeData(color: color.AppColor.welcomeImageContainer),
        titleTextStyle: TextStyle(
          color: color.AppColor.welcomeImageContainer,
          fontSize: 20,
          fontFamily: 'BalsamiqSans_Regular',
          fontWeight: FontWeight.w500,
        ),
        title: Text(
          'Reset Password',
          textAlign: TextAlign.left,
        ),
        leading: BackButton(
          color: color.AppColor.welcomeImageContainer,
        ),
      ),
      body: changePasswordUI(context),
    );
  }
}
