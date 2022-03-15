import 'package:flutter/material.dart';
import 'package:job_search_app/shared/screens.dart'; // Required  Import file
import 'package:flutter_signin_button/flutter_signin_button.dart'; // Required Packages import
import 'package:provider/provider.dart';
import '../../controller/google_login_controller.dart';

class GoogleLoginScreen extends StatefulWidget {
  @override
  _GoogleLoginScreenState createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.white, Colors.transparent],
          ).createShader(rect),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.white,
          body: loginUI(),
        )
      ],
    );
  }

  loginUI() {
    // Function that returns UI after checking logged in or not
    return Consumer<GoogleSignInController>(
      builder: (context, model, child) {
        if (model.googleAccount != null) {
          return Center(
            child: loggedInUI(model),
          );
        } else {
          return loginControls(context);
        }
      },
    );
  }

  loggedInUI(GoogleSignInController model) {
    // Logged In UI behaviour
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage:
              Image.network(model.googleAccount!.photoUrl ?? '').image,
          radius: 60.0,
        ),
        Text(model.googleAccount!.displayName ?? ''),
        Text(model.googleAccount!.email),
        ActionChip(
          avatar: Icon(Icons.logout),
          label: Text("Logout"),
          onPressed: () {
            Provider.of<GoogleSignInController>(context, listen: false)
                .logout();
          },
        )
      ],
    );
  }

  loginControls(BuildContext context) {
    // Not logged In display signin button
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Image(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
          Center(
            child: Text(
              'Job Search',
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: SignInButton(
              Buttons.GoogleDark,
              onPressed: () =>
                  Provider.of<GoogleSignInController>(context, listen: false)
                      .login(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: SignInButton(
              Buttons.Email,
              text: 'Sign Up with Email',
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
