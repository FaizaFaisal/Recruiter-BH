import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:url_launcher/url_launcher.dart';

class CandidateDetailScreen extends StatefulWidget {
  final String username;
  final String experience;
  final String skill;
  final String high_edu;
  final String contact;
  final String candidates_status;
  final String email;
  final String job_id;
  final String company_id;
  final String user_id;
  final String resume;
  final String feedback;

  CandidateDetailScreen(
      {Key? key,
      required this.username,
      required this.experience,
      required this.skill,
      required this.high_edu,
      required this.contact,
      required this.candidates_status,
      required this.email,
      required this.job_id,
      required this.company_id,
      required this.user_id,
      required this.resume,
      required this.feedback})
      : super(key: key);

  @override
  _CandidateDetailScreenState createState() => _CandidateDetailScreenState();
}

class _CandidateDetailScreenState extends State<CandidateDetailScreen> {
  // When a new user apply for job -- _candidateStatus should be set to New
  String? _candidateStatus = "New";
  User? user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController feedback = TextEditingController();
  final snackBar = SnackBar(content: Text('No Resume Found'));

  final statusList = [
    'New',
    'Waiting-For-Evaluation',
    'Qualified',
    'Un-Qualified',
    'Approved',
    'Rejected',
    'Interview-to-be-Scheduled',
    'On-Hold',
    'Hired',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _candidateStatus = widget.candidates_status;
    feedback.text = widget.feedback;
    get_candidate_status();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: color.AppColor.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: color.AppColor.white,
          fontSize: 20,
          fontFamily: 'BalsamiqSans_Regular',
          fontWeight: FontWeight.w500,
        ),
        leading: BackButton(
          color: color.AppColor.white,
        ),
        backgroundColor: color.AppColor.welcomeImageContainer,
        title: Text('Candidate Details'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.AppColor.welcomeImageContainer,
              color.AppColor.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.175, 0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 8.0,
                color: Colors.white,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                              const SizedBox(height: 10),
                              Text(
                                widget.username,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'BalsamiqSans_Regular',
                                  fontWeight: FontWeight.w500,
                                  color: color.AppColor.matteBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                // Expereience Of User
                                widget.experience,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'BalsamiqSans_Regular',
                                  fontWeight: FontWeight.w500,
                                  color: color.AppColor.homePagePlanColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              // candidate email
                              final emailto = widget.email;
                              launch('mailto:$emailto?');
                            },
                            child: Icon(Icons.email_outlined,
                                color: Colors.indigo.shade900),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 2.0,
                                color: Colors.indigo.shade900,
                              ),
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(3),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              // candidate number
                              final number = widget.contact;
                              launch('tel://$number');
                            },
                            child: Icon(Icons.phone_outlined,
                                color: Colors.indigo.shade900),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 2.0,
                                color: Colors.indigo.shade900,
                              ),
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(3),
                            ),
                          ),
                          /*  OutlinedButton(
                            onPressed: () {},
                            child: Icon(Icons.chat_bubble_outline,
                                color: Colors.indigo.shade900),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 2.0,
                                color: Colors.indigo.shade900,
                              ),
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(3),
                            ),
                          ),*/
                          OutlinedButton(
                            onPressed: () async {
                              if (widget.resume != "no resume" &&
                                  widget.resume.toString() != "null") {
                                print(widget.resume.toString());
                                if (!await launch(widget.resume))
                                  throw 'Could not launch $widget.resume';
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: Icon(Icons.file_download_outlined,
                                color: Colors.indigo.shade900),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 2.0,
                                color: Colors.indigo.shade900,
                              ),
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(3),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: color.AppColor.gray,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Candidate Status'),
                          SizedBox(width: 15),
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
                                        0.5,
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
                                              title: Text('New'),
                                              value: 'New',
                                              groupValue: _candidateStatus,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _candidateStatus = val!;
                                                });
                                                setState(() {
                                                  _candidateStatus = val;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text(
                                                  'Waiting-For-Evaluation'),
                                              value: 'Waiting-For-Evaluation',
                                              groupValue: _candidateStatus,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _candidateStatus = val!;
                                                });
                                                setState(() {
                                                  _candidateStatus = val;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text('Qualified'),
                                              value: 'Qualified',
                                              groupValue: _candidateStatus,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _candidateStatus = val!;
                                                });
                                                setState(() {
                                                  _candidateStatus = val;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text('Un-Qualified'),
                                              value: 'Un-Qualified',
                                              groupValue: _candidateStatus,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _candidateStatus = val!;
                                                });
                                                setState(() {
                                                  _candidateStatus = val;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text('Approved'),
                                              value: 'Approved',
                                              groupValue: _candidateStatus,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _candidateStatus = val!;
                                                });
                                                setState(() {
                                                  _candidateStatus = val;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text('Rejected'),
                                              value: 'Rejected',
                                              groupValue: _candidateStatus,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _candidateStatus = val!;
                                                });
                                                setState(() {
                                                  _candidateStatus = val;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text(
                                                  'Interview-to-be-Scheduled'),
                                              value:
                                                  'Interview-to-be-Scheduled',
                                              groupValue: _candidateStatus,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _candidateStatus = val!;
                                                });
                                                setState(() {
                                                  _candidateStatus = val;
                                                });
                                              },
                                            ),
                                            RadioListTile<String>(
                                              activeColor: color.AppColor
                                                  .welcomeImageContainer,
                                              title: Text('On-Hold'),
                                              value: 'Hired',
                                              groupValue: _candidateStatus,
                                              onChanged: (val) {
                                                stateSetter(() {
                                                  print(val);
                                                  _candidateStatus = val!;
                                                });
                                                setState(() {
                                                  _candidateStatus = val;
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
                            child: Text(_candidateStatus!,
                                style: TextStyle(
                                  color: color.AppColor.welcomeImageContainer,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Professional Details',
                  style: TextStyle(
                    color: color.AppColor.gray,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text('Experience',
                                style: GoogleFonts.lato(
                                    color: color.AppColor.gray,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(widget.experience,
                                style: GoogleFonts.lato(
                                    color: color.AppColor.gray,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text('Skills',
                                style: GoogleFonts.lato(
                                    color: color.AppColor.gray,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(widget.skill,
                                style: GoogleFonts.lato(
                                    color: color.AppColor.gray,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text('Highest Qualification',
                                style: GoogleFonts.lato(
                                    color: color.AppColor.gray,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(widget.high_edu,
                                style: GoogleFonts.lato(
                                    color: color.AppColor.gray,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Feedback',
                  style: TextStyle(
                    color: color.AppColor.gray,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                maxLines: 5,
                minLines: 1,
                controller: feedback,
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  candidate_status();
                },
                child: Text(
                  'Save and Post Feedback',
                  style: TextStyle(fontSize: 20, color: color.AppColor.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  fixedSize: Size(265, 50),
                  primary: color.AppColor.welcomeImageContainer,
                ),
              ),
              /*SizedBox(
                height: 10,
              ),
              // When hired get tapped, close the notify user about his candidate status
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Hired',
                  style: TextStyle(fontSize: 20, color: color.AppColor.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  fixedSize: Size(265, 50),
                  primary: color.AppColor.welcomeImageContainer,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  /// candidate status ////////////////////////////////////////////////////////
  Future<String?> candidate_status() async {
    try {
      firestoreInstance
          .collection("users")
          .doc(widget.user_id)
          .collection("Applied_Jobs")
          .doc(widget.job_id)
          .update({
        "candidate_status": _candidateStatus,
        "feedback": feedback.text.trim().toString()
      }).then((value) {
        firestoreInstance
            .collection("users")
            .doc(widget.company_id)
            .collection("Applied_user")
            .doc(widget.job_id)
            .update({
          "candidate_status": _candidateStatus,
          "feedback": feedback.text.trim().toString()
        }).then((values) {
          setState(() {});
          //print(FirebaseAuth.instance.currentUser!.uid + FirebaseAuth.instance.currentUser!.displayName.toString() + FirebaseAuth.instance.currentUser!.phoneNumber.toString());
          AwesomeDialog(
              context: context,
              animType: AnimType.SCALE,
              headerAnimationLoop: true,
              dialogType: DialogType.SUCCES,
              showCloseIcon: true,
              title: 'Succes',
              desc: 'Candidate status update successfully',
              btnOkOnPress: () {
                debugPrint('OnClcik');
              },
              btnOkIcon: Icons.check_circle,
              onDissmissCallback: (type) {
                debugPrint('Dialog Dissmiss from callback $type');
              })
            ..show();
        });
      });
    } catch (e) {
      _displaySnackBar(context, "No data Found");
    }
  }

  /// candidate status ////////////////////////////////////////////////////////
  get_candidate_status() async {
    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Applied_user")
          .doc(widget.job_id)
          .get()
          .then((value) {
        Map<String, dynamic>? h = value.data();
        _candidateStatus = h!['candidate_status'];
        setState(() {});
      });
    } catch (e) {
      _displaySnackBar(context, "something went wrong");
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
