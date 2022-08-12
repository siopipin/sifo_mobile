import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/khs/providers/krs_mhs_provider.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_ajaran_aktif_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_khs_provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_detail_widget.dart';
import 'package:sisfo_mobile/khs/widgets/khs_header_widget.dart';
import 'package:sisfo_mobile/khs/widgets/tahun_khs_widget.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class KhsScreen extends StatefulWidget {
  KhsScreen({Key? key}) : super(key: key);

  @override
  State<KhsScreen> createState() => _KhsScreenState();
}

class _KhsScreenState extends State<KhsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      context.read<HomeProvider>().initial();
      context.read<TahunKhsProvider>().initial();

      await context.read<TahunAjaranAktifProvider>().initial();
      final watchTahunAjaranAktif = context.read<TahunAjaranAktifProvider>();
      final watchStatusKhs = context.read<StatusKhsProvider>();

      if (watchTahunAjaranAktif.stateTahunAjaranAktif ==
          StateTahunAjaranAktif.loaded) {
        if (watchTahunAjaranAktif.dataTahunAjaranAktif.status == true) {
          //Ambil Status Khs
          await context.read<StatusKhsProvider>().initial(
              tahunid:
                  watchTahunAjaranAktif.dataTahunAjaranAktif.data!.tahunTA!);

          //Cek Status Krs

          if (watchStatusKhs.stateStatusKhs == StateStatusKhs.loaded) {
            if (watchStatusKhs.dataStatusKrs.status == true) {
              //Ambil krs mahasiswa.
              await context.read<KrsMhsProvider>().initial(
                  khsid: watchStatusKhs.dataStatusKrs.data!.kHSID.toString());
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final watchTahunAjaranAktif = context.watch<TahunAjaranAktifProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.colorPrimary,
        title: Text('Informasi KRS'),
        actions: [
          //TODO tambahkan cekTOShowDownloadKRS()
        ],
      ),
      body: Scrollbar(
          child: RefreshIndicator(
              onRefresh: () async {},
              child: ListView(
                children: [
                  //header
                  KhsHeaderWidget(),

                  //body
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: config.padding),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Pilih tahun.
                          TahunKhsWidget(),
                          SizedBox(height: config.padding / 2),
                          //cek jika krs aktif
                          if (watchTahunAjaranAktif.stateTahunAjaranAktif ==
                              StateTahunAjaranAktif.loading)
                            Column(
                              children: [
                                loading.shimmerCustom(height: 50),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: config.padding / 2),
                                  child: loading.shimmerCustom(height: 50),
                                )
                              ],
                            )
                          else if (watchTahunAjaranAktif
                                  .stateTahunAjaranAktif ==
                              StateTahunAjaranAktif.nulldata)
                            MessageWidget(
                              info: 'Tahun ajaran aktif tidak ditemukan',
                              status: InfoWidgetStatus.warning,
                              needBorderRadius: false,
                            )
                          else if (watchTahunAjaranAktif
                                  .stateTahunAjaranAktif ==
                              StateTahunAjaranAktif.loaded)
                            KhsDetailWidget()
                          else
                            Container(),
                        ]),
                  )
                ],
              ))),
    );
  }
}
