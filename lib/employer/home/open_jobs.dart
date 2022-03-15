
import 'package:job_search_app/colors.dart' as color;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_search_app/seeker/widgets/apply_job.dart';
import 'package:job_search_app/shared/loading.dart';
import 'package:page_transition/page_transition.dart';

class open_job extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => _open_job();


}

class _open_job extends State<open_job>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user").doc(user!.uid).collection("job_opening")
        //.where('userDocId', isEqualTo: user!.uid)
            .snapshots(includeMetadataChanges: true),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading();
          if (snapshot.hasData && snapshot.data!.size == 0) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(title: Text("jobs",style: TextStyle(fontSize: 20),)),
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
            backgroundColor: Colors.white,
            appBar: AppBar(title: Text("jobs",style: TextStyle(fontSize: 20),)),
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
                             // Navigator.push(context, PageTransition(child: ApplyJob(id: result['job_id'], company: result['company_name'],company_id: "",job_id: result['job_id'],user_name:user!.displayName.toString(),contact_number: user.phoneNumber.toString()), type: PageTransitionType.fade));
                            },
                            child: card(
                                result['job_title'].toString(),
                                result['job_type'],
                                result['city'],
                                "",
                                result['job_id']),
                          );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        });

  }

  Widget card(String title, String jobType, String location, String userId, String jobId) {
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
              jobType,
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
          ],
        ),
      ),
    );
  }

}