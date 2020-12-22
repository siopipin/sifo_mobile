import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/auth/login_screen.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/keuangan/keuangan_screen.dart';
import 'package:sisfo_mobile/krs/krs_screen.dart';
import 'package:sisfo_mobile/notification/notification_screen.dart';

import 'package:sisfo_mobile/nilai/nilai_screen.dart';
import 'package:sisfo_mobile/profile/profile_page_screen.dart';
import 'package:sisfo_mobile/services/firebase_notification_handler.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/bottomNavigation.dart';
import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    new FirebaseNotifications().setUpFirebase(context);
    Future.microtask(() async {
      Provider.of<HomeProvider>(context, listen: false).getDataAwal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider prov = Provider.of<HomeProvider>(context);
    final LoginProvider provLogin = Provider.of<LoginProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomBar(tabIndex: 0, label: 'Home'),
      appBar: AppBar(
        backgroundColor: appbarColor,
        leading: Container(
          margin: EdgeInsets.all(6),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fill)),
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
                child: new Icon(Icons.brightness_1,
                    size: 8.0, color: primaryYellow),
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
              //Welcome Text
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        LineIcons.user,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome",
                            style:
                                TextStyle(color: textPrimary.withOpacity(0.7)),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "${prov.isName}",
                            style: TextStyle(
                                color: textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${prov.isNIM}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await provLogin.doLogout();
                      Toast.show(provLogin.msg, context,
                          gravity: Toast.TOP, duration: 3);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    child: Column(
                      children: [
                        Icon(
                          LineIcons.sign_out,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                              fontSize: 8, color: textPrimary.withOpacity(0.8)),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),
              //InfoBanner
              InfoBanner(),

              SizedBox(
                height: 30,
              ),
              //Menu
              MenuHome()
            ],
          ),
        ),
      )),
    );
  }
}

class InfoBanner extends StatelessWidget {
  const InfoBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeProvider prov = Provider.of<HomeProvider>(context);

    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(
        color: primaryYellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 18,
            left: 10,
            child: Container(
              height: 100,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            left: 110,
            top: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Program Studi',
                                  style: TextStyle(
                                      color: textPrimary,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 12),
                                ),
                                Container(
                                  width: 140,
                                  child: Text(
                                    prov.isProdi,
                                    style: TextStyle(
                                        color: textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Program',
                                  style: TextStyle(
                                      color: textPrimary,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10),
                                ),
                                Text(
                                  prov.isProgram,
                                  style: TextStyle(
                                      color: textPrimary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Status',
                                  style: TextStyle(
                                      color: textPrimary,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10),
                                ),
                                Text(
                                  prov.isStatus,
                                  style: TextStyle(
                                      color: textPrimary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MenuHome extends StatefulWidget {
  MenuHome({Key key}) : super(key: key);

  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Layanan',
            style: TextStyle(
                color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => KrsScreen())),
                      child: CardMenu(
                        icon: LineIcons.bookmark,
                        label: "KRS",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => NilaiScreen())),
                      child: CardMenu(
                        icon: LineIcons.graduation_cap,
                        label: "Nilai",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: CardMenu(
                        icon: LineIcons.money,
                        label: "Keuangan",
                      ),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => KeuanganScreen())),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: CardMenu(
                        icon: LineIcons.newspaper_o,
                        label: "Inbox",
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => NotificationScreen())),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfilePageScreen())),
                      child: CardMenu(
                        icon: LineIcons.user,
                        label: "Profile",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CardMenu(
                      icon: LineIcons.dot_circle_o,
                      label: "More..",
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CardMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  const CardMenu({Key key, @required this.icon, @required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 100,
      decoration: BoxDecoration(
          color: textWhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Color(0x148b8a8a), offset: Offset(0, 3), blurRadius: 6)
          ]),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(icon),
            Text(
              label,
              style:
                  TextStyle(color: textPrimary.withOpacity(0.5), fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
