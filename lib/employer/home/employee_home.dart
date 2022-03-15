import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/scheduledInterviewResponse.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
import 'package:job_search_app/colors.dart' as color;
import 'dart:developer' as developer;

import 'package:job_search_app/shared/menu_widget.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({Key? key, this.title}) : super(key: key);

  final String? title;
  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  var _groupValue = 'Scheduled';
  List<scheduledInterviewResponse>? candidate_lst;
  User? user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  scheduledInterviewResponse? _scheduledInterviewResponse;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_scheduled_user();
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
          'Home',
          textAlign: TextAlign.left,
        ),
        leading: MenuWidget(),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: candidate_lst!.length > 0
            ? ListView.builder(
                itemCount: candidate_lst!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            candidate_lst![index].title,
                            style: GoogleFonts.lato(
                                color: color.AppColor.gray,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                context: context,
                                builder: ((
                                  builder,
                                ) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter stateSetter) {
                                        return ListView(
                                          scrollDirection: Axis.vertical,
                                          children: [
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text('Scheduled'),
                                              value: 'Scheduled',
                                              groupValue: _groupValue,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _groupValue = val!;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text('Completed'),
                                              value: 'Completed',
                                              groupValue: _groupValue,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _groupValue = val!;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text('Cancelled'),
                                              value: 'Cancelled',
                                              groupValue: _groupValue,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _groupValue = val!;
                                                });
                                                setState(() {
                                                  _groupValue = val!;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text('Delayed'),
                                              value: 'Delayed',
                                              groupValue: _groupValue,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _groupValue = val!;
                                                });
                                                setState(() {
                                                  _groupValue = val!;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text('Preponed'),
                                              value: 'Preponed',
                                              groupValue: _groupValue,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _groupValue = val!;
                                                });
                                                setState(() {
                                                  _groupValue = val!;
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                }),
                              );
                            },
                            child: Text(
                              _groupValue,
                              style: GoogleFonts.lato(
                                  color: color.AppColor.gray,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        candidate_lst![index].dateOpen +
                            "\n" +
                            candidate_lst![index].username,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Icon Design
                      leading: Container(
                        width: 60,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.indigo[900],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  );
                })
            : Center(
                child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 2),
                      alignment: Alignment.topCenter,
                      child: Image.asset("assets/images/ipsum.png")),
                  Text(
                    "Oh ! You don't have any interview scheduled. ",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              )),
      ),
    );
  }

  /// Get applied user ////////////////////////////////////////////////////////
  // ignore: non_constant_identifier_names
  get_scheduled_user() async {
    candidate_lst = [];
    //id = [];

    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("scheduled_interview")
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          try {
            //id!.add(value.docs[i].id.toString());
            firestoreInstance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("scheduled_interview")
                .doc(value.docs[i].id.toString())
                .get()
                .then((value) {
              Map<String, dynamic>? h = value.data();
              if (h != null) {
                _scheduledInterviewResponse =
                    scheduledInterviewResponse.fromJson(h);

                candidate_lst!.add(_scheduledInterviewResponse!);
              }
            }).whenComplete(() {
              developer
                  .log("my data g       " + candidate_lst!.length.toString());
              setState(() {});
            });
          } catch (e) {
            print(e.toString());
          }
        }
      });
    } catch (e) {
      _displaySnackBar(context, "No user Found");
    }
  }

  /// Show Snackbar ////////////////////////////////////////////////////////////////
  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: new Text(
        msg,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      duration: Duration(seconds: 7),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}
