import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sisfo_mobile/keuangan/providers/keuangan_mhs_detail_provider.dart';
import 'package:sisfo_mobile/keuangan/providers/keuangan_mhs_provider.dart';
import 'package:sisfo_mobile/keuangan/widgets/keuangan_mhs_detail_widget.dart';
import 'package:sisfo_mobile/keuangan/widgets/keuangan_mhs_widget.dart';
import 'package:sisfo_mobile/khs/widgets/khs_header_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class KeuanganMhsScreen extends StatefulWidget {
  final bool needAppbar;
  KeuanganMhsScreen({Key? key, this.needAppbar = true}) : super(key: key);

  @override
  State<KeuanganMhsScreen> createState() => _KeuanganMhsScreenState();
}

class _KeuanganMhsScreenState extends State<KeuanganMhsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<KeuanganMhsProvider>().initial();
      context.read<KeuanganDetailProvider>().initial();
    });
  }

  TabBar get _tabbar => TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.monetization_on),
            text: 'Keuangan KHS',
          ),
          Tab(icon: Icon(Icons.library_books), text: 'Keuangan Detail'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: widget.needAppbar == true
              ? config.appBar(title: 'Informasi keuangan')
              : PreferredSize(
                  preferredSize: _tabbar.preferredSize,
                  child: ColoredBox(color: config.colorPrimary, child: _tabbar),
                ),
          body: TabBarView(children: [
            //Keuangan mhs
            KeuanganMhsWidget(),

            //Keuangan detail
            KeuanganDetailWidget()
          ]),
        ));
  }
}
