import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_search_app/services/database_seeker.dart';
import 'package:job_search_app/shared/api_upload/firebase_api.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
import 'package:job_search_app/shared/loading.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/shared/screens.dart';
import 'package:path/path.dart' as path;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UploadTask? task;
  File? image;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final firestoreInstance = FirebaseFirestore.instance;
  late final urlDownload;
  bool profile_img = false;
  bool resume_bol = false;
  String profileImg =
      "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-unknown-social-media-user-photo-default-avatar-profile-icon-vector-unknown-social-media-user-184816085.jpg";
  String resumefile = "";
  String namefile = "";
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      uploadFile(imageTemporary);
      //setState(() => this.image = imageTemporary);
      // uploadFile();
    } on PlatformException catch (e) {
      print("Failed to pick the image : $e");
    }
  }

  /*Future uploadFile() async {
    if (image == null) return;
    final fileName = path.basename(image!.path);
    print(image!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, image!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {
      print('Successfully Uploaded');
    });
    final url = await snapshot.ref.getDownloadURL();

    print('Download-Link: $url');
    setState(() {
      urlDownload = url;
    });
  }*/

  // get Current User
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  var name = "";
  var phone = "";
  var education = "";
  var experience = "";
  var skills = "";
  var address = "";
  var about = "";
  //late File _pickedImage;

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80.0,
            backgroundImage: NetworkImage(profileImg),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
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
    );
  }

  Widget bottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.14,
      width: MediaQuery.of(context).size.width * 0.25,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () => pickImage(ImageSource.gallery),
                icon: Icon(
                  Icons.image_outlined,
                  size: 30,
                ),
                label: Text(
                  'Gallery',
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  primary: color.AppColor.welcomeImageContainer,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              ElevatedButton.icon(
                onPressed: () => pickImage(ImageSource.camera),
                icon: Icon(
                  Icons.camera_alt_outlined,
                  size: 30,
                ),
                label: Text(
                  'Camera',
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  primary: color.AppColor.welcomeImageContainer,
                ),
              ),
            ],
          )
        ],
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

  Widget getProfileData(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(includeMetadataChanges: true),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Loading(),
            );
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            print(data);
            name = '${data['name']}';
            education = '${data['education']}';
            experience = '${data['experience']}';
            skills = '${data['skills']}';
            address = '${data['address']}';
            about = '${data['about']}';
            profileImg = '${data['photoURL']}';
            return ListView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              children: [
                imageProfile(),
                const SizedBox(
                  height: 24,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      getText(context, 'FullName'),
                      const SizedBox(height: 8),
                      TextFormField(
                        // controller: nameController,
                        initialValue: name,
                        onChanged: (value) => name = value,
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      getText(context, 'Education'),
                      const SizedBox(height: 8),
                      TextFormField(
                        // controller: eduController,
                        initialValue: education,
                        onChanged: (value) => education = value,
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      getText(context, 'Experience'),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        // controller: expController,
                        initialValue: experience,
                        onChanged: (value) => experience = value,
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      getText(context, 'Skills'),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        // controller: skillController,
                        initialValue: skills,
                        onChanged: (value) => skills = value,
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      getText(context, 'Address'),
                      const SizedBox(height: 8),
                      TextFormField(
                        // controller: addController,
                        initialValue: address,
                        onChanged: (value) => address = value,
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      getText(context, 'About'),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        // controller: aboutController,
                        initialValue: about,
                        onChanged: (value) => about = value,
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                    onTap: () {
                      resume_upload();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(namefile,
                            style: GoogleFonts.lato(
                                color: color.AppColor.welcomeImageContainer,
                                fontWeight: FontWeight.w600)),
                        Icon(Icons.add)
                      ],
                    )),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        DatabaseSeekerService(uid: user!.uid).updateUser(name,
                            education, experience, skills, about, address);
                        Navigator.pop(context);
                      }
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
              ],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: color.AppColor.matteBlack),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: color.AppColor.matteBlack,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [],
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: getProfileData(context),
      ),
    );
  }

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
              profile_img = true;
              profileImg = fileURL.toString();
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

  /// Upload Resume ///////////////////////////////////////
  Future uploadResume(File cv) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("Resume/${FirebaseAuth.instance.currentUser!.uid}/Resume");

      firebase_storage.UploadTask uploadTask = ref.putFile(cv);
      uploadTask.whenComplete(() {
        print('File Uploaded');
        ref.getDownloadURL().then((fileURL) {
          print(fileURL);

          firestoreInstance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({"resume": fileURL.toString()}).whenComplete(() {
            setState(() {
              resume_bol = true;
              resumefile = fileURL.toString();
            });

            _displaySnackBar(context, "Resume uploaded Successfully");
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

  resume_upload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'docx'],
    );

    if (result != null) {
      File file = File(result.files.single.path.toString());
      setState(() {
        namefile = result.files.first.name;
      });
      uploadResume(file);
      print(file.toString());
    } else {
      // User canceled the picker
    }
  }
}
