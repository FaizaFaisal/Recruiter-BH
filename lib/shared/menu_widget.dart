import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_search_app/colors.dart' as color;

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
      color: color.AppColor.welcomeImageContainer,
      onPressed: () => ZoomDrawer.of(context)!.toggle(),
      icon: Icon(Icons.short_text));
}
