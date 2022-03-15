import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_search_app/employer/home/open_jobs.dart';
import 'package:job_search_app/employer/home/candidates.dart';
import 'package:job_search_app/seeker/widgets/models/menuItem.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/shared/screens.dart';

class MenuScreenItems {
  static const home = MenuItemModel('Home', Icons.home);

  // Recruiter Navigation Drawer
  static const jobOpening = MenuItemModel('Job Openings', Icons.work_rounded);
  static const candidates =
      MenuItemModel('Candidates', CupertinoIcons.person_badge_plus_fill);

  static const editJobs = MenuItemModel('Edit Jobs', Icons.edit_attributes);
  static const logout = MenuItemModel('Logout', Icons.logout);
  static const settings = MenuItemModel('Settings', Icons.settings);

  static const rec = <MenuItemModel>[
    home,
    jobOpening,
    candidates,
    editJobs,
    settings,
    logout,
  ];
}

class MenuScreenEmployer extends StatefulWidget {
  final MenuItemModel currentItem;
  final ValueChanged<MenuItemModel> onSelectedItem;
  const MenuScreenEmployer(
      {Key? key, required this.currentItem, required this.onSelectedItem})
      : super(key: key);

  @override
  State<MenuScreenEmployer> createState() => _MenuScreenEmployerState();
}

class _MenuScreenEmployerState extends State<MenuScreenEmployer> {
  User? user = FirebaseAuth.instance.currentUser;
  final storage = new FlutterSecureStorage();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username = "";
  String pic = "";
  String? uid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((value) {
        Map<String, dynamic>? h = value.data();
        if (h != null) {
          setState(() {
            uid = user?.uid;
            username = h['companyName'];
            if (h['photoURL'] != null && h['photoURL'] != "") {
              pic = h['photoURL'];
            } else {
              pic =
                  "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";
            }
          });
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromRGBO(50, 75, 205, 1),
      backgroundColor: color.AppColor.white,
      body: Theme(
          data: ThemeData.light(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Expanded(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        //avatar1.png  user_profile.jpg
                        backgroundImage: NetworkImage(pic),
                      ),
                    ),
                  ),
                  Text(
                    username.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: color.AppColor.welcomeImageContainer,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ]),
              ),
              ...MenuScreenItems.rec.map(buildMenuItem).toList(),
              Spacer(
                flex: 2,
              ),
            ],
          )),
    );
  }

  Widget buildMenuItem(MenuItemModel item) => ListTileTheme(
        selectedColor: color.AppColor.welcomeImageContainer,
        child: ListTile(
          selectedTileColor:
              Colors.transparent, // Set to other color to make it visible
          selected: widget.currentItem == item,
          minLeadingWidth: 30,
          leading: Icon(item.icon),
          title: Text(item.title),
          onTap: () => widget.onSelectedItem(item),
        ),
      );
}
