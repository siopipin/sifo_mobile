import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sisfo_mobile/about/about_screen.dart';
import 'package:sisfo_mobile/home/widgets/card_fitur_home_widget.dart';
import 'package:sisfo_mobile/keuangan/keuangan_screen.dart';
import 'package:sisfo_mobile/khs/khs_screen.dart';
import 'package:sisfo_mobile/nilai/nilai_screen.dart';
import 'package:sisfo_mobile/notification/notification_screen.dart';
import 'package:sisfo_mobile/profile/profile_page_screen.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class FiturHomeWidget extends StatelessWidget {
  const FiturHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Layanan',
            style: TextStyle(
              color: config.fontPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
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
                          MaterialPageRoute(builder: (_) => KhsScreen())),
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
