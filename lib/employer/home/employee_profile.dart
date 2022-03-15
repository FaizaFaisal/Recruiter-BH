import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/employer/profileResponse.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  _EmployeeProfileScreenState createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  profileResponse? _profileResponse;
  TextEditingController company_Name = TextEditingController();
  TextEditingController comapny_Email = TextEditingController();
  TextEditingController company_Phone = TextEditingController();
  TextEditingController description = TextEditingController();
  var photoURL =
      'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80';

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      uploadFile(imageTemporary);

      // uploadFile();
    } on PlatformException catch (e) {
      print("Failed to pick the image : $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_profile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.white,
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: color.AppColor.welcomeImageContainer,
          fontSize: 20,
          fontFamily: 'BalsamiqSans_Regular',
          fontWeight: FontWeight.w500,
        ),
        leading: BackButton(
          color: color.AppColor.welcomeImageContainer,
        ),
        backgroundColor: color.AppColor.white,
        title: Text('Profile'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 80.0,
                      backgroundImage: NetworkImage(photoURL),
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 20.0,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: ((builder) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Choose profile picture",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          ElevatedButton.icon(
                                            onPressed: () =>
                                                pickImage(ImageSource.gallery),
                                            icon: Icon(
                                              Icons.image_outlined,
                                              size: 30,
                                            ),
                                            label: Text(
                                              'Gallery',
                                              textAlign: TextAlign.center,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: color.AppColor
                                                  .welcomeImageContainer,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () =>
                                                pickImage(ImageSource.camera),
                                            icon: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 30,
                                            ),
                                            label: Text(
                                              'Camera',
                                              textAlign: TextAlign.center,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: color.AppColor
                                                  .welcomeImageContainer,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          );
                        },
                        child: ClipOval(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: color.AppColor.welcomeImageContainer,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              getText(context, 'Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: company_Name,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              getText(context, 'Company Email'),
              const SizedBox(height: 8),
              TextFormField(
                controller: comapny_Email,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              getText(context, 'Company Phone'),
              const SizedBox(height: 8),
              TextFormField(
                controller: company_Phone,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              getText(context, 'Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: description,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // do code
                    }
                  },
                  child: GestureDetector(
                    onTap: () {
                      set_profile();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                          color: color.AppColor.welcomeImageContainer,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text("Save",
                              style: GoogleFonts.lato(
                                  color: color.AppColor.white))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getText(BuildContext context, String label) => Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color.AppColor.welcomeImageContainer),
      );

  /// Upload Profile ///////////////////////////////////////
  Future uploadFile(File image) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
              "profile/${FirebaseAuth.instance.currentUser!.uid}/Profile_Img");

      firebase_storage.UploadTask uploadTask = ref.putFile(image);
      uploadTask.whenComplete(() {
        print('File Uploaded');
        ref.getDownloadURL().then((fileURL) {
          print(fileURL);

          firestoreInstance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({"photoURL": fileURL.toString()}).whenComplete(() {
            setState(() {
              photoURL = fileURL.toString();
            });

            _displaySnackBar(context, "Profile image uploaded Successfully");
          }).catchError((e) {
            _displaySnackBar(context, "Something Went Wrong! Try Again");
          });
        });
      }).catchError((e) {
        _displaySnackBar(context, "Something Went Wrong! Try Again");
      });
    } catch (e) {
      _displaySnackBar(context, "Image uploading fail");
      print(e.toString());
    }
  }

  /// Show Snackbar ////////////////////////////////////////////////////////////////
  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: new Text(
        msg,
        style: TextStyle(fontSize: 25, color: Colors.white),
      ),
      duration: Duration(seconds: 7),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  /// Get profile ////////////////////////////////////////////////////////
  get_profile() async {
    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        Map<String, dynamic>? h = value.data() as Map<String, dynamic>;
        company_Name.text = '${h['companyName']}';
        comapny_Email.text = '${h['companyEmail']}';
        company_Phone.text = '${h['companyPhone']}';
        photoURL = '${h['photoURL']}';
        description.text = '${h['description']}';
      }).then((value) {
        setState(() {});
      });
    } catch (e) {
      _displaySnackBar(context, "No user Found");
    }
  }

  /// set profile ////////////////////////////////////////////////////////
  set_profile() async {
    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'companyName': company_Name.text,
        'companyEmail': comapny_Email.text,
        'companyPhone': company_Phone.text,
        'photoURL': photoURL,
        'description': description.text,
      }).then((value) {
        setState(() {});
        AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            dialogType: DialogType.SUCCES,
            showCloseIcon: true,
            title: 'Succes',
            desc: 'Profile Updated Successfully',
            btnOkOnPress: () {
              debugPrint('OnClcik');
            },
            btnOkIcon: Icons.check_circle,
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            })
          ..show();
      });
    } catch (e) {
      _displaySnackBar(context, "No user Found");
    }
  }
}
