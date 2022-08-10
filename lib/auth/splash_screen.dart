import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/auth/login_screen.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/button_custom.dart';
import 'package:sisfo_mobile/widgets/logo.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final LoginProvider prov = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: config.colorPrimary,
      body: Center(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(),
            Column(
              children: <Widget>[
                Text(
                  config.textTitle,
                  style: config.appTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  config.textDescription,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      )),
      bottomSheet: ButtonCustom(
        text: "Mulai Gunakan!",
        height: 55,
        function: () async {
          await prov.doWelcome();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        },
        useBorderRadius: false,
      ),
    );
  }
}
