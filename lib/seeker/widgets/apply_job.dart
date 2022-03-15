import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/colors.dart' as color;
import 'dart:developer' as developer;
import 'package:job_search_app/services/database_seeker.dart';
import 'package:job_search_app/shared/screens.dart';
import 'package:share_plus/share_plus.dart';

class ApplyJob extends StatefulWidget {
  final String id;
  final String company;
  final String company_id;
  final String job_id;
  final String user_name;
  final String contact_number;
  final String resume;

  const ApplyJob(
      {Key? key,
      required this.id,
      required this.company,
      required this.job_id,
      required this.company_id,
      required this.user_name,
      required this.contact_number,
      required this.resume})
      : super(key: key);

  @override
  _ApplyJobState createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  var education, skills, experience1;
  User? user = FirebaseAuth.instance.currentUser;
  var jobTitle = "";
  var location = "";
  final firestoreInstance = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String user_name = "";
  String phone_number = "";
  String experience = "";
  String user_email = "";
  String skill = "";
  String higher_qualification = "";

  bool isFavorite = false;
  bool isApply = false;
  @override
  void initState() {
    super.initState();
    get_profile_data();
    FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.id)
        .get()
        .then((value) {
      setState(() {
        jobTitle = value['job_title'];
        location = "${value['country'].toString().split(' ').elementAt(0)} " +
            "(${value['city']})";
      });
    });
    FirebaseFirestore.instance
        .collection('favs')
        .where('userDocId', isEqualTo: user!.uid)
        .where('jobDocId', isEqualTo: widget.job_id)
        .get()
        .then((value) => {
              value.docs.map(
                (result) {
                  print(result);
                  setState(() {
                    isFavorite = result['isFav'];
                    print(result['isFav']);
                  });
                },
              ),
            });
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        education = value['education'];
        skills = value['skills'];
        experience1 = value['experience'];
      });
    });
    get_favourite();
    get_applied_jobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        title: Text('Apply Job'),
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.share,
                  color: color.AppColor.welcomeImageContainer),
              onPressed: () {
                final box = context.findRenderObject() as RenderBox?;
                Share.share(jobTitle,
                    subject: 'Shared',
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size);
              }),
          IconButton(
            onPressed: () {
              setState(() {
                if (!isFavorite) {
                  isFavorite = true;
                  favourite(user!.uid);
                }
              });

              //  DatabaseSeekerService(uid: user!.uid).addFavourites(widget.id, user!.uid, jobTitle, widget.company, location, isFavorite);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('job_id', isEqualTo: widget.job_id)
              .snapshots(includeMetadataChanges: true),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error! Try Again'));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 8.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            height: 150,
                            width: 325,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                      radius:
                                          50, //we give the image a radius of 50 of Company Logo
                                      backgroundImage: NetworkImage(
                                          'https://webstockreview.net/images/male-clipart-professional-man-3.jpg'),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.company,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        //const SizedBox(height: 4),
                                        Text(
                                          data['city'] +
                                              ',' +
                                              data['country']
                                                  .toString()
                                                  .split(' ')
                                                  .elementAt(0),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(data['job_title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: color.AppColor.welcomeImageContainer)),
                        SizedBox(
                          height: 15,
                        ),
                        textWidget('Job Description', data['description']),
                        textWidget('Skills', data['skill']),
                        textWidget('Employment Type', data['job_type']),
                        textWidget('Industry', data['industry']),
                        textWidget('Salary', data['salary']),
                        textWidget('Experience', data['experience']),
                        textWidget('Role', data['role']),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            if (!isApply) apply();
                          },
                          child: isApply
                              ? Text(
                                  "Applied",
                                  style: GoogleFonts.lato(
                                      color: color.AppColor.white,
                                      fontSize: 18),
                                )
                              : Text(
                                  "Apply",
                                  style: GoogleFonts.lato(
                                      color: color.AppColor.white,
                                      fontSize: 18),
                                ),
                          style: ElevatedButton.styleFrom(
                            primary: color.AppColor.welcomeImageContainer,
                            shape: StadiumBorder(),
                            fixedSize: Size(265, 45),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }

  Widget bulletText(String text) => Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: " > \t",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: color.AppColor.welcomeImageContainer)),
                    WidgetSpan(child: SizedBox(height: 5)),
                    TextSpan(
                      text: text + '\t',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: color.AppColor.welcomeImageContainer,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ));

  Widget textWidget(String text1, String text2) => Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
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
                        color: color.AppColor.welcomeImageContainer,
                        fontSize: 18,
                        fontWeight: FontWeight.w300)),
              ),
            ],
          ),
        ),
      ));

  apply() async {
    apply_job();
  }

  /// wishlist ////////////////////////////////////////////////////////
  Future<String?> favourite(String UserKey) async {
    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("favourite")
          .doc(widget.id)
          .set({
        "job_id": widget.id,
        "job_title": jobTitle,
        "company_name": widget.company,
        "city": location
      }).then((value) {
        firestoreInstance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("favourite")
            .doc(widget.id)
            .get()
            .then((value) {
          final Map<String, dynamic>? data = value.data();
        });
      });
    } catch (e) {
      _displaySnackBar(context, "No data Found");
    }
  }

  /// wishlist ////////////////////////////////////////////////////////
  Future<String?> get_favourite() async {
    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("favourite")
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          try {
            firestoreInstance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("favourite")
                .doc(value.docs[i].id.toString())
                .get()
                .then((value) {
              Map<String, dynamic>? h = value.data();
              if (h != null) {
                if (widget.id == h['job_id']) {
                  setState(() {
                    isFavorite = true;
                  });
                }
                developer.log("my data g       " +
                    h.toString() +
                    "    " +
                    h['job_id'].toString());
              }
            }).whenComplete(() {
              setState(() {});
            });
          } catch (e) {
            print(e.toString());
          }
        }
      });
    } catch (e) {
      _displaySnackBar(context, "No data Found");
    }
  }

  /// apply job ////////////////////////////////////////////////////////
  Future<String?> apply_job() async {
    try {
      if (education.isEmpty &&
          skills.isEmpty == true &&
          experience1.isEmpty == true) {
        AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            dialogType: DialogType.WARNING,
            showCloseIcon: true,
            title: 'Incomplete Profile',
            desc: ' Update Profile Information',
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            })
          ..show();
      } else {
        firestoreInstance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Applied_Jobs")
            .doc(widget.id)
            .set({
          "job_id": widget.id,
          "job_title": jobTitle,
          "company_name": widget.company,
          "city": location,
          "company_id": widget.company_id,
          "candidate_status": "New",
          "feedback": ""
        }).then((value) {
          firestoreInstance
              .collection("users")
              .doc(widget.company_id)
              .collection("Applied_user")
              .doc(widget.id)
              .set({
            "job_id": widget.id,
            "job_title": jobTitle,
            "company_name": widget.company,
            "city": location,
            "company_id": widget.company_id,
            "user_id": FirebaseAuth.instance.currentUser!.uid,
            "user_name": user_name,
            "contact_number": phone_number,
            "skills": skill,
            "education": higher_qualification,
            "experience": experience,
            "candidate_status": "New",
            "user_email": user_email,
            "resume": widget.resume,
            "feedback": "",
          }).then((values) {
            setState(() {
              isApply = true;
            });
            print(FirebaseAuth.instance.currentUser!.uid +
                FirebaseAuth.instance.currentUser!.displayName.toString() +
                FirebaseAuth.instance.currentUser!.phoneNumber.toString());
            AwesomeDialog(
                context: context,
                animType: AnimType.SCALE,
                headerAnimationLoop: true,
                dialogType: DialogType.SUCCES,
                showCloseIcon: true,
                title: 'Succes',
                desc: 'Applied Successfully at ' + widget.company,
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
      }
    } catch (e) {
      _displaySnackBar(context, "No data Found");
    }
  }

  /// applied jobs ////////////////////////////////////////////////////////
  Future<String?> get_applied_jobs() async {
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
                if (widget.id == h['job_id']) {
                  setState(() {
                    isApply = true;
                  });
                }
                developer.log("my data g       " +
                    h.toString() +
                    "    " +
                    h['job_id'].toString());
              }
            }).whenComplete(() {
              setState(() {});
            });
          } catch (e) {
            print(e.toString());
          }
        }
      });
    } catch (e) {
      _displaySnackBar(context, "No data Found");
    }
  }

  ///get profile for name and phone ////////////////////////////////////////////////////////
  Future<String?> get_profile_data() async {
    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        Map<String, dynamic>? h = value.data();
        user_name = h!['name'].toString();
        phone_number = h!['phone'].toString();
        experience = h!['experience'].toString();
        skill = h!['skills'].toString();
        higher_qualification = h!['education'].toString();
        user_email = h!['email'].toString();
        developer.log(
            "my data g       " + h.toString() + "    " + h!['name'].toString());
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
