import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/services/database_seeker.dart';
import 'package:job_search_app/shared/screens.dart';

class ApplyJob extends StatefulWidget {
  final String id;
  final String company;
  final String email;
  const ApplyJob(
      {Key? key, required this.id, required this.company, required this.email})
      : super(key: key);

  @override
  _ApplyJobState createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  User? user = FirebaseAuth.instance.currentUser;
  var jobTitle = "";
  var location = "";

  bool isFavorite = false;
  bool isApply = false;
  var education, skills, experience;
  @override
  void initState() {
    super.initState();
    // getting Country Name and City and formatting it for displaying
    FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.id)
        .get()
        .then((value) {
      setState(() {
        jobTitle = value['title'];
        location = "${value['country'].toString().split(' ').elementAt(0)} " +
            "(${value['city']})";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });

              // Function defined for add the Job to favourites
              /**
               * Services -> databaseSeekerService -- function -> addFavourites(JobID,UserID,Company,Location,IsFavourite)
               * 
              */
              DatabaseSeekerService(uid: user!.uid).addFavourites(widget.id,
                  user!.uid, jobTitle, widget.company, location, isFavorite);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('jobs')
              .doc(widget.id)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error! Try Again'));
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius:
                                      50, //we give the image a radius of 50 of Company Logo
                                  backgroundImage: NetworkImage(
                                      'https://webstockreview.net/images/male-clipart-professional-man-3.jpg'),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    Text(data['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: color.AppColor.welcomeImageContainer)),
                    SizedBox(
                      height: 15,
                    ),
                    // Defined Below the build widget , line 223 for formating and displaying
                    textWidget('Job Description', data['description']),
                    textWidget('Responsibilites', data['responsibility']),
                    textWidget('Skills', data['skills']),
                    textWidget('Experience', data['experience']),
                    textWidget('Role', data['role']),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        // Defined Below build widget,line 240
                        apply(widget.id);
                      },
                      child: Text(
                        "Apply",
                        style: GoogleFonts.lato(
                            color: color.AppColor.white, fontSize: 18),
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
          }),
    );
  }

  // Formatting the text
  textWidget(String text1, String text2) => Align(
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
  // Location for  FUNCTion applyJob(Jobid)
  // services --> DatabaseSeeker -- function applyJob

  apply(String id) {
    if (education == null && skills == null && experience == null) {
      AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          headerAnimationLoop: true,
          dialogType: DialogType.WARNING,
          showCloseIcon: true,
          title: 'Incomplete Profile',
          desc: 'Please Complete your Profile',
          btnOkOnPress: () {
            debugPrint('OnClcik');
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    } else
      jobApply(id);
  }

  jobApply(String id) {
    DatabaseSeekerService(uid: user!.uid).applyJob(id);
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
  }
}
