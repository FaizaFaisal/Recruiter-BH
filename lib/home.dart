import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
// Required Packages
import 'package:job_search_app/shared/screens.dart'; // Required Imports
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/seeker/widgets/apply_job.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  var name = "";
  String resume = "";
  var docs;
  late Timestamp timestamp;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    // get the name
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      var fields = value.data();
      setState(() {
        name = fields!['name'] as String;
        name = name.split(' ').elementAt(0);
        try{
          resume = fields!["resume"] ?? "no resume";
        }
        catch (e)
        {
          resume = "no resume";
          print(e.toString());
        }

      });
      print(fields!['name'] as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            backgroundColor: color.AppColor.white,
            appBar: menuAppBar(context, 'Home'),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          /** Greetings */
                          Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 170,
                                            child: Text('Hello ' + name + '!',
                                                style: GoogleFonts.lato(fontSize: 18, color: color.AppColor.matteBlack)),
                                          ),
                                          Container(
                                            width: 170,
                                            child: Text('Find your perfect job',
                                                style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold, color: color.AppColor.welcomeImageContainer)),
                                          )
                                        ],
                                      )),
                                ],
                              )),
                          /** Search Controller*/
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width - 90,
                                    child: TextField(
                                      cursorColor: color.AppColor.welcomeImageContainer,
                                      style: GoogleFonts.lato(),
                                      decoration: InputDecoration(hintText: 'Search Job', hintStyle: TextStyle(color: color.AppColor.welcomeImageContainer),
                                        suffixIcon: Icon(Icons.search, color: color.AppColor.welcomeImageContainer,),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.1, color: color.AppColor.welcomeImageContainer),),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.5, color: color.AppColor.welcomeImageContainer),),
                                      ),
                                    )),
                                IconButton(icon: Icon(Icons.tune, color: color.AppColor.matteBlack), onPressed: () {},)
                              ],
                            ),
                          ),
                          /** Job Categories*/
                          Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                            width: 150,
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: Text('Job Categories',
                                                  style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold,color: color.AppColor.welcomeImageContainer)),))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 30,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          industry(0, 'All'),
                                          industry(1, 'Government'),
                                          industry(2, 'Communications'),
                                          industry(3, 'Technology'),
                                          industry(4, 'Education'),
                                          industry(5, 'IT Services'),
                                          industry(6, 'RealState'),
                                          industry(7, 'Pharma'),
                                          industry(8, 'Consulting'),
                                          industry(9, 'Health Care'),
                                          industry(10, 'Financial Services'),
                                          industry(11, 'Construction'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          /** 
                           * Recommended Jobs --(Line--245) Function on for displaying horizantal list  */
                          recommendedJobList(),
                          /**
                           *  Recent Jobs posted not less tham one week ago 
                           * verical scroll list  -- have to display here 
                           */
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Navigation Bar
            bottomNavigationBar: BottomNavigation()),
        onWillPop: () async => true);
  }

  // Category Item
  industry(int index, String title) => Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          height: 50,
          width: 105,
          decoration: BoxDecoration(
              color: (_currentIndex != index)
                  ? color.AppColor.white
                  : color.AppColor.welcomeImageContainer,
              border: Border.all(
                  color: color.AppColor.welcomeImageContainer, width: 0.5),
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(title,
                style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: (_currentIndex != index)
                        ? color.AppColor.welcomeImageContainer
                        : color.AppColor.white)),
          ),
        ),
      ));

  // Recomended Job List
  recommendedJobList() => FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('jobs').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          // Heading
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text('Recommended Jobs',
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: color.AppColor.welcomeImageContainer)),
                        ))),
              ),
              // Content of List as in card1, card2
              Container(
                  height: 180,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: ListView(
                      shrinkWrap: true,
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs.map((result) {
                        timestamp = result['createdAt'];
                        var country = result['country'] as String;
                        country = country.split(' ').elementAt(0);
                        return Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: InkWell(
                                onTap: () {
                                  // Go to Apply Job Page -- which takes 3 parameter (JobID,CompanyName,EmployerEmail),
                                  /** Location for file-- Apply Job Page
                                   *  Seeker -- widgets folder - apply_job.dart
                                  */
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: ApplyJob(
                                              id: result.id,
                                              company: result['company'],
                                            company_id: result['company_id'], job_id: result['job_id'],user_name: user!.displayName.toString(),contact_number: user!.phoneNumber.toString(),resume: resume,
                                          ),
                                          type: PageTransitionType.fade));
                                },
                                child: Card(
                                  shadowColor:
                                      color.AppColor.welcomeImageContainer,
                                  child: Container(
                                    width: 285,
                                    height: 180,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(result['title'],
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: color.AppColor
                                                    .welcomeImageContainer)),
                                        Text(
                                          result['company'],
                                          style: GoogleFonts.lato(
                                              fontSize: 18,
                                              color: color.AppColor
                                                  .welcomeImageContainer),
                                        ),
                                        Text(
                                          country,
                                          style: GoogleFonts.lato(
                                              fontSize: 18,
                                              color: color.AppColor
                                                  .welcomeImageContainer),
                                        ),
                                        Divider(),
                                        Container(
                                          width: 325,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.access_time,
                                                      color: color.AppColor
                                                          .welcomeImageContainer),
                                                  Text(
                                                      timeago.format(
                                                          timestamp.toDate()),
                                                      style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                          color: color.AppColor
                                                              .welcomeImageContainer))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.work,
                                                    color: color.AppColor
                                                        .welcomeImageContainer,
                                                  ),
                                                  Text(result.get('jobType'),
                                                      style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                          color: color.AppColor
                                                              .welcomeImageContainer))
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )));
                      }).toList(),
                    ),
                  )),
            ],
          );
        }
        return Loading();
      });
}