import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/home/widgets/fitur_home_widget.dart';
import 'package:sisfo_mobile/home/widgets/info_banner_widget.dart';
import 'package:sisfo_mobile/home/widgets/welcome_header.dart';
import 'package:sisfo_mobile/profile/providers/profile_mhs_provider.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeProvider>().getDataAwal());
    Future.microtask(() => context.read<ProfileMhsProvider>().initial());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 30),
            //Welcome Text
            WelcomeHeader(),
            SizedBox(height: 30),
            //InfoBanner
            InfoBannerWidget(),
            SizedBox(height: 30),
            //Menu
            FiturHomeWidget()
          ],
        ),
      ),
    ));
  }
}
