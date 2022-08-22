import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_ajaran_aktif_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class KhsInfoTahunAjaranAktifWidget extends StatelessWidget {
  const KhsInfoTahunAjaranAktifWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchTahunAjaranAktif = context.watch<TahunAjaranAktifProvider>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: config.padding / 2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(
            Icons.date_range_sharp,
            size: 15,
          ),
          Text(' TA Aktif Saat Ini: '),
          Text(
            watchTahunAjaranAktif.dataTahunAjaranAktif.data!.namaTA!,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
        Row(
          children: [
            Icon(
              Icons.key,
              size: 15,
            ),
            Text(' Kode ID: '),
            Text(
              watchTahunAjaranAktif.dataTahunAjaranAktif.data!.kodeID!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        )
      ]),
    );
  }
}