import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/employer/home/edit_job_details.dart';
import 'package:job_search_app/jobSearchResponse.dart';
import 'package:job_search_app/shared/screens.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:developer' as developer;

class EditJobs extends StatefulWidget {
  const EditJobs({Key? key}) : super(key: key);

  @override
  _EditJobsState createState() => _EditJobsState();
}

class _EditJobsState extends State<EditJobs> with TickerProviderStateMixin {
  final GlobalKey<ExpansionTileCardState> cardId = new GlobalKey();
  var _groupValue = 'Active';
  User? user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<jobSearchResponse>? active_job;
  List<jobSearchResponse>? inactive_job;
  jobSearchResponse? _jobsearchresponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    active_job = [];
    inactive_job = [];
    get_jobs();
    get_inactive_jobs();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: color.AppColor.white,
      appBar: customAppBarEmployer(context, 'Edit Jobs'),
      body: Container(
        padding: EdgeInsets.all(5.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
                isScrollable: true,
                controller: _tabController,
                // labelPadding: const EdgeInsets.only(left: 20, right: 20),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: color.AppColor.welcomeImageContainer,
                labelStyle: TextStyle(
                  fontSize: 18,
                ),
                tabs: [
                  Tab(text: "Open Jobs "),
                  Tab(text: "Closed Jobs "),
                ]),
            Container(
              height: 500,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: active_job!.length,
                      itemBuilder: (context, index) {
                        return Theme(
                          data: ThemeData(primarySwatch: Colors.indigo),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpansionTileCard(
                              baseColor: Colors.indigo[50],
                              expandedColor: Colors.white,
                              //key: cardId,
                              leading: CircleAvatar(
                                  child:
                                      Image.asset("assets/images/ipsum.png")),
                              title: Text(
                                active_job![index].title,
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(
                                active_job![index].industry,
                                style: TextStyle(fontSize: 18),
                              ),
                              children: <Widget>[
                                Divider(
                                  thickness: 1.0,
                                  height: 1.0,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      "JobType : " + active_job![index].jobType,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 18,
                                              color: color
                                                  .AppColor.homePagePlanColor),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      "Experience : " +
                                          active_job![index].experience,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 18,
                                              color: color
                                                  .AppColor.homePagePlanColor),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      "Salary : " + active_job![index].salary,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 18,
                                              color: color
                                                  .AppColor.homePagePlanColor),
                                    ),
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.spaceAround,
                                  buttonHeight: 52.0,
                                  buttonMinWidth: 90.0,
                                  children: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0)),
                                      ),
                                      onPressed: () {
                                        // cardId.currentState?.expand();
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
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 16),
                                              child: StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter stateSetter) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RadioListTile<String>(
                                                        activeColor: color
                                                            .AppColor
                                                            .welcomeImageContainer,
                                                        title: Text('Active'),
                                                        value: 'Active',
                                                        groupValue: _groupValue,
                                                        onChanged: (val) {
                                                          stateSetter(() {
                                                            print(val);
                                                            _groupValue = val!;
                                                            job_status(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid
                                                                    .toString(),
                                                                active_job![
                                                                        index]
                                                                    .job_id);
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile<String>(
                                                        activeColor: color
                                                            .AppColor
                                                            .welcomeImageContainer,
                                                        title: Text('Inactive'),
                                                        value: 'Inactive',
                                                        groupValue: _groupValue,
                                                        onChanged: (val) {
                                                          stateSetter(() {
                                                            print(val);
                                                            _groupValue = val!;
                                                            AwesomeDialog(
                                                                context:
                                                                    context,
                                                                animType:
                                                                    AnimType
                                                                        .SCALE,
                                                                headerAnimationLoop:
                                                                    false,
                                                                dialogType:
                                                                    DialogType
                                                                        .QUESTION,
                                                                showCloseIcon:
                                                                    true,
                                                                title:
                                                                    'Are you Sure you want to Close this Job ?',
                                                                btnOkOnPress:
                                                                    () {
                                                                  print(
                                                                      'Inactive Job');
                                                                  job_status(
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid
                                                                          .toString(),
                                                                      active_job![
                                                                              index]
                                                                          .job_id);
                                                                },
                                                                btnCancelOnPress:
                                                                    () {},
                                                                btnOkIcon: Icons
                                                                    .check_circle,
                                                                onDissmissCallback:
                                                                    (type) {
                                                                  debugPrint(
                                                                      'Dialog Dissmiss from callback $type');
                                                                })
                                                              ..show();
                                                          });
                                                        },
                                                      ),
                                                      /* RadioListTile<String>(
                                                        activeColor: color
                                                            .AppColor
                                                            .welcomeImageContainer,
                                                        title:
                                                            Text('Cancelled'),
                                                        value: 'Cancelled',
                                                        groupValue: _groupValue,
                                                        onChanged: (val) {
                                                          stateSetter(() {
                                                            print(val);
                                                            _groupValue = val!;
                                                          });
                                                        },
                                                      ),*/
                                                    ],
                                                  );
                                                },
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Icon(Icons.update_outlined),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Text('Status'),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0)),
                                      ),
                                      onPressed: () {
                                        //cardId.currentState?.collapse();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    edit_job_details(
                                                        job_id:
                                                            active_job![index]
                                                                .job_id)));
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Icon(Icons.mode_edit),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    /*TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0)),
                                      ),
                                      onPressed: () {
                                        AwesomeDialog(
                                            context: context,
                                            animType: AnimType.SCALE,
                                            headerAnimationLoop: false,
                                            dialogType: DialogType.QUESTION,
                                            showCloseIcon: true,
                                            title:
                                                'Are you Sure you want to Delete this Job ',
                                            btnOkOnPress: () {
                                              print('jobId');
                                              //
                                            },
                                            btnCancelOnPress: () {},
                                            btnOkIcon: Icons.check_circle,
                                            onDissmissCallback: (type) {
                                              debugPrint(
                                                  'Dialog Dissmiss from callback $type');
                                            })
                                          ..show();
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Icon(Icons.delete),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),*/
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: 120, minHeight: 56.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: inactive_job!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 25,
                                right: 25,
                                left: 25,
                              ),
                              width: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.indigo[50],
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(5, 10),
                                      blurRadius: 10,
                                      color: Colors.indigo.shade50,
                                    ),
                                  ]),
                              child: Column(
                                children: [
                                  Text(
                                    inactive_job![index].title,
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: color
                                            .AppColor.welcomeImageContainer,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 5),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text('Location',
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                    inactive_job![index]
                                                        .country,
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w300)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                  SizedBox(height: 5),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text('Industry',
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                    inactive_job![index]
                                                        .industry,
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w300)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                  SizedBox(height: 5),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text('Employment Type',
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                    inactive_job![index]
                                                        .jobType,
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w300)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                  SizedBox(height: 5),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text('Salary',
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                    inactive_job![index].salary,
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w300)),
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
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text('Description',
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                    inactive_job![index]
                                                        .description,
                                                    // overflow:
                                                    //     TextOverflow.ellipsis,
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w300)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                  SizedBox(height: 5),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text('Role',
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                    inactive_job![index].role,
                                                    style: GoogleFonts.lato(
                                                        color: color.AppColor
                                                            .welcomeImageContainer,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w300)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// get jobs ////////////////////////////////////////////////////////
  Future<String?> get_jobs() async {
    active_job = [];
    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("job_opening")
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          try {
            firestoreInstance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("job_opening")
                .doc(value.docs[i].id.toString())
                .get()
                .then((value) {
              Map<String, dynamic>? h = value.data();
              //developer.log("my Active job       "+ h.toString()+"    "+ h!['job_status'].toString());
              if (h != null) {
                _jobsearchresponse = jobSearchResponse.fromJson(h);
                if (_jobsearchresponse!.jobStatus == "Active")
                  active_job!.add(_jobsearchresponse!);

                developer.log("my data g       " +
                    h.toString() +
                    "    " +
                    _jobsearchresponse!.jobStatus);
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

  /// candidate status ////////////////////////////////////////////////////////
  Future<String?> job_status(
    String company_id,
    String job_id,
  ) async {
    print(company_id + "       " + job_id);
    try {
      firestoreInstance
          .collection("users")
          .doc(company_id)
          .collection("job_opening")
          .doc(job_id)
          .update({"job_status": _groupValue}).then((value) {
        print("working");
        try {
          firestoreInstance.collection("jobs").get().then((value) {
            for (int i = 0; i < value.docs.length; i++) {
              String current_doc = value.docs[i].id.toString();
              try {
                firestoreInstance
                    .collection("jobs")
                    .doc(value.docs[i].id.toString())
                    .get()
                    .then((value) {
                  Map<String, dynamic>? h = value.data();
                  if (h != null) {
                    _jobsearchresponse = jobSearchResponse.fromJson(h);
                    print(_jobsearchresponse!.job_id);
                    if (_jobsearchresponse!.job_id == job_id) {
                      firestoreInstance
                          .collection("jobs")
                          .doc(current_doc)
                          .update({"job_status": _groupValue}).then((value) {
                        AwesomeDialog(
                            context: context,
                            animType: AnimType.SCALE,
                            headerAnimationLoop: true,
                            dialogType: DialogType.SUCCES,
                            showCloseIcon: true,
                            title: 'Succes',
                            desc: "job status updated successfully",
                            btnOkOnPress: () {
                              debugPrint('OnClcik');
                              get_jobs();
                            },
                            btnOkIcon: Icons.check_circle,
                            onDissmissCallback: (type) {
                              debugPrint('Dialog Dissmiss from callback $type');
                            })
                          ..show();
                      });
                    }
                  }
                }).whenComplete(() {
                  developer.log("my data g       ");
                  setState(() {});
                });
              } catch (e) {
                print(e.toString());
              }
            }
          });
        } catch (e) {
          print(e.toString());
        }
      });
    } catch (e) {
      _displaySnackBar(context, "No data Found");
    }
  }

  /// get inactive jobs ////////////////////////////////////////////////////////
  Future<String?> get_inactive_jobs() async {
    inactive_job = [];
    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("job_opening")
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          try {
            firestoreInstance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("job_opening")
                .doc(value.docs[i].id.toString())
                .get()
                .then((value) {
              Map<String, dynamic>? h = value.data();
              developer.log("my Active job       " +
                  h.toString() +
                  "    " +
                  h!['job_status'].toString());
              if (h != null) {
                _jobsearchresponse = jobSearchResponse.fromJson(h);
                if (_jobsearchresponse!.jobStatus == "Inactive")
                  inactive_job!.add(_jobsearchresponse!);
                developer.log("my data g       " +
                    h.toString() +
                    "    " +
                    _jobsearchresponse!.jobStatus);
              } else {
                _displaySnackBar(context, "No data found...");
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
}
