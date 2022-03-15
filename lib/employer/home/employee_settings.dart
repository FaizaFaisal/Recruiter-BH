import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/employer/home/employee_profile.dart';
import 'package:job_search_app/employer/home/reset_password.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
import 'package:job_search_app/colors.dart' as color;

class EmployeeSettingScreen extends StatefulWidget {
  const EmployeeSettingScreen({Key? key}) : super(key: key);

  @override
  _EmployeeSettingScreenState createState() => _EmployeeSettingScreenState();
}

class _EmployeeSettingScreenState extends State<EmployeeSettingScreen> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.white,
      appBar: customAppBarEmployer(context, 'Settings'),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EmployeeProfileScreen()));
              },
              child: Card(
                shadowColor: color.AppColor.welcomeImageContainer,
                child: Container(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_circle,
                                color: color.AppColor.welcomeImageContainer),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Profile',
                              style: GoogleFonts.lato(
                                  color: color.AppColor.welcomeImageContainer,
                                  fontSize: 16),
                            )
                          ],
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ResetPasswordEmployer()));
              },
              child: Card(
                shadowColor: color.AppColor.welcomeImageContainer,
                child: Container(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lock,
                                color: color.AppColor.welcomeImageContainer),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Privacy and Security',
                              style: GoogleFonts.lato(
                                  color: color.AppColor.welcomeImageContainer,
                                  fontSize: 16),
                            )
                          ],
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
