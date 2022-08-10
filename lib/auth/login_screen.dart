import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/home/home_screen.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _nimText = TextEditingController();
  TextEditingController _passText = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LoginProvider prov = Provider.of<LoginProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                width: 152,
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(config.logoPath), fit: BoxFit.fill)),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Text(
                    "NPM",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 60,
                decoration: BoxDecoration(
                    color: config.colorGrey,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(top: 5),
                child: TextField(
                  controller: _nimText,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nomor Pokok Mahasiswa',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                      ),
                      prefixIcon: Icon(
                        LineIcons.user,
                        color: Colors.black.withOpacity(0.8),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 60,
                decoration: BoxDecoration(
                    color: config.colorGrey,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                      obscureText: prov.isObscureText,
                      controller: _passText,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Kata Sandi',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          prefixIcon: Icon(
                            LineIcons.key,
                            color: Colors.black.withOpacity(0.8),
                          )),
                    )),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        child: Icon(LineIcons.eye),
                        onTap: () {
                          if (prov.isObscureText == true) {
                            print('click me');
                            prov.setShowPassword = false;
                          } else {
                            print('click me');
                            prov.setShowPassword = true;
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Lupa Password? Hubungi Admin.',
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: ElevatedButton(
            onPressed: () async {
              if (_nimText.text.isEmpty || _passText.text.isEmpty) {
                Toast.show('NIM dan Password tidak boleh kosong',
                    duration: 2, gravity: Toast.top);
              } else {
                await prov.doLogin(
                    login: _nimText.text, password: _passText.text);
                if (prov.islogin == true) {
                  Toast.show(prov.isMsg, gravity: Toast.top, duration: 2);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                } else if (prov.islogin == false) {
                  Toast.show(prov.isMsg, gravity: Toast.top, duration: 2);
                } else if (prov.isError == true) {
                  Toast.show(prov.isMsg, gravity: Toast.top, duration: 2);
                }
              }
            },
            style: ElevatedButton.styleFrom(primary: config.colorPrimary),
            child: prov.isLoading
                ? Text(
                    'Memuat ...',
                    style: TextStyle(color: config.fontPrimary),
                  )
                : Text(
                    'Login',
                    style: TextStyle(
                        color: config.fontWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )),
      ),
    );
  }
}
