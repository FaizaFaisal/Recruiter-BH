import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/services/database_employer.dart';
import 'package:job_search_app/shared/screens.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  var email = "";
  var password = "";
  var companyname = "";
  var name = "";
  var companyemail = "";
  var companyphone = "";

  // of the TextField.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyPhoneController = TextEditingController();
  final companyEmailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    companyNameController.dispose();
    companyPhoneController.dispose();
    companyEmailController.dispose();
    super.dispose();
  }

  clearText() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    companyNameController.clear();
    companyPhoneController.clear();
    companyEmailController.clear();
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

  // Load Progress
  bool visible = false;
  Flushbar flush = new Flushbar();
  employeeRegistration() async {
    try {
      // Register Using email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = FirebaseAuth.instance.currentUser;
      user!.updateDisplayName(name);
      print(userCredential);
      await storage.deleteAll();
      await storage.write(key: "uid", value: userCredential.user?.uid);
      await storage.write(key: "role", value: "Employer");
      await DatabaseEmployerService(uid: user.uid)
          .addEmployer(companyname, companyemail, companyphone);
      setState(() {
        visible = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
          builder: (context) => NavZoomDrawer(),
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
  }

  employeeRegisterUI(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 1, left: 8, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Register ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color.AppColor.matteBlack,
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Create an account to Continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: color.AppColor.homePagePlanColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          prefixIcon: Icon(
                            Icons.person,
                            color: color.AppColor.welcomeImageContainer,
                          ),
                          labelText: "Name",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Only Characters",
                          hintStyle: TextStyle(fontSize: 15),
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
                      SizedBox(height: height * 0.01),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          prefixIcon: Icon(
                            Icons.email,
                            color: color.AppColor.welcomeImageContainer,
                          ),
                          labelText: "Email Address",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "some@gmail.com",
                          hintStyle: TextStyle(fontSize: 15),
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
                            return "Enter Correct Email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: height * 0.01),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscured,
                        focusNode: textFieldFocusNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          isDense: true, // Reduces height a bit
                          prefixIcon: Icon(
                            Icons.lock,
                            color: color.AppColor.welcomeImageContainer,
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "6+characters",
                          hintStyle: TextStyle(fontSize: 12),
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
                        children: <Widget>[
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Divider(
                                  color: color.AppColor.homePagePlanColor,
                                  height: 30,
                                  thickness: 1.5,
                                )),
                          ),
                          Text("Company Details"),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Divider(
                                  color: color.AppColor.homePagePlanColor,
                                  height: 30,
                                  thickness: 1.5,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          prefixIcon: Icon(
                            Icons.business,
                            color: color.AppColor.welcomeImageContainer,
                          ),
                          labelText: "Company Name",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Only characters",
                          hintStyle: TextStyle(fontSize: 15),
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                          ),
                        ),
                        controller: companyNameController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^[a-z A-Z]').hasMatch(value)) {
                            return "Enter Name";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: height * 0.01),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          prefixIcon: Icon(
                            Icons.email,
                            color: color.AppColor.welcomeImageContainer,
                          ),
                          labelText: "Company Email Address",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "some@gmail.com",
                          hintStyle: TextStyle(fontSize: 15),
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                          ),
                        ),
                        controller: companyEmailController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                  .hasMatch(value)) {
                            return "Enter Correct Email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: height * 0.01),
                      Container(
                        width: width,
                        height: height * 0.1,
                        child: IntlPhoneField(
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                            prefixIcon: Icon(
                              FontAwesomeIcons.mobileAlt,
                              color: color.AppColor.welcomeImageContainer,
                            ),
                            errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15,
                            ),
                          ),
                          initialCountryCode: 'BH',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                          controller: companyPhoneController,
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[0-9]{8}').hasMatch(value)) {
                              return "Enter Number ";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    name = nameController.text;
                                    email = emailController.text;
                                    password = passwordController.text;
                                    companyname = companyNameController.text;
                                    companyemail = companyEmailController.text;
                                    companyphone = companyPhoneController.text;

                                    visible = true;
                                  });
                                  employeeRegistration();
                                }
                              },
                              child: Text(
                                'Register',
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EmployeeLoginScreen()));
                  }),
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: employeeRegisterUI(context),
            ),
          );
  }
}
