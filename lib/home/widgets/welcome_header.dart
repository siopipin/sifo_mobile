import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<HomeProvider>();

    return Row(
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
                  style: TextStyle(color: config.colorPrimary.withOpacity(0.7)),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "${prov.isName}",
                  style: TextStyle(
                      color: config.fontPrimary,
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
            await store.removeLoginData().then((value) {
              if (value) {
                Fluttertoast.showToast(msg: 'Logout berhasil, silahkan login!');
                Phoenix.rebirth(context);
              }
            });
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
                    fontSize: 8, color: config.fontPrimary.withOpacity(0.8)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
