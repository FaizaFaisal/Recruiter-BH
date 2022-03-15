import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_search_app/shared/loading.dart';

class DrawerMenuWidget extends StatefulWidget {
  final Function(String)? onItemClick;

  const DrawerMenuWidget({Key? key, this.onItemClick}) : super(key: key);

  @override
  State<DrawerMenuWidget> createState() => _DrawerMenuWidgetState();
}

class _DrawerMenuWidgetState extends State<DrawerMenuWidget> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          print('Something Went Wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Loading(),
          );
        } else {
          var data = snapshot.data!.data();
          var name = data!['name'];
          var email = data['email'];
          String pic = "";
          if (data['photoURL'] != null && data['photoURL'] != "") {
            pic = data['photoURL'];
          } else {
            pic =
                "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";
          }
          return Container(
            //color: Colors.purple,
            //color: Color.fromRGBO(50, 75, 205, 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                colors: [
                  Color(0xFF000046),
                  Color(0xFF1CB5E0),
                ],
              ),
            ),
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    //avatar1.png  user_profile.jpg
                    radius: 60,
                    backgroundImage: NetworkImage(pic),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'BalsamiqSans'),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  email,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'BalsamiqSans'),
                ),
                SizedBox(
                  height: 20,
                ),
                sliderItem('Home', Icons.home),
                sliderItem('Job Openings', Icons.add_circle),
                sliderItem('Candidates', CupertinoIcons.person_badge_plus_fill),
                sliderItem('Edit Jobs', Icons.edit_attributes),
                sliderItem('Setting', Icons.settings),
                sliderItem('Logout', Icons.logout),
              ],
            ),
          );
        }
      },
    );
  }

  Widget sliderItem(String title, IconData icons) => ListTile(
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'BalsamiqSans_Regular'),
      ),
      leading: Icon(
        icons,
        color: Colors.white,
      ),
      onTap: () {
        widget.onItemClick!(title);
      });
}
