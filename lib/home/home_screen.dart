import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/dashboard_screen.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/krs/krs_screen.dart';
import 'package:sisfo_mobile/nilai/nilai_screen.dart';
import 'package:sisfo_mobile/notification/notification_screen.dart';
import 'package:sisfo_mobile/profile/profile_screen.dart';

import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/bottomNavigation.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List currentHome = [
    DashboardScreen(),
    KrsScreen(),
    NilaiScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeProvider>().initial());
  }

  @override
  Widget build(BuildContext context) {
    final watchHome = context.watch<HomeProvider>();
    return Scaffold(
      bottomNavigationBar: BottomBar(),
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
      body: currentHome[watchHome.index],
    );
  }
}
