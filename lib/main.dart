import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/auth/login_screen.dart';
import 'package:sisfo_mobile/auth/splash_screen.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/home/home_screen.dart';
import 'package:sisfo_mobile/profile/profile_provider.dart';
import 'package:sisfo_mobile/providers/initial_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    return runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InitialProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Provider.of<InitialProvider>(context, listen: false).cekInitialPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final InitialProvider prov = Provider.of<InitialProvider>(context);
    final init = prov.getInitialPage;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sisfo Mobile',
      theme: ThemeData(fontFamily: 'Roboto', primarySwatch: Colors.blue),
      home: init == 'SPLASH'
          ? SplashScreen()
          : init == 'LOGIN'
              ? LoginScreen()
              : HomeScreen(),
    );
  }
}
