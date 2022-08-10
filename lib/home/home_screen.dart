import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/home/widgets/fitur_home_widget.dart';
import 'package:sisfo_mobile/home/widgets/info_banner_widget.dart';
import 'package:sisfo_mobile/home/widgets/welcome_header.dart';
import 'package:sisfo_mobile/notification/notification_screen.dart';

import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/bottomNavigation.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeProvider>().initial());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(tabIndex: 0, label: 'Home'),
      appBar: AppBar(
        backgroundColor: config.colorPrimary,
        leading: Container(
          margin: EdgeInsets.all(6),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(config.logoPath),
            fit: BoxFit.fill,
          )),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => NotificationScreen())),
            child: Stack(alignment: Alignment.centerLeft, children: <Widget>[
              new Icon(LineIcons.bell),
              new Positioned(
                // draw a red marble
                top: 15,
                right: 5,
                child: new Icon(
                  Icons.brightness_1,
                  size: 8.0,
                  color: config.colorSecondary,
                ),
              )
            ]),
          )
        ],
        title: Text(
          'STIKES Gunung Sari',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
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
      )),
    );
  }
}
