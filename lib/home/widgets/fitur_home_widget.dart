import 'package:flutter/material.dart';
import 'package:sisfo_mobile/about/about_screen.dart';
import 'package:sisfo_mobile/home/widgets/card_fitur_home_widget.dart';
import 'package:sisfo_mobile/keuangan/keuangan_mhs_screen.dart';
import 'package:sisfo_mobile/khs/khs_screen.dart';
import 'package:sisfo_mobile/nilai/nilai_screen.dart';
import 'package:sisfo_mobile/notification/notification_screen.dart';
import 'package:sisfo_mobile/profile/profile_mhs_screen.dart';
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
                        iconPath: 'assets/images/krs.png',
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
                        iconPath: 'assets/images/nilai.png',
                        label: "Nilai",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: CardMenu(
                        iconPath: 'assets/images/keuangan.png',
                        label: "Keuangan",
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => KeuanganMhsScreen())),
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
                        iconPath: 'assets/images/pesan.png',
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
                              builder: (_) => ProfileMhsScreen())),
                      child: CardMenu(
                        iconPath: 'assets/images/profil.png',
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
                        iconPath: 'assets/images/about.png',
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
