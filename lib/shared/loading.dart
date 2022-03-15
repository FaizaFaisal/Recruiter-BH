import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_search_app/colors.dart' as color;

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.AppColor.white,
      child: Center(
        child: SpinKitChasingDots(
          color: color.AppColor.welcomeImageContainer,
          size: 50.0,
        ),
      ),
    );
  }
}
