import 'package:flutter/material.dart';
import 'package:sisfo_mobile/home/widgets/fitur_home_widget.dart';
import 'package:sisfo_mobile/home/widgets/info_banner_widget.dart';
import 'package:sisfo_mobile/home/widgets/welcome_header.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 30),
            //Welcome Text
            WelcomeHeader(),
            SizedBox(height: 30),
            //InfoBanner
            InfoBannerWidget(),
            SizedBox(height: 30),
            //Menu
            FiturHomeWidget()
          ],
        ),
      ),
    ));
  }
}
