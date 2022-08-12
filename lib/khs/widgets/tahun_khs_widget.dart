import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/providers/krs_mhs_provider.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_ajaran_aktif_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_khs_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
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
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: config.colorPrimary),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: DropdownButtonFormField(
                  hint: Text('Pilih Tahun'),
                  items: watchTahunKhs.dataTahunKhs.data!.map((e) {
                    return new DropdownMenuItem(
                        value: e.tahunid,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(LineIcons.calendar),
                            Text('Tahun Ajaran'),
                            SizedBox(
                              width: 100,
                            ),
                            Container(
                              child: Text(
                                e.tahunid!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            )
                          ],
                        ));
                  }).toList(),
                  onChanged: (val) async {
                    print('tahun dikirim: ${val.toString()}');
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
                    }
                    watchTahunKhs.setTahun = val.toString();
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ));
        }
      default:
        return Container();
    }
  }
}
