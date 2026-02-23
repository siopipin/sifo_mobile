import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/khs_pengajuan_screen.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_ajaran_aktif_provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_jadwal_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/button_custom.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/widgets/not_found_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class KhsDetailWidget extends StatelessWidget {
  const KhsDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusKhsProvider>(
      builder: (_, prov, __) {
        switch (prov.stateStatusKhs) {
          case StateStatusKhs.error:
            return const NotFoundWidget();
          case StateStatusKhs.loading:
            return _buildLoading();
          case StateStatusKhs.nulldata:
            return _buildNulldata(context);
          case StateStatusKhs.loaded:
            return const KHSJadwalWidget();
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        loading.shimmerCustom(height: 80),
        const SizedBox(height: 8),
        loading.shimmerCustom(height: 120),
        loading.shimmerCustom(height: 80),
      ],
    );
  }

  Widget _buildNulldata(BuildContext context) {
    return Consumer<TahunAjaranAktifProvider>(
      builder: (_, tahunProv, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageWidget(
              status: InfoWidgetStatus.warning,
              info: 'KRS tidak ditemukan, silakan hubungi Bagian Administrasi',
              needBorderRadius: true,
            ),
            if (tahunProv.statusPengurusanKRS) ...[
              const SizedBox(height: 16),
              ButtonCustom(
                function: () {
                  final tahunTA =
                      tahunProv.dataTahunAjaranAktif.data?.tahunTA;
                  if (tahunTA != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KHSPengajuanScreen(tahunid: tahunTA),
                      ),
                    );
                  }
                },
                text: 'Lakukan Pengurusan KRS Sekarang!',
                color: config.colorPrimary,
                isPrimary: true,
              ),
            ],
          ],
        );
      },
    );
  }
}
