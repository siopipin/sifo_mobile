import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/khs_pengajuan_screen.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_ajaran_aktif_provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_jadwal_widget.dart';
import 'package:sisfo_mobile/widgets/button_custom.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/not_found_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class KhsDetailWidget extends StatelessWidget {
  const KhsDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchStatusKrs = context.watch<StatusKhsProvider>();
    final watchTahunAjaranAktif = context.watch<TahunAjaranAktifProvider>();

    switch (watchStatusKrs.stateStatusKhs) {
      case StateStatusKhs.error:
        return NotFoundWidget();
      case StateStatusKhs.loading:
        return Column(
          children: [
            loading.shimmerCustom(height: 50),
            Padding(
              padding: EdgeInsets.only(top: config.padding / 2),
              child: loading.shimmerCustom(height: 50),
            )
          ],
        );
      case StateStatusKhs.nulldata:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MessageWidget(
              status: InfoWidgetStatus.warning,
              info: 'KRS tidak ditemukan, silahkan hubungi Bagian Administrasi',
              needBorderRadius: true,
            ),
            SizedBox(height: config.padding),
            if (watchTahunAjaranAktif.statusPengurusanKRS == true)
              ButtonCustom(
                function: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => KHSPengajuanScreen(
                              tahunid: watchTahunAjaranAktif
                                  .dataTahunAjaranAktif.data!.tahunTA!,
                            )))),
                text: "Lakukan Pengurusan KRS Sekarang!",
                color: config.colorPrimary,
                isPrimary: true,
              )
          ],
        );
      case StateStatusKhs.loaded:
        return KHSJadwalWidget();
      default:
        return Container();
    }
  }
}
