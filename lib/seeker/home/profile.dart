import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/seeker/widgets/models/menuItem.dart';
import 'package:job_search_app/shared/loading.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
import 'package:job_search_app/shared/screens.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  // get Current User
  User? user = FirebaseAuth.instance.currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final firestoreInstance = FirebaseFirestore.instance;
  bool isDarkMode = false;
  bool isEdit = false;
  bool profile_img = false;
  String profileImg = "";
  final VoidCallback onClicked = () async {};


  Widget textWidget(String text1, String text2) => Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(text1,
                    style: GoogleFonts.lato(
                        color: color.AppColor.welcomeImageContainer,
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(text2,
                    style: GoogleFonts.lato(
                        color: color.AppColor.appColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w300)),
              ),
            ],
          ),
        ),
      ));

  Widget picture(String img) {
    final image =
    NetworkImage(img);
    //:NetworkImage('https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80');
    return Center(
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 128,
            height: 128,
            child: InkWell(
              // onTap: onClicked,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Widget editIcon() {
  //   return ClipOval(
  //     child: Container(
  //       padding: EdgeInsets.all(8),
  //       color: color.AppColor.welcomeImageContainer,
  //       child: Icon(
  //         isEdit ? Icons.add_a_photo : Icons.edit,
  //         color: Colors.white,
  //         size: 20,
  //       ),
  //     ),
  //   );
  // }

  Widget profilePic(String imag) {
    return Center(
      child: Stack(children: [
        picture(imag),
        Align(
          alignment: Alignment.bottomCenter,
        ),
      ]),
    );
  }

  Widget getName(String name, String phone, String email) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
                color: color.AppColor.welcomeImageContainer,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(phone,
              style: TextStyle(
                color: color.AppColor.gray,
              )),
          const SizedBox(
            height: 4,
          ),
          Text(email,
              style: TextStyle(
                color: color.AppColor.gray,
              )),
        ],
      ),
    );
  }

  Widget getProfile(BuildContext context) {
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

            if('${data['photoURL']}' != "")
            profileImg = '${data['photoURL']}';
            print(data);
            // Text("Full Name: ${data['name']} ${data['phone']}")
            return ListView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 10),
              children: [
                profilePic(profileImg),
                const SizedBox(height: 24),
                getName(
                    '${data['name']}', '${data['phone']}', '${data['email']}'),
                // textWidget('Name', '${data['name']}'),
                // textWidget(
                //     'Contact Details', '${data['phone']} \n ${data['email']}'),
                textWidget('Education', '${data['education']}'),
                textWidget('Experience', '${data['experience']}'),
                textWidget('Skills', '${data['skills']}'),
                textWidget('Address', '${data['address']}'),
                textWidget('About', '${data['about']}'),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditProfile()),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                          color: color.AppColor.welcomeImageContainer,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text("Edit",
                              style: GoogleFonts.lato(
                                  color: color.AppColor.white))),
                    ),
                  ),
                ),
               /* GestureDetector(
                  onTap: ()
                  {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EditProfile()),);
                  },
                  child: Text('${data['resume']}',style: GoogleFonts.lato(
              color: color.AppColor.welcomeImageContainer,
              fontWeight: FontWeight.w600)),
                )*/
              ],
            );
          }
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Profile',
          textAlign: TextAlign.left,
        ),
        leading:IconButton(
            color: color.AppColor.welcomeImageContainer,
            onPressed: () =>  ZoomDrawer.of(context)!.toggle(),
            icon: Icon(Icons.short_text)),
        actions: <Widget>[
          PopupMenuButton<MenuItemModel>(
              shape: BeveledRectangleBorder(),
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    ...MenuItems.itemsFirst.map(buildItem).toList(),
                    PopupMenuDivider(),
                    ...MenuItems.itemsSecond.map(buildItem).toList(),
                  ]),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: getProfile(context),
      ),
    );
  }





}
