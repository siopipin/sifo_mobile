import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/dashboard_screen.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/keuangan/keuangan_mhs_screen.dart';
import 'package:sisfo_mobile/nilai/nilai_screen.dart';
import 'package:sisfo_mobile/notification/notification_screen.dart';
import 'package:sisfo_mobile/profile/profile_mhs_screen.dart';
import 'package:sisfo_mobile/profile/providers/profile_mhs_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/bottomNavigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Halaman yang ditampilkan pada bottom navigation
  late final List<Widget> _pages = <Widget>[
    const DashboardScreen(),
    const KeuanganMhsScreen(needAppbar: false),
    const NilaiScreen(needAppbar: false),
    const ProfileMhsScreen(needAppbar: false),
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi data profile & home sekali saat halaman dibuat
    Future.microtask(() {
      context.read<ProfileMhsProvider>().initial();
      context.read<HomeProvider>().initial();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hanya listen pada perubahan index untuk meminimalkan rebuild
    final currentIndex =
        context.select<HomeProvider, int>((prov) => prov.index);
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      appBar: AppBar(
        backgroundColor: config.colorPrimary,
        leading: Container(
          margin: const EdgeInsets.all(6),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(config.logoPath),
              fit: BoxFit.fill,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationScreen())),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                const Icon(LineIcons.bell),
                Positioned(
                  top: 15,
                  right: 5,
                  child: Icon(
                    Icons.brightness_1,
                    size: 8.0,
                    color: config.colorSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
        ],
        title: const Text(
          'STIKES Gunung Sari',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _pages[currentIndex],
    );
  }
}
