import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:job_search_app/shared/menu_widget.dart';

class ScheduleInterviewScreen extends StatefulWidget {
  final String candidate;
  final String jobTitles;
  final String job_id;
  final String user_id;
  final String company_id;

  const ScheduleInterviewScreen(
      {Key? key,
      required this.candidate,
      required this.jobTitles,
      required this.job_id,
      required this.user_id,
      required this.company_id})
      : super(key: key);

  @override
  _ScheduleInterviewScreenState createState() =>
      _ScheduleInterviewScreenState();
}

class _ScheduleInterviewScreenState extends State<ScheduleInterviewScreen> {
  var interviewTitle = "Technical Interview";
  User? user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isApply = false;
  final interviewList = [
    'Technical Interview',
    'General Interview',
  ];
  var candidateName = "Candidate 1";
  // Candidates who applied for a job By this User
  final candidateList = [
    'Candidate 1',
    'Candidate 2',
  ];

  var jobTitle = "Job 1";
  // Jobs posted by this User
  final jobsList = [
    'Job 1',
    'Job 2',
  ];
  var startdateTime = "";
  var endDateTime = "";
  var location = "";
  var comments = "";

  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationController = TextEditingController();
  final commentsController = TextEditingController();
  final candidate_name = TextEditingController();
  final job_title = TextEditingController();

  @override
  void initState() {
    super.initState();
    candidate_name.text = widget.candidate;
    job_title.text = widget.jobTitles;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    startTimeController.dispose();
    endTimeController.dispose();
    locationController.dispose();
    commentsController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
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
          'Schedule Interviews',
          textAlign: TextAlign.left,
        ),
        leading: BackButton(color: color.AppColor.welcomeImageContainer),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding:
                const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Interview Information',
                  style: TextStyle(
                      color: color.AppColor.welcomeImageContainer,
                      fontSize: 20,
                      fontFamily: 'BalsamiqSans_Bold'),
                ),
                SizedBox(height: height * 0.02, width: width),
                DropdownButtonFormField(
                  dropdownColor: Colors.white,
                  autofocus: false,
                  decoration: InputDecoration(
                    prefix: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "Interview title",
                            style: TextStyle(
                                color: color.AppColor.matteBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: " * \t",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                  isDense: true,
                  iconSize: 36,
                  icon: Icon(Icons.arrow_drop_down,
                      color: color.AppColor.welcomeImageContainer),
                  value: interviewTitle,
                  items: interviewList.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: item == interviewTitle
                          ? Text(
                              item,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: color.AppColor.welcomeImageContainer,
                                  fontWeight: FontWeight.w500),
                            )
                          : Text(
                              item,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: color.AppColor.homePageSubTitle,
                                  fontWeight: FontWeight.w500),
                            ),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => this.interviewTitle = (value as String?)!),
                  validator: (value) {
                    if (value == null) {
                      return 'Select option';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),

                ///candidate
                TextFormField(
                  autofocus: false,
                  controller: candidate_name,
                  enabled: false,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(
                      CupertinoIcons.profile_circled,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    labelText: 'candidate',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill the  required fields.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  autofocus: false,
                  controller: job_title,
                  enabled: false,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(
                      CupertinoIcons.tickets,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    labelText: 'Job Title',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill the  required fields.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event,
                      color: color.AppColor.welcomeImageContainer),
                  dateLabelText: 'Start Date',
                  timeLabelText: "Time",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: color.AppColor.homePagePlanColor),
                  selectableDayPredicate: (date) {
                    // Disable weekend days to select from the calendar
                    if (date.weekday == 5 || date.weekday == 6) {
                      return false;
                    }

                    return true;
                  },
                  onChanged: (val) {
                    print(val);
                    startdateTime = val;
                  },
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) {
                    print(val);
                    startdateTime = val!;
                  },
                ),
                SizedBox(height: height * 0.02),
                DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(
                    Icons.event,
                    color: color.AppColor.welcomeImageContainer,
                  ),
                  dateLabelText: 'End Date',
                  timeLabelText: "Time ",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: color.AppColor.homePagePlanColor),
                  selectableDayPredicate: (date) {
                    // Disable weekend days to select from the calendar
                    if (date.weekday == 6 || date.weekday == 7) {
                      return false;
                    }

                    return true;
                  },
                  onChanged: (val) {
                    print(val);
                    endDateTime = val;
                  },
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) {
                    print(val);
                    endDateTime = val!;
                  },
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Location Information',
                  style: TextStyle(
                      color: color.AppColor.welcomeImageContainer,
                      fontSize: 20,
                      fontFamily: 'BalsamiqSans_Bold'),
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  autofocus: false,
                  controller: locationController,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(
                      CupertinoIcons.placemark,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    labelText: 'Location',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill the  required fields.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: commentsController,
                  autofocus: false,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(Icons.notes,
                        color: color.AppColor.welcomeImageContainer),
                    labelText: 'Comments',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill the required fields.';
                    } else {
                      return null;
                    }
                  },
                ),

                // Add File Picker fot picking file
                //

                SizedBox(height: height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    /*if (_formKey.currentState!.validate()) {
                      setState(() {
                        interviewTitle = this.interviewTitle;
                        candidateName = this.candidateName;
                        jobTitle = this.jobTitle;
                        startdateTime = this.startdateTime;
                        endDateTime = this.endDateTime;
                        location = locationController.text;
                        comments = commentsController.text;
                      });
                    }*/
                    if (!isApply) schedule_interview();
                  },
                  child: isApply
                      ? Text(
                          'Scheduled',
                          style: GoogleFonts.lato(
                              fontSize: 20, color: color.AppColor.white),
                        )
                      : Text(
                          'Schedule',
                          style: GoogleFonts.lato(
                              fontSize: 20, color: color.AppColor.white),
                        ),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    fixedSize: Size(265, 40),
                    primary: color.AppColor.welcomeImageContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// schedule interview ////////////////////////////////////////////////////////
  Future<String?> schedule_interview() async {
    try {
      firestoreInstance
          .collection("users")
          .doc(widget.company_id)
          .collection("scheduled_interview")
          .add({
        "job_id": widget.job_id,
        "job_title": widget.jobTitles,
        "user_id": widget.user_id,
        "user_name": widget.candidate,
        "date_time": startdateTime,
      }).then((values) async {
        setState(() {
          isApply = true;
        });
        //print(FirebaseAuth.instance.currentUser!.uid + FirebaseAuth.instance.currentUser!.displayName.toString() + FirebaseAuth.instance.currentUser!.phoneNumber.toString());
        AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            dialogType: DialogType.SUCCES,
            showCloseIcon: true,
            title: 'Succes',
            desc: 'Interview Scheduled Successfully',
            btnOkOnPress: () {
              debugPrint('OnClcik');
            },
            btnOkIcon: Icons.check_circle,
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            })
          ..show();

        final Email email = Email(
          body:
              "you have shortlisted for interview. \nDate and Time:$startdateTime " +
                  " -  $endDateTime",
          subject: 'Interview for ${job_title.text}',
          recipients: ['example@example.com'],
          cc: ['cc@example.com'],
          bcc: ['bcc@example.com'],
          //attachmentPaths: ['/path/to/attachment.zip'],
          isHTML: false,
        );

        await FlutterEmailSender.send(email);
      });
    } catch (e) {
      _displaySnackBar(context, "No data Found");
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
