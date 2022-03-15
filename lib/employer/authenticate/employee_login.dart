import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/services/database_employer.dart';
import 'package:job_search_app/shared/screens.dart';
import 'package:job_search_app/colors.dart' as color;

class EmployeeLoginScreen extends StatefulWidget {
  const EmployeeLoginScreen({Key? key}) : super(key: key);

  @override
  _EmployeeLoginScreenState createState() => _EmployeeLoginScreenState();
}

class _EmployeeLoginScreenState extends State<EmployeeLoginScreen> {
  bool isLoading = false;
  var email = "";
  var password = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    // Gesture Function for Password
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  clearText() {
    emailController.clear();
    passwordController.clear();
  }

  Flushbar flush = new Flushbar();
  employeeLogin() async {
    try {
      // Sign out
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print(userCredential.user?.uid);
      try {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            dynamic role = documentSnapshot.get('userRole'); // get User Role
            print(role);
            if (role != 'Employer') {
              setState(() {
                isLoading = false;
                DatabaseEmployerService(uid: userCredential.user!.uid).logout();
              });
              return flush = Flushbar(
                backgroundColor: Colors.white,
                flushbarStyle: FlushbarStyle.FLOATING,
                titleText: Text(
                  "Don't have access",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                flushbarPosition: FlushbarPosition.TOP,
                message: "Oops! You don't have permission ",
                messageSize: 16,
                messageColor: color.AppColor.homePagePlanColor,
                margin: EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
                icon: Icon(
                  Icons.info_outline,
                  size: 40.0,
                  color: Colors.redAccent[700],
                ),
                leftBarIndicatorColor: Colors.red,
                duration: Duration(days: 3),
                mainButton: IconButton(
                    icon: Icon(FontAwesomeIcons.times,
                        color: color.AppColor.homePageIcons, size: 15),
                    onPressed: () {
                      flush.dismiss(true);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeeLoginScreen()));
                    }),
              )..show(context);
            } else {
              setState(() {
                isLoading = false;
              });
              await storage.write(key: "uid", value: userCredential.user?.uid);
              await storage.write(key: "role", value: "Employer");

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.white,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
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
                          "Logged In Successfully",
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => NavZoomDrawer()));
            }
          } else {
            print('Document does not exist on the database');
          }
        });
      } catch (e) {}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          isLoading = false;
        });
        flush = Flushbar(
          backgroundColor: Colors.redAccent.shade700,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Text(
            "No user found for this email",
            style: TextStyle(
                color: color.AppColor.white,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          flushbarPosition: FlushbarPosition.TOP,
          message: "Please try again !",
          messageColor: Colors.white70,
          messageSize: 16,
          margin: EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          icon: Icon(
            Icons.info_outline,
            size: 40.0,
            color: Colors.white,
          ),
          duration: Duration(days: 1),
          //leftBarIndicatorColor: color.AppColor.welcomeImageContainer,
          mainButton: IconButton(
              icon: Icon(FontAwesomeIcons.times,
                  color: color.AppColor.white, size: 20),
              onPressed: () {
                flush.dismiss(true); // result = true
                clearText();
              }),
        )..show(context);
      } else if (e.code == 'wrong-password') {
        setState(() {
          isLoading = false;
        });
        flush = Flushbar(
          backgroundColor: Colors.redAccent.shade700,
          flushbarStyle: FlushbarStyle.FLOATING,
          messageText: Text(
            "Wrong Password ! Please try Again",
            style: TextStyle(
                color: color.AppColor.white,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          flushbarPosition: FlushbarPosition.TOP,
          margin: EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          icon: Icon(
            Icons.info_outline,
            //Icons.cancel,
            size: 40.0,
            color: Colors.white,
          ),
          duration: Duration(days: 1),
          mainButton: IconButton(
              icon: Icon(FontAwesomeIcons.times,
                  color: color.AppColor.white, size: 15),
              onPressed: () {
                flush.dismiss(true); // result = true
              }),
        )..show(context);
      }
    }
  }

  loginControls(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sign In to your account",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color.AppColor.matteBlack,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 18,
        ),
        Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.01),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(fontSize: 15.0),
                    focusColor: color.AppColor.welcomeImageContainer,
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                    ),
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                            .hasMatch(value)) {
                      return "Enter correct Email";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: height * 0.04),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscured,
                  focusNode: textFieldFocusNode,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    isDense: true, // Reduces height a bit
                    prefixIcon: Icon(
                      Icons.lock,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    focusColor: color.AppColor.welcomeImageContainer,
                    hintText: "Password",
                    hintStyle: TextStyle(fontSize: 15.0),
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: _toggleObscured,
                      child: Icon(
                        _obscured
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                        color: color.AppColor.welcomeImageContainer,
                      ),
                    ),
                  ),
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]').hasMatch(value)) {
                      return "Enter correct Password";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => (EmployeeForgotPassword()),
                        ));
                      },
                      child: Text(
                        "Forgot Password",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: color.AppColor.welcomeImageContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                              isLoading = true;
                            });
                            employeeLogin();
                          }
                        },
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 24),
                                  Text('Please Wait...'),
                                ],
                              )
                            : Text(
                                "Login",
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // <-- Radius
                          ),
                          //shape: StadiumBorder(),
                          fixedSize: Size(265, 50),
                          primary: color.AppColor.welcomeImageContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                            color: color.AppColor.homePagePlanColor,
                            height: 30,
                          )),
                    ),
                    Text("OR"),
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Divider(
                            color: color.AppColor.homePagePlanColor,
                            height: 30,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: TextStyle(
                            fontSize: 18, color: color.AppColor.gray)),
                    SizedBox(width: width * 0.001),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => (RegisterScreen()),
                          ));
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 18,
                              color: color.AppColor.welcomeImageContainer),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: color.AppColor.white,
        elevation: 0.0,
        leading: BackButton(
            color: color.AppColor.matteBlack,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
            }),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: loginControls(context),
      ),
    );
  }
}
