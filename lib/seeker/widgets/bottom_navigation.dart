import 'package:flutter/material.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/shared/screens.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;
  String currentScreen = "";

  void _onItemTapped(int tabIndex) {
    if(tabIndex != _selectedIndex)
      {
        switch (tabIndex) {
          case 0:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
            break;
          case 1:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            );
            break;
          case 2:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangePassword(),
              ),
            );
            break;
        }
        setState(() {
          _selectedIndex = tabIndex;
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon:  Icon(Icons.home),
         /* IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            ),
          ),*/
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          /*IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            ),
          ),*/
          label: 'My Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          /*IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangePassword(),
              ),
            ),
          ),*/
          label: 'Change Password',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: color.AppColor.welcomeImageContainer,
      onTap: _onItemTapped,
    );
  }
}
