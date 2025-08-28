import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/providers/krs_mhs_provider.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_khs_provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_info_tahun_ajaran_aktif_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class TahunKhsWidget extends StatelessWidget {
  const TahunKhsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchTahunKhs = context.watch<TahunKhsProvider>();
    final watchStatusKhs = context.read<StatusKhsProvider>();

    switch (watchTahunKhs.stateTahunKhs) {
      case StateTahunKhs.error:
        return Container();
      case StateTahunKhs.loading:
        return loading.shimmerCustom(height: 50);
      case StateTahunKhs.loaded:
        if (watchTahunKhs.dataTahunKhs.data!.length == 0) {
          return Container();
        } else {
          return Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tahun Ajaran',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 2.0),
                ),
                KhsInfoTahunAjaranAktifWidget(),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: DropdownButtonFormField(
                  hint: Text('KRS TA Lainnya'),
                  items: watchTahunKhs.dataTahunKhs.data!.map((e) {
                    return new DropdownMenuItem(
                      value: e.tahunid,
                      child: Text(
                        e.tahunid!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) async {
                    await context
                        .read<StatusKhsProvider>()
                        .initial(tahunid: val.toString());
                    if (watchStatusKhs.stateStatusKhs ==
                        StateStatusKhs.loaded) {
                      if (watchStatusKhs.dataStatusKrs.status == true) {
                        //Ambil krs mahasiswa.
                        await context.read<KrsMhsProvider>().initial(
                            khsid: watchStatusKhs.dataStatusKrs.data!.kHSID
                                .toString());
                      }
                    } else {
                      watchStatusKhs.setStateStatusKhs =
                          StateStatusKhs.nulldata;
                    }
                    watchTahunKhs.setTahun = val.toString();
                  },
                ),
              ),
            )
          ]);
        }
      default:
        return Container();
    }
  }
}
