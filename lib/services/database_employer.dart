import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseEmployerService {
  final String uid;

  DatabaseEmployerService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference jobsCollection =
      FirebaseFirestore.instance.collection('jobs');

  final storage = new FlutterSecureStorage();

  Future<void> addEmployer(
    String companyName,
    String companyEmail,
    String companyPhone,
  ) async {
    return await userCollection
        .doc(uid)
        .set(
          {
            'companyName': companyName,
            'companyEmail': companyEmail,
            'companyPhone': companyPhone,
            'userRole': 'Employer',
          },
          SetOptions(merge: true),
        )
        .then(
            (value) => print("Employer added and  merged with existing data!"))
        .catchError((error) => print("Failed to add Employer: $error"));
  }

  logout() async {
    await storage.delete(key: "uid");
    await storage.delete(key: "role");
    await storage.deleteAll();
    print("Keys are deleted ");
    await FirebaseAuth.instance.signOut();
  }

  Future<void> addJobOpening(
    String title,
    String company,
    String recruiter,
    String dateOpen,
    String dateClose,
    String jobType,
    String experience,
    String industry,
    String skills,
    double salary,
    String city,
    String country,
    String description,
    String responsibility,
    String role,
    String? email,
  ) async {
    return await jobsCollection
        .doc()
        .set(
          {
            'title': title,
            'company': company,
            'recruiter': recruiter,
            'dateOpen': dateOpen,
            'dateClose': dateClose,
            'jobType': jobType,
            'experience': experience,
            'industry': industry,
            'skills': skills,
            'salary': salary,
            'city': city,
            'country': country,
            'description': description,
            'responsibility': responsibility,
            'role': role,
            'email': email,
            'createdAt': DateTime.now(),
          },
          SetOptions(merge: true),
        )
        .then((value) =>
            print("Employer job post  added and  merged with existing data!"))
        .catchError((error) => print("Failed to add Employer: $error"));
  }
}
