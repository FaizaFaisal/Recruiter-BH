import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_search_app/candidate_modelClass.dart';
import 'package:job_search_app/employer/home/candidate_details.dart';
import 'package:job_search_app/employer/home/schedule_interview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
import 'package:job_search_app/colors.dart' as color;
import 'dart:developer' as developer;

class CandidatesScreen extends StatefulWidget {
  const CandidatesScreen({Key? key}) : super(key: key);

  @override
  _CandidatesScreenState createState() => _CandidatesScreenState();
}

class _CandidatesScreenState extends State<CandidatesScreen> {
  List<candidate_modelClass>? candidate_lst;
  User? user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  candidate_modelClass? _candidate_modelcalss;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    candidate_lst = [];
    get_applied_user();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: color.AppColor.white,
      appBar: customAppBarEmployer(context, 'Candidates'),
      body: candidate_lst!.length > 0
          ? ListView.builder(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              itemCount: candidate_lst!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print(candidate_lst![index].high_edu);
                    print(candidate_lst![index].skill);
                    //  To View Specific Candidate Details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CandidateDetailScreen(
                          username: candidate_lst![index].userName,
                          contact: candidate_lst![index].contact_num,
                          experience: candidate_lst![index].experience,
                          high_edu: candidate_lst![index].high_edu,
                          skill: candidate_lst![index].skill,
                          candidates_status:
                              candidate_lst![index].candidate_status,
                          email: candidate_lst![index].email,
                          user_id: candidate_lst![index].userId,
                          company_id: candidate_lst![index].company_id,
                          job_id: candidate_lst![index].job_id,
                          resume: candidate_lst![index].resume,
                          feedback: candidate_lst![index].feedback,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 8.0,
                    color: Colors.indigo[50],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  // Profile Picture of Candidate
                                  backgroundImage:
                                      AssetImage('assets/images/avatar.png'),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    candidate_lst![index].userName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          color.AppColor.welcomeImageContainer,
                                    ),
                                  ),
                                  Text(
                                    candidate_lst![index].jobTitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          color.AppColor.welcomeImageContainer,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.54,
                                  )
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(50),
                                        ),
                                      ),
                                      context: context,
                                      builder: ((builder) => Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 16),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  "Contact Details",
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
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        final number =
                                                            candidate_lst![
                                                                    index]
                                                                .contact_num;
                                                        launch('tel://$number');
                                                      },
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            WidgetSpan(
                                                              child: Icon(
                                                                  Icons.phone,
                                                                  color: color
                                                                      .AppColor
                                                                      .homePageIcons,
                                                                  size: 20),
                                                            ),
                                                            TextSpan(
                                                              text: candidate_lst![
                                                                      index]
                                                                  .contact_num,
                                                              style: TextStyle(
                                                                color: color
                                                                    .AppColor
                                                                    .gray,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        var whatsapp =
                                                            "+97333126833";
                                                        var whatsappURl_android =
                                                            "whatsapp://send?phone=" +
                                                                whatsapp +
                                                                "&text=hello";
                                                        var whatappURL_ios =
                                                            "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
                                                        if (Platform.isIOS) {
                                                          // for iOS phone only
                                                          if (await canLaunch(
                                                              whatappURL_ios)) {
                                                            await launch(
                                                                whatappURL_ios,
                                                                forceSafariVC:
                                                                    false);
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(SnackBar(
                                                                    content:
                                                                        new Text(
                                                                            "whatsapp no installed")));
                                                          }
                                                        } else {
                                                          // android , web
                                                          if (await canLaunch(
                                                              whatsappURl_android)) {
                                                            await launch(
                                                                whatsappURl_android);
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(SnackBar(
                                                                    content:
                                                                        new Text(
                                                                            "whatsapp no installed")));
                                                          }
                                                        }
                                                      },
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            WidgetSpan(
                                                              child: Icon(
                                                                  FontAwesomeIcons
                                                                      .whatsapp,
                                                                  color: color
                                                                      .AppColor
                                                                      .homePageIcons,
                                                                  // color: Color(
                                                                  //     0xFF00d856),
                                                                  size: 20),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' \t Message',
                                                              style: TextStyle(
                                                                color: color
                                                                    .AppColor
                                                                    .gray,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        //  To Schedule Page
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ScheduleInterviewScreen(
                                                              candidate:
                                                                  candidate_lst![
                                                                          index]
                                                                      .userName,
                                                              jobTitles:
                                                                  candidate_lst![
                                                                          index]
                                                                      .jobTitle,
                                                              job_id:
                                                                  candidate_lst![
                                                                          index]
                                                                      .job_id,
                                                              company_id:
                                                                  candidate_lst![
                                                                          index]
                                                                      .company_id,
                                                              user_id:
                                                                  candidate_lst![
                                                                          index]
                                                                      .userId,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            WidgetSpan(
                                                              child: Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  color: color
                                                                      .AppColor
                                                                      .homePageIcons,
                                                                  size: 20),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  " \t  Schedule Interview",
                                                              style: TextStyle(
                                                                color: color
                                                                    .AppColor
                                                                    .gray,
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
                                          )),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: color.AppColor.welcomeImageContainer,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: Text(
              "No Data Found ",
              style: TextStyle(fontSize: 16),
            )),
    );
  }

  /// Get applied user ////////////////////////////////////////////////////////
  get_applied_user() async {
    candidate_lst = [];
    //id = [];

    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Applied_user")
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          try {
            //id!.add(value.docs[i].id.toString());
            firestoreInstance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("Applied_user")
                .doc(value.docs[i].id.toString())
                .get()
                .then((value) {
              Map<String, dynamic>? h = value.data();
              if (h != null) {
                _candidate_modelcalss = candidate_modelClass.fromJson(h);

                candidate_lst!.add(_candidate_modelcalss!);
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
