import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/seeker/widgets/apply_job.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
import 'package:job_search_app/shared/screens.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:page_transition/page_transition.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("favourite")
            //.where('userDocId', isEqualTo: user!.uid)
            .snapshots(includeMetadataChanges: true),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading();
          if (snapshot.hasData && snapshot.data!.size == 0) {
            return Scaffold(
              backgroundColor: color.AppColor.white,
              appBar: menuAppBar(context, 'Favourites'),
              body: Center(
                child: Text(
                  " Oh ! You don't have any saved Jobs ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: color.AppColor.white,
            appBar: menuAppBar(context, 'Favourites'),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              //reverse: true,
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Column(
                      children: snapshot.data!.docs.map((result) {
                        return
                          GestureDetector(
                            onTap: ()
                            {
                              Navigator.push(context,
                                  PageTransition(
                                      child: ApplyJob(id: result['job_id'], company: result['company_name'],company_id: "",job_id: result['job_id'],user_name:user!.displayName.toString(),contact_number: user!.phoneNumber.toString(),resume: "",), type: PageTransitionType.fade));
                            },
                            child: card(
                              result['job_title'].toString(),
                              result['company_name'],
                              result['city'],"",
                              //result['company_id'],
                              result['job_id']),
                          );
                      }).toList(),
                    ),
                    const SizedBox(height: 15),
                    OutlinedButton(
                      child: new Text(
                        "Remove All",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("favourite")
                            .get()
                            .then((snapshot) => {
                                  for (DocumentSnapshot ds in snapshot.docs)
                                    {
                                      ds.reference.delete(),
                                    },
                                });
                      },
                      style: OutlinedButton.styleFrom(
                        primary: color.AppColor.welcomeImageContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        side: BorderSide(
                            width: 2, color: Colors.blueGrey.shade300),
                        fixedSize: Size(295, 55),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget card(String title, String company, String location, String userId,
      String jobId) {
    return Card(
      color: Colors.white,
      elevation: 8.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: color.AppColor.welcomeImageContainer),
            ),
            const SizedBox(height: 5),
            Text(
              company,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: color.AppColor.welcomeImageContainer),
            ),
            const SizedBox(height: 5),
            Text(
              location,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: color.AppColor.welcomeImageContainer),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("favourite")
                        .where('job_id', isEqualTo: jobId)
                        .get()
                        .then((snapshot) => {
                              for (DocumentSnapshot ds in snapshot.docs)
                                {
                                  ds.reference.delete(),
                                },
                            });
                  },
                  icon: Icon(Icons.bookmark_remove,
                      color: Colors.redAccent, size: 25),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
