import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class TextFieldPasswordWidget extends StatelessWidget {
  final TextEditingController ctrl;
  const TextFieldPasswordWidget({Key? key, required this.ctrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchLogin = context.watch<LoginProvider>();

    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 60,
      decoration: BoxDecoration(
          color: config.colorGrey, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            obscureText: watchLogin.isObscureText,
            controller: ctrl,
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
                watchLogin.setIsObscureText = !watchLogin.isObscureText;
              },
            ),
          )
        ],
      ),
    );
  }
}
