import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/profile/profile_provider.dart';
import 'package:sisfo_mobile/providers/global_config.dart';
import 'package:sisfo_mobile/widgets/bottomNavigation.dart';
import 'package:sisfo_mobile/widgets/loading.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Provider.of<ProfileProvider>(context, listen: false).doGetProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomBar(tabIndex: 3),
        appBar: AppBar(
          backgroundColor: bgColor,
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
              child: Row(
                children: [
                  Text('Edit'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(LineIcons.edit)
                ],
              ),
              onTap: () {
                ///TODO tambah fungsi edit profile
              },
            )
          ],
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [infoBuilder(context)],
            ),
          ),
        )));
  }

  Widget infoBuilder(BuildContext context) {
    final ProfileProvider prov = Provider.of<ProfileProvider>(context);
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          bottom: 260,
          child: Container(
            height: size.height * 0.45,
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    image: AssetImage('assets/images/bg-nurse.jpg'),
                    fit: BoxFit.cover)),
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primaryRed,
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: prov.isData
                                ? Text(
                                    "${prov.dataMahasiswa.data.nama}",
                                  )
                                : loadingH1)),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Title',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(LineIcons.adjust),
                            SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("18k"),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.star),
                            SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("4.8"),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "\$50",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "\$70",
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.lineThrough),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: size.height * 0.40),
          height: size.height * 0.6,
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60), topRight: Radius.circular(60))),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Course Content",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '1',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black.withOpacity(0.3)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Duration",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Source',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.4),
                                shape: BoxShape.circle),
                            child: Center(child: Icon(Icons.play_arrow)),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '1',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black.withOpacity(0.3)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Duration",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Source',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.4),
                                shape: BoxShape.circle),
                            child: Center(child: Icon(Icons.play_arrow)),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
