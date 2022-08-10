import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/auth/widgets/textfield_npm_widget.dart';
import 'package:sisfo_mobile/auth/widgets/textfield_password_widget.dart';
import 'package:sisfo_mobile/home/home_screen.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/button_custom.dart';
import 'package:sisfo_mobile/widgets/logo.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final watchLogin = context.watch<LoginProvider>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: LogoWidget(),
                ),
                SizedBox(height: 50),
                Text("NPM", style: TextStyle(fontWeight: FontWeight.bold)),
                TextFieldNPMWidget(ctrl: watchLogin.ctrlNPM),
                SizedBox(height: 20),
                Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
                TextFieldPasswordWidget(ctrl: watchLogin.ctrlPassword),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Lupa Password? Hubungi Admin.',
                      style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                    )),
                SizedBox(
                  height: 50,
                ),
                ButtonCustom(
                  function: () async {
                    if (watchLogin.ctrlNPM.text.isEmpty ||
                        watchLogin.ctrlPassword.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'NPM dan Password tidak boleh kosong!');
                    } else {
                      await watchLogin.doLogin(
                          login: watchLogin.ctrlNPM.text,
                          password: watchLogin.ctrlPassword.text);

                      if (watchLogin.stateLogin == StateLogin.loaded) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      }
                    }
                  },
                  text: watchLogin.stateLogin == StateLogin.loading
                      ? 'Memuat ...'
                      : 'Login',
                  color: config.colorPrimary,
                  useBorderRadius: false,
                  isPrimary: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
