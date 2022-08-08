import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/about/about_screen.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/keuangan/keuangan_screen.dart';
import 'package:sisfo_mobile/krs/krs_screen.dart';
import 'package:sisfo_mobile/notification/notification_screen.dart';

import 'package:sisfo_mobile/nilai/nilai_screen.dart';
import 'package:sisfo_mobile/profile/profile_page_screen.dart';
import 'package:sisfo_mobile/services/firebase_notification_handler.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';
import 'package:sisfo_mobile/widgets/bottomNavigation.dart';
import 'package:sisfo_mobile/widgets/loading.dart';
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
    Provider.of<HomeProvider>(context, listen: false).getDataAwal();

    new FirebaseNotifications().setUpFirebase(context);
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
                      Toast.show(provLogin.msg,
                          gravity: Toast.top, duration: 3);
                      Phoenix.rebirth(context);
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    child: Column(
                      children: [
                        Icon(
                          LineIcons.sign,
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
      height: 120,
      decoration: BoxDecoration(
        color: primaryYellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 8,
            left: 10,
            child: Container(
              height: 100,
              child: FutureBuilder(
                future: store.foto(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null || snapshot.data.isNotEmpty) {
                      return CachedNetworkImage(
                        imageUrl: '$imgurl/${snapshot.data}',
                        imageBuilder: (context, imageProvider) => Container(
                          width: 82.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => loadingFoto,
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                      );
                    }
                  } else {
                    return loadingFoto;
                  }
                },
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
                        icon: LineIcons.graduationCap,
                        label: "Nilai",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: CardMenu(
                        icon: LineIcons.moneyBill,
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
                        icon: LineIcons.newspaper,
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
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AboutScreen())),
                      child: CardMenu(
                        icon: LineIcons.dotCircle,
                        label: "About",
                      ),
                    )
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
