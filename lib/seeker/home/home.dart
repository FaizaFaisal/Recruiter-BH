import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_search_app/seeker/widgets/models/menuItem.dart';
import 'package:job_search_app/seeker/widgets/work.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
// Required Packages
import 'package:job_search_app/shared/screens.dart'; // Required Imports
import 'package:job_search_app/colors.dart' as color;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var photo = "";
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      var fields = value.data();
      setState(() {
        photo = fields!['photoURL'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          backgroundColor: color.AppColor.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme:
                IconThemeData(color: color.AppColor.welcomeImageContainer),
            actionsIconTheme:
                IconThemeData(color: color.AppColor.welcomeImageContainer),
            titleTextStyle: TextStyle(
              color: color.AppColor.welcomeImageContainer,
              fontSize: 20,
              fontFamily: 'BalsamiqSans_Regular',
              fontWeight: FontWeight.w500,
            ),
            title: Text(
              'Home',
              textAlign: TextAlign.left,
            ),
            leading: IconButton(
                color: color.AppColor.welcomeImageContainer,
                onPressed: () => ZoomDrawer.of(context)!.toggle(),
                icon: Icon(Icons.short_text)),
            actions: <Widget>[
              PopupMenuButton<MenuItemModel>(
                  shape: BeveledRectangleBorder(),
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) => [
                        ...MenuItems.itemsFirst.map(buildItem).toList(),
                        PopupMenuDivider(),
                        ...MenuItems.itemsSecond.map(buildItem).toList(),
                      ]),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Work(), // WORK WIDGET contain Search recent and all
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async => true);
  }
}
