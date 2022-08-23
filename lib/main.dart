// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/auth/login_screen.dart';
import 'package:sisfo_mobile/auth/splash_screen.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/home/home_screen.dart';
import 'package:sisfo_mobile/keuangan/keuangan_provider.dart';
import 'package:sisfo_mobile/keuangan/providers/keuangan_mhs_detail_provider.dart';
import 'package:sisfo_mobile/keuangan/providers/keuangan_mhs_provider.dart';
import 'package:sisfo_mobile/khs/providers/krs_mhs_provider.dart';
import 'package:sisfo_mobile/khs/providers/krs_paket_provider.dart';
import 'package:sisfo_mobile/khs/providers/krs_paket_terpilih_provider.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_ajaran_aktif_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_khs_provider.dart';
import 'package:sisfo_mobile/krs/krs_provider.dart';
import 'package:sisfo_mobile/nilai/nilai_provider.dart';
import 'package:sisfo_mobile/notification/notification_provider.dart';
import 'package:sisfo_mobile/profile/profile_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/initial_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    return runApp(Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => InitialProvider()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => NilaiProvider()),
          ChangeNotifierProvider(create: (_) => KeuanganProvider()),
          ChangeNotifierProvider(create: (_) => KrsProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),

          //KRS
          ChangeNotifierProvider(create: (_) => TahunAjaranAktifProvider()),
          ChangeNotifierProvider(create: (_) => StatusKhsProvider()),
          ChangeNotifierProvider(create: (_) => TahunKhsProvider()),
          ChangeNotifierProvider(create: (_) => KrsMhsProvider()),
          ChangeNotifierProvider(create: (_) => KrsPaketProvider()),
          ChangeNotifierProvider(create: (_) => KrsPaketTerpilihProvider()),

          //Keuangan
          ChangeNotifierProvider(create: (_) => KeuanganMhsProvider()),
          ChangeNotifierProvider(create: (_) => KeuanganDetailProvider()),
        ],
        child: MyApp(),
      ),
    ));
  });
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<InitialProvider>().initial());
  }

  @override
  Widget build(BuildContext context) {
    final watchInitial = context.watch<InitialProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sisfo Mobile',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: config.colorPrimary),
        scaffoldBackgroundColor: config.colorBackgroundWhite,
      ),
      home: watchInitial.initialPage == 'SPLASH'
          ? SplashScreen()
          : watchInitial.initialPage == 'LOGIN'
              ? LoginScreen()
              : HomeScreen(),
    );
  }
}
