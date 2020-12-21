import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/krs/krs_provider.dart';
import 'package:sisfo_mobile/widgets/loading.dart';

class KRSTerpilihWidget extends StatelessWidget {
  const KRSTerpilihWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (prov.isLoadingKRSPaketTerpilih) {
      return loadingTable;
    } else if (prov.isErrorKRSPaketTerpilih) {
      return Container();
    } else if (!prov.isAdaDataKRSPaketTerpilih) {
      return Center(
        child: Column(
          children: [
            Icon(
              LineIcons.warning,
              size: 30,
            ),
            Text('Tidak ditemukan!',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                )),
          ],
        ),
      );
    } else if (prov.isAdaDataKRSPaketTerpilih) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Scrollbar(
                  child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              columns: <DataColumn>[
                DataColumn(label: Text("Kode")),
                DataColumn(label: Text("Mata Kuliah")),
                DataColumn(label: Text("Jadwal")),
                DataColumn(label: Text("Hari")),
                DataColumn(label: Text("Jam Kuliah")),
              ],
              rows: prov.dataKRSPaketTerpilih.data.map((e) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(e.mKKode ?? '-',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold))),
                    DataCell(Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.namaMK ?? '-',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Text(e.dSN ?? '-', style: TextStyle(fontSize: 10))
                      ],
                    )),
                    DataCell(Text(e.jadwalID.toString() ?? '-',
                        style: TextStyle(fontSize: 10))),
                    DataCell(Text(e.hR ?? '-', style: TextStyle(fontSize: 10))),
                    DataCell(Text('${e.jM ?? '-'} - ${e.jS ?? '-'}',
                        style: TextStyle(fontSize: 10))),
                  ],
                );
              }).toList(),
            ),
          )))
        ],
      );
    } else {
      return Container();
    }
  }
}
