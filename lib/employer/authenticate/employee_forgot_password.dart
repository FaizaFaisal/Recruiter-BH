import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/shared/screens.dart';

class EmployeeForgotPassword extends StatefulWidget {
  const EmployeeForgotPassword({Key? key}) : super(key: key);

  @override
  _EmployeeForgotPasswordState createState() => _EmployeeForgotPasswordState();
}

class _EmployeeForgotPasswordState extends State<EmployeeForgotPassword> {
  var email = "";

  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: color.AppColor.gradientSecond,
          content: Text(
            "Email has been sent",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: color.AppColor.homePageBackground),
          ),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EmployeeLoginScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: color.AppColor.gradientSecond,
            content: Text(
              "User Not found",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: color.AppColor.homePageBackground),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: color.AppColor.white,
        leading: BackButton(color: color.AppColor.matteBlack),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding:
            const EdgeInsets.only(left: 45, right: 45, top: 30, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/forgotpassword.jpg'),
                ),
              ],
            ),
            SizedBox(height: height * 0.04),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    "Forgot Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: color.AppColor.matteBlack,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    "Enter your email address, we will send you link to inbox for reset password",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: color.AppColor.gray),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.06,
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.01),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: color.AppColor.welcomeButton,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w400),
                            focusColor: color.AppColor.gray,
                            errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15,
                            ),
                            border: OutlineInputBorder(),
                            fillColor: color.AppColor.gray.withOpacity(0.1),
                            filled: true,
                          ),
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            } else if (!value.contains('@')) {
                              return 'Please Enter Valid Email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: height * 0.05),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                email = emailController.text;
                              });
                              resetPassword();
                            }
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 20,
                              color: color.AppColor.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // <-- Radius
                            ),
                            //shape: StadiumBorder(),
                            fixedSize: Size(285, 45),
                            primary: color.AppColor.welcomeImageContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
