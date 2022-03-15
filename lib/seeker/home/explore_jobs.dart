import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/seeker/widgets/apply_job.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
import 'package:page_transition/page_transition.dart';
import '../../jobSearchResponse.dart';

class ExploreJobs extends StatefulWidget {
  const ExploreJobs({Key? key}) : super(key: key);

  @override
  _ExploreJobsState createState() => _ExploreJobsState();
}

class _ExploreJobsState extends State<ExploreJobs> {
  User? user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Timestamp timestamp;
  jobSearchResponse? _jobsearchresponse;
  var name = "";
  String resume = "";
  var docs;
  List<jobSearchResponse>? business_lst;
  List<String>? id;

  @override
  void initState() {
    super.initState();
    get_jobs_data();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      var fields = value.data();
      setState(() {
        name = fields!['name'] as String;
        name = name.split(' ').elementAt(0);
        try {
          resume = fields!["resume"] ?? "no resume";
        } catch (e) {
          resume = "no resume";
          print(e.toString());
        }
      });
      print(fields!['name'] as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: menuAppBar(
        context,
        "Explore Jobs ",
      ),
      body: ListView(
        shrinkWrap: true,
        reverse: true,
        children: [
          if (business_lst!.length > 0) verticalJobList(),
        ],
      ),
    );
  }

  Widget verticalJobList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              scrollDirection: Axis.vertical,
              itemCount: business_lst!.length,
              itemBuilder: (context, item) {
                // final DateTime time1 = DateTime.parse(business_lst![item].dateOpen);
                // print(timeago.format(time1));
                var country = business_lst![item].country;
                country = country.split(' ').elementAt(0);

                return listJob(
                    id![item].toString(),
                    business_lst![item].title,
                    business_lst![item].company,
                    country,
                    business_lst![item].dateOpen,
                    business_lst![item].jobType,
                    business_lst![item].company_id,
                    business_lst![item].job_id,
                    business_lst![item].description,
                    business_lst![item].role);
              })),
    );
  }

  Widget listJob(
          String docId,
          String position,
          String company,
          String location,
          String time,
          String type,
          String company_id,
          String job_id,
          String description,
          String role) =>
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: ApplyJob(
                    id: docId,
                    company: company,
                    company_id: company_id,
                    job_id: job_id,
                    contact_number: user!.phoneNumber.toString(),
                    user_name: user!.displayName.toString(),
                    resume: resume,
                  ),
                  type: PageTransitionType.fade));
        },
        child: Theme(
          data: ThemeData(primarySwatch: Colors.indigo),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTileCard(
              baseColor: Colors.indigo[50],
              expandedColor: Colors.white,
              title: Text(position,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: color.AppColor.welcomeImageContainer,
                  )),
              subtitle: Text(description,
                  style: TextStyle(
                    fontSize: 16,
                    color: color.AppColor.welcomeImageContainer,
                  )),
              children: [
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
                      "Role : " + role,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 18,
                          color: color.AppColor.homePagePlanColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  /// Get  data against title ////////////////////////////////////////////////////////
  // ignore: non_constant_identifier_names
  get_jobs_data() async {
    business_lst = [];
    id = [];

    try {
      firestoreInstance.collection("jobs").get().then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          try {
            id!.add(value.docs[i].id.toString());
            firestoreInstance
                .collection("jobs")
                .doc(value.docs[i].id.toString())
                .get()
                .then((value) {
              Map<String, dynamic>? h = value.data();
              if (h != null) {
                _jobsearchresponse = jobSearchResponse.fromJson(h);

                if (_jobsearchresponse!.jobStatus == "Active")
                  business_lst!.add(_jobsearchresponse!);
              }
            }).whenComplete(() {
              if (business_lst!.length > 1)
                business_lst!.sort((a, b) => a.dateOpen.compareTo(b.dateOpen));
              developer
                  .log("my data g       " + business_lst!.length.toString());
              setState(() {});
            });
          } catch (e) {
            print(e.toString());
          }
        }
      });
    } catch (e) {
      _displaySnackBar(context, "No Business Found");
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
