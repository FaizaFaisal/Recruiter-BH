import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_search_app/employer/home/employee_settings.dart';
import 'package:job_search_app/employer/home/candidates.dart';
import 'package:job_search_app/employer/home/schedule_interview.dart';
import 'package:job_search_app/employer/widgets/menuScreen.dart';
import 'package:job_search_app/seeker/widgets/menu_page.dart';
import 'package:job_search_app/seeker/widgets/models/menuItem.dart';
import 'package:job_search_app/services/database_employer.dart';
import 'package:job_search_app/shared/screens.dart';
import 'package:job_search_app/colors.dart' as color;

class NavZoomDrawer extends StatefulWidget {
  const NavZoomDrawer({Key? key}) : super(key: key);

  @override
  _NavZoomDrawerState createState() => _NavZoomDrawerState();
}

class _NavZoomDrawerState extends State<NavZoomDrawer> {
  User? user = FirebaseAuth.instance.currentUser;
  MenuItemModel currentItem = MenuItems.home;
  final _drawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) => ZoomDrawer(
        controller: _drawerController,
        style: DrawerStyle.Style4, // Best Style 1, 4, == OK Style 6,7
        disableGesture: false,
        mainScreen: getScreen(),
        menuScreen: Builder(
          builder: (context) => MenuScreenEmployer(
            currentItem: currentItem,
            onSelectedItem: (item) {
              setState(() => currentItem = item);
              if (_drawerController.isOpen!()) {
                _drawerController.close!();
              }
            },
          ),
        ),
        borderRadius: 40.0,
        showShadow: true,
        angle: -10,
        backgroundColor: color.AppColor.gradientSecond,
        slideWidth: MediaQuery.of(context).size.width * 0.55,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
      );
  Widget getScreen() {
    switch (currentItem) {
      case MenuScreenItems.home:
        return EmployeeHomeScreen();
      case MenuScreenItems.jobOpening:
        return JobOpeningScreen();
      case MenuScreenItems.candidates:
        return CandidatesScreen();
      // case MenuScreenItems.interviews:
      //   return ScheduleInterviewScreen();

      case MenuScreenItems.settings:
        return EmployeeSettingScreen();
      case MenuScreenItems.logout:
        DatabaseEmployerService(uid: user!.uid).logout();
        return EmployeeLoginScreen();
      case MenuScreenItems.editJobs:
        return EditJobs();
      default:
        return EmployeeHomeScreen(); // HomeScreen default page
    }
  }
}
