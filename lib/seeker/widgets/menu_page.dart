import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_search_app/seeker/widgets/models/menuItem.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/shared/screens.dart';

class MenuItems {
  // Account Logout Setting -- for Custom AppBar Popup menu
  static const List<MenuItemModel> itemsFirst = [
    account,
  ];
  static const List<MenuItemModel> itemsSecond = [
    logout,
  ];
  static const itemSettings =
      MenuItemModel('Settings', Icons.settings_applications);
  static const account = MenuItemModel('Account', Icons.account_circle_rounded);
  static const logout = MenuItemModel('Logout', Icons.logout);

  // Seeker Navigation Drawer
  static const home = MenuItemModel('Home', Icons.home);
  static const profile = MenuItemModel('Profile', Icons.person);
  static const jobs = MenuItemModel('My Jobs', Icons.work);
  static const favourite = MenuItemModel('Favourites', Icons.favorite_outline);
  static const password =
      MenuItemModel('Change Password', FontAwesomeIcons.lock);

  static const trending =
      MenuItemModel('Trending ', Icons.trending_up_outlined);
  static const exploreJobs =
      MenuItemModel('ExploreJobs ', Icons.explore_outlined);

  static const all = <MenuItemModel>[
    home,
    profile,
    jobs,
    favourite,
    password,
    trending,
    exploreJobs,
    logout,
  ];
}

class MenuPage extends StatefulWidget {
  final MenuItemModel currentItem;
  final ValueChanged<MenuItemModel> onSelectedItem;

  const MenuPage(
      {Key? key, required this.currentItem, required this.onSelectedItem})
      : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
            username = h['name'];
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
        backgroundColor: Colors.white,
        body: Theme(
          data: ThemeData.light(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              SizedBox(
                width: 5,
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 20.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        //avatar1.png  user_profile.jpg
                        backgroundImage: NetworkImage(pic),
                        // AssetImage('assets/images/default_user.png'),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      username.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: color.AppColor.welcomeImageContainer,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              ...MenuItems.all.map(buildMenuItem).toList(),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ));
  }

  Widget buildMenuItem(MenuItemModel item) => ListTileTheme(
        selectedColor: color.AppColor.welcomeImageContainer,
        child: ListTile(
          selectedTileColor:
              Colors.transparent, // Set to other color to make it visible
          selected: widget.currentItem == item,
          minLeadingWidth: 20,
          leading: Icon(item.icon),
          title: Text(item.title),
          onTap: () => widget.onSelectedItem(item),
        ),
      );
}
