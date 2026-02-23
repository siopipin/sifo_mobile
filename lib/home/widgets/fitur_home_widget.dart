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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layanan Akademik',
          style: TextStyle(
            color: config.fontPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CardMenu(
                iconPath: 'assets/images/krs.png',
                label: 'KRS',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => KhsScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CardMenu(
                iconPath: 'assets/images/nilai.png',
                label: 'Nilai',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NilaiScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CardMenu(
                iconPath: 'assets/images/billing.png',
                label: 'Keuangan',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KeuanganMhsScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CardMenu(
                iconPath: 'assets/images/pesan.png',
                label: 'Inbox',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CardMenu(
                iconPath: 'assets/images/profil.png',
                label: 'Profile',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileMhsScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CardMenu(
                iconPath: 'assets/images/about.png',
                label: 'About',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
