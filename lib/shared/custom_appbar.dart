import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/seeker/widgets/models/menuItem.dart';
import 'package:job_search_app/services/database_seeker.dart';
import 'package:job_search_app/shared/screens.dart';

bool stringEqual(String val1, String val2) => (val1 == val2);

// Edit Profile Page AppBar
AppBar customProfileAppBar(BuildContext context, String text, IconData icon) {
  return AppBar(
    centerTitle: true,
    iconTheme: IconThemeData(color: color.AppColor.matteBlack),
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: BackButton(
      color: color.AppColor.matteBlack,
      // onPressed: () {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
      // },
    ),
    actions: [
      IconButton(onPressed: () {}, icon: Icon(icon)),
    ],
    title: Text(text),
  );
}

// Appbar -- Employer
AppBar customAppBarEmployer(BuildContext context, String text) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: color.AppColor.welcomeImageContainer),
    actionsIconTheme:
        IconThemeData(color: color.AppColor.welcomeImageContainer),
    titleTextStyle: TextStyle(
      color: color.AppColor.welcomeImageContainer,
      fontSize: 20,
      fontFamily: 'BalsamiqSans_Regular',
      fontWeight: FontWeight.w500,
    ),
    title: Text(
      text,
      textAlign: TextAlign.left,
    ),
    leading: MenuWidget(),
  );
}

// Rest of Pages -- Appbar -- SEEKER
AppBar menuAppBar(BuildContext context, String text) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: color.AppColor.welcomeImageContainer),
    actionsIconTheme:
        IconThemeData(color: color.AppColor.welcomeImageContainer),
    titleTextStyle: TextStyle(
      color: color.AppColor.welcomeImageContainer,
      fontSize: 20,
      fontFamily: 'BalsamiqSans_Regular',
      fontWeight: FontWeight.w500,
    ),
    title: Text(
      text,
      textAlign: TextAlign.left,
    ),
    leading: MenuWidget(),
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
  );
}

PopupMenuItem<MenuItemModel> buildItem(MenuItemModel item) =>
    PopupMenuItem<MenuItemModel>(
        value: item,
        child: Container(
          width: 100,
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 20,
                color: color.AppColor.appColor,
              ),
              const SizedBox(height: 12),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    item.title,
                    style: TextStyle(color: color.AppColor.appColor),
                  )),
            ],
          ),
        ));

Future<void> onSelected(BuildContext context, MenuItemModel item) async {
  switch (item) {
    case MenuItems.account:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Profile()),
      );
      break;
    case MenuItems.itemSettings:
      break;
    case MenuItems.logout:
      User? user = FirebaseAuth.instance.currentUser;
      DatabaseSeekerService(uid: user!.uid).logout();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      break;
  }
}
