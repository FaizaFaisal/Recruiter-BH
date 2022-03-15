import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/seeker/myJobsResponse.dart';
import 'dart:developer' as developer;

import 'package:job_search_app/shared/custom_appbar.dart';

class ViewMyJob extends StatefulWidget {
  const ViewMyJob({Key? key}) : super(key: key);

  @override
  _ViewMyJobState createState() => _ViewMyJobState();
}

class _ViewMyJobState extends State<ViewMyJob> {
  int a = 2;
  User? user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<myJobsResponse>? _myjobresponse;
  myJobsResponse? Myjobresponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myjobresponse = [];
    get_applied_jobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.white,
      appBar: menuAppBar(
        context,
        'My jobs',
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: _myjobresponse!.length > 0
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding:
                      EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 10),
                  itemCount: _myjobresponse!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.BOTTOMSLIDE,
                          headerAnimationLoop: true,
                          dialogType: DialogType.INFO_REVERSED,
                          showCloseIcon: false,
                          autoHide: Duration(seconds: 5),
                          title: 'FeedBack',
                          desc: _myjobresponse![index].feedback,
                        )..show();
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          height: 165,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(58),
                              ),
                              // gradient: LinearGradient(
                              //   colors: [
                              //     color.AppColor.gradientFirst.withOpacity(0.5),
                              //     color.AppColor.gradientSecond.withOpacity(0.3),
                              //     color.AppColor.welcomeImageContainer.withOpacity(0.2),
                              //   ],
                              //   begin: Alignment.topCenter,
                              //   end: Alignment.bottomCenter,
                              //   stops: [0, 0.5, 0.5],
                              // ),
                              color: Color(0xFF4e5ae8).withOpacity(0.5),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(5, 10),
                                  blurRadius: 20,
                                  color: color.AppColor.gradientSecond
                                      .withOpacity(0.2),
                                )
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color.AppColor.white,
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blueGrey[50],
                                      backgroundImage:
                                          AssetImage('assets/images/ipsum.png'),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        _myjobresponse![index].jobTitle,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: color.AppColor
                                              .homePageContainerTextSmall,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _myjobresponse![index].company,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: color.AppColor
                                              .homePageContainerTextSmall,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _myjobresponse![index].city,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: color.AppColor
                                              .homePageContainerTextSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color:
                                    color.AppColor.homePageContainerTextSmall,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: color
                                          .AppColor.homePageContainerTextSmall,
                                    ),
                                  ),
                                  Text(
                                    _myjobresponse![index].candidate_status,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: color
                                          .AppColor.homePageContainerTextSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Center(child: Text("No Data Found")),
        ),
      ),
    );
  }

  /// Get applied user ////////////////////////////////////////////////////////
  get_applied_jobs() async {
    _myjobresponse = [];

    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Applied_Jobs")
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          try {
            firestoreInstance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("Applied_Jobs")
                .doc(value.docs[i].id.toString())
                .get()
                .then((value) {
              Map<String, dynamic>? h = value.data();
              if (h != null) {
                Myjobresponse = myJobsResponse.fromJson(h);

                _myjobresponse!.add(Myjobresponse!);
              }
            }).whenComplete(() {
              developer.log("my job     " + _myjobresponse!.length.toString());
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
        style: TextStyle(fontSize: 25, color: Colors.white),
      ),
      duration: Duration(seconds: 7),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}

/*
getAppliedJobs() async {
  await FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((querySnapshot) async {
    querySnapshot.docs.forEach((result) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(result.id)
          .collection("Applied_Jobs")
      //.where('userId', isEqualTo: user!.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.data());
        });
      });
    });
  });
}*/
