import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen({Key key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarColor,
          title: Text('About'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 152,
                    height: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: const AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fill)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "My STIKES GS",
                  style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  "This is a mobile application for Academic Information System of STIKES Gunung Sari, Makassar\n\nWith My STIKES GS you can access many features anytime and anywhere.",
                  textAlign: TextAlign.center,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("Key features:")],
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                      Text("  Online KRS")
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                      Text("  Payment")
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                      Text("  Grading")
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                      Text("  News & Announcement Notification")
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                      Text("  and other..")
                    ],
                  ),
                ),
                Divider(),
                Text(
                  "We will commit to improve this application to serve you better",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Contact us",
                      style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    )
                  ],
                ),
                Text(
                  "Visit us on www.stikes.gunungsari.id \nLike us on facebook https://m.facebook.com/stikesgunungsari/ \nFollow us on instagram \nhttps://www.instagram.com/stikesgs",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ));
  }
}
