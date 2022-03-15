import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_search_app/colors.dart' as color; // Required Imports
import 'package:job_search_app/shared/screens.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: color.AppColor.homePageBackground,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 5, top: 2, right: 5, bottom: 2),
            alignment: Alignment.topCenter,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.3), BlendMode.srcOver),
              child: Image(
                image: AssetImage('assets/images/welcome.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.06,
          ),
          Text(
            'Recruiter Bh',
            textDirection: TextDirection.ltr,
            style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: color.AppColor.welcomeImageContainer),
          ),
          Container(
            child: GradientText(
              'Recruitment made easy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
              ),
              gradient: LinearGradient(colors: [
                Color(0xFF7f7fd5),
                Color(0xFF86a8e7),
                Color(0xFF91eae4)
              ]),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EmployeeLoginScreen(),
                    ),
                  ),
                  child: Text(
                    'Hire Talents',
                    style: GoogleFonts.roboto(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 55),
                    primary: color.AppColor.welcomeButton,
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  ),
                  child: Text(
                    'Search Jobs',
                    style: GoogleFonts.roboto(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 55),
                    primary: color.AppColor.welcomeButton,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
