import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseSeekerService {
  final String uid;
  var name = "";
  var education = "";
  var experience = "";
  var skills = "";
  var about = "";
  var address = "";
  var photoURL = "";
  var userRole;
  DatabaseSeekerService({required this.uid});
  // collection refrence
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference jobCollection =
      FirebaseFirestore.instance.collection('jobs');
  final CollectionReference favCollection =
      FirebaseFirestore.instance.collection('favs');
  final storage = new FlutterSecureStorage();
  // Add new registered USER -- JOB SEEKER data to collection through function
  Future<void> addjobSeeker(
      String name,
      String education,
      String experience,
      String skills,
      String address,
      String phone,
      String email,
      String about) async {
    return await userCollection
        .doc(uid)
        .set(
          {
            'name': name,
            'education': education,
            'experience': experience,
            'skills': skills,
            'address': address,
            'phone': phone,
            'email': email,
            'about': about,
            'userRole': 'Seeker',
            'photoURL': 'assets/images/user_default.png',
          },
          SetOptions(merge: true),
        )
        .then((value) =>
            print("Job Seeker added and  merged with existing data!"))
        .catchError((error) => print("Failed to add Job Seeker: $error"));
  }

  // Update JOB SEEKER
  Future<void> updateUser(
      name, education, experience, skills, about, address) async {
    return await userCollection
        .doc(uid)
        .update(
          {
            'name': name,
            'education': education,
            'experience': experience,
            'skills': skills,
            'address': address,
            'about': about,
          },
        )
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  // APPLY FOR JOB
  Future<void> applyJob(String docId) async =>
      await jobCollection.doc(docId).collection('appliedJobs').add({
        "name": 'name',
        "email": 'email',
        "userId": uid,
        "phone": 'phone',
      });
  // USER AUTHENCTICATION FOR ACCESS
  checkUserRole() {
    FutureBuilder<DocumentSnapshot>(
      future: userCollection.doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          //userRole = data['userRole'];
          // print(data['userRole']);
          return Text("${data['userRole']}");
        }

        return Text("loading");
      },
    );
  }

  // LOGOUT
  logout() async {
    await storage.delete(key: "uid");
    await storage.delete(key: "role");
    await storage.deleteAll();
    print("Keys are deleted ");
    await FirebaseAuth.instance.signOut();
  }

  // ADD JOBS TO LIKES
  Future<void> addFavourites(String jobId, String userId, String job,
      String company, String location, bool isFav) async {
    return await favCollection.doc().set({
      "jobDocId": jobId,
      "userDocId": userId,
      "jobTitle": job,
      "jobCompany": company,
      "jobLocation": location,
      "isFav": isFav,
    });
  }
}
