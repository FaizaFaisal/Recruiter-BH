import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/shared/screens.dart';
import 'package:job_search_app/services/database_seeker.dart'; // Required  Imports

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  var displayName = "";
  var phoneNumber = "";
  var email = "";
  var password = "";
  var confirm = "";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  clearText() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmController.clear();
  }

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

  final confirmtextFieldFocusNode = FocusNode();
  bool confirmobscured = false;

  void _confirmToggleObscured() {
    // confirm Gesture Function for Password
    setState(() {
      confirmobscured = !confirmobscured;
      if (confirmtextFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      confirmtextFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  // Load Progress
  bool visible = false;
  // Flushbar
  Flushbar flush = new Flushbar();

  // Function to create a new User
  registration() async {
    if (password == confirm) {
      try {
        // Register Using email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        User? user = FirebaseAuth.instance.currentUser;

        print(userCredential);
        await storage.deleteAll();
        await storage.write(key: "uid", value: userCredential.user?.uid);
        await storage.write(key: "role", value: "Seeker");
        await DatabaseSeekerService(uid: user!.uid)
            .addjobSeeker(displayName, '', '', '', '', phoneNumber, email, '');

        setState(() {
          visible = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[600],
            //margin: EdgeInsets.all(5.0), // EdgeInsets.symmetric(vertical:12,horizontal:16)
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_outlined,
                  size: 32.0,
                  color: Colors.white70,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    "Registerd Successfully . Logged In ..",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FlutterZoomDrawerDemo(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //print("Password Provided is too Weak");
          setState(() {
            visible = false;
          });
          flush = Flushbar(
            backgroundColor: Colors.white,
            flushbarStyle: FlushbarStyle.FLOATING,
            titleText: Text(
              "Provided Password is too weak",
              style: TextStyle(
                  color: Colors.redAccent[700],
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            flushbarPosition: FlushbarPosition.TOP,
            message: "Please try again !",
            messageSize: 16,
            messageColor: color.AppColor.gray,
            margin: EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            borderColor: Colors.redAccent[700],
            icon: Icon(
              Icons.error_outline_outlined,
              size: 40.0,
              color: Colors.redAccent[700],
            ),
            duration: Duration(days: 390),
            leftBarIndicatorColor: Colors.redAccent[700],
            mainButton: IconButton(
                icon: Icon(FontAwesomeIcons.times,
                    color: color.AppColor.homePageIcons, size: 20),
                onPressed: () {
                  flush.dismiss(true);
                  clearText(); // result = true
                }),
          )..show(context);
        } else if (e.code == 'email-already-in-use') {
          //print("Account already exists");
          setState(() {
            visible = false;
          });
          flush = Flushbar(
            backgroundColor: Colors.white,
            flushbarStyle: FlushbarStyle.FLOATING,
            titleText: Text(
              "Account already exists",
              style: TextStyle(
                  color: Colors.redAccent[700],
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            flushbarPosition: FlushbarPosition.TOP,
            message: "Please try with another email !",
            messageSize: 16,
            messageColor: color.AppColor.gray,
            margin: EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            borderColor: Colors.redAccent[700],
            icon: Icon(
              Icons.error_outline_outlined,
              size: 40.0,
              color: Colors.redAccent[700],
            ),
            duration: Duration(days: 390),
            leftBarIndicatorColor: Colors.redAccent[700],
            mainButton: IconButton(
                icon: Icon(FontAwesomeIcons.times,
                    color: color.AppColor.homePageIcons, size: 20),
                onPressed: () {
                  flush.dismiss(true);
                  clearText(); // result = true
                }),
          )..show(context);
        }
      }
    } else {
      //print("Confirm Password and Password doesn't match");
      setState(() {
        visible = false;
      });
      flush = Flushbar(
        backgroundColor: Colors.white,
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        messageText: Text(
          "Password doesn't match !",
          style: TextStyle(
              color: Colors.redAccent[700],
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        borderColor: Colors.redAccent[700],
        icon: Icon(
          Icons.error_outline_outlined,
          size: 40.0,
          color: Colors.redAccent[700],
        ),
        duration: Duration(days: 390),
        leftBarIndicatorColor: Colors.redAccent[700],
        mainButton: IconButton(
            icon: Icon(FontAwesomeIcons.times,
                color: color.AppColor.homePageIcons, size: 20),
            onPressed: () {
              flush.dismiss(true);
              clearText(); // result = true
            }),
      )..show(context);
    }
  }

  registerUI(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color.AppColor.matteBlack,
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Please create an account to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: color.AppColor.homePagePlanColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.04),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: color.AppColor.welcomeImageContainer,
                          ),
                          hintText: "Name",
                          hintStyle: TextStyle(fontSize: 15.0),
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                          ),
                        ),
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^[a-z A-Z]').hasMatch(value)) {
                            return "Enter Name";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: color.AppColor.welcomeImageContainer,
                          ),
                          hintText: "Phone",
                          hintStyle: TextStyle(fontSize: 15.0),
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                          ),
                        ),
                        controller: phoneController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^[0-9]{8}').hasMatch(value)) {
                            return "Enter Number ";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: color.AppColor.welcomeImageContainer,
                          ),
                          hintText: "Email",
                          hintStyle: TextStyle(fontSize: 15.0),
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
                      SizedBox(height: height * 0.02),
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
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 15.0),
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
                      SizedBox(height: height * 0.02),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: confirmobscured,
                        focusNode: confirmtextFieldFocusNode,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          isDense: true, // Reduces height a bit
                          prefixIcon: Icon(
                            Icons.lock,
                            color: color.AppColor.welcomeImageContainer,
                          ),
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(fontSize: 15.0),
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: _confirmToggleObscured,
                            child: Icon(
                              confirmobscured
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              size: 24,
                              color: color.AppColor.welcomeImageContainer,
                            ),
                          ),
                        ),
                        controller: confirmController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^[a-z A-Z]').hasMatch(value)) {
                            return "Enter correct Password";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    displayName = nameController.text;
                                    phoneNumber = phoneController.text;
                                    email = emailController.text;
                                    password = passwordController.text;
                                    confirm = confirmController.text;
                                    visible = true;
                                  });
                                  registration();
                                }
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                fixedSize: Size(260, 55),
                                primary: color.AppColor.welcomeImageContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return visible
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: color.AppColor.white,
            appBar: AppBar(
              backgroundColor: color.AppColor.white,
              elevation: 0.0,
              leading: BackButton(
                color: color.AppColor.matteBlack,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: registerUI(context),
            ),
          );
  }
}
