import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/auth/login_screen.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final LoginProvider prov = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 152,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fill),
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  "STIKES Gunung Sari",
                  style: appTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Sekolah Tinggi Ilmu Kesehatan Gunung Sari \n V.1.0",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: primaryRed,
                onPressed: () async {
                  await prov.doWelcome();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  child: Center(
                    child: Text(
                      "Mulai Gunakan!",
                      style: TextStyle(color: textWhite),
                    ),
                  ),
                )),
          ],
        ),
      )),
    );
  }
}
