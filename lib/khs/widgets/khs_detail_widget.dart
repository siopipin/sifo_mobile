import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/models/krs_mhs_model.dart';
import 'package:sisfo_mobile/khs/providers/krs_mhs_provider.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/not_found_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class KhsDetailWidget extends StatelessWidget {
  const KhsDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchStatusKrs = context.watch<StatusKhsProvider>();
    final watchKrsMhs = context.watch<KrsMhsProvider>();
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
        return MessageWidget(
          info: 'KRS tidak ditemukan, silahkan hubungi Bagian Administrasi',
          needBorderRadius: false,
        );
      case StateStatusKhs.loaded:
        return Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // cekKRSData(),

              SizedBox(
                height: 10,
              ),
              watchKrsMhs.isSenin
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: config.colorSecondary,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Senin",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 11),
                          )))
                  : Container(),
              watchKrsMhs.isSenin
                  ? cekKRSHari(context: context, hari: 1)
                  : Container(),
              Divider(),
              watchKrsMhs.isSelasa
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: config.colorSecondary,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Selasa",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 11),
                          )))
                  : Container(),
              watchKrsMhs.isSelasa
                  ? cekKRSHari(context: context, hari: 2)
                  : Container(),
              Divider(),
              watchKrsMhs.isRabu
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: config.colorSecondary,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Rabu",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 11),
                          )))
                  : Container(),
              watchKrsMhs.isRabu
                  ? cekKRSHari(context: context, hari: 3)
                  : Container(),
              Divider(),
              watchKrsMhs.isKamis
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: config.colorSecondary,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Kamis",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 11),
                          )))
                  : Container(),
              watchKrsMhs.isKamis
                  ? cekKRSHari(context: context, hari: 4)
                  : Container(),
              Divider(),
              watchKrsMhs.isJumat
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: config.colorSecondary,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Jumat",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 11),
                          )))
                  : Container(),
              watchKrsMhs.isJumat
                  ? cekKRSHari(context: context, hari: 5)
                  : Container(),
              Divider(),
              watchKrsMhs.isSabtu
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: config.colorSecondary,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Sabtu",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 11),
                          )))
                  : Container(),
              watchKrsMhs.isSabtu
                  ? cekKRSHari(context: context, hari: 6)
                  : Container(),
            ],
          ),
        );

      default:
        return Container();
    }
  }

  cekKRSHari({required BuildContext context, @required hari}) {
    final watchKrsMhs = context.watch<KrsMhsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: watchKrsMhs.dataKrsMhs.data!.map((e) {
        var index = watchKrsMhs.dataKrsMhs.data!.indexOf(e);
        if (e.hariID == hari) {
          return expandedBuilder(context, e, index);
        } else {
          return Container();
        }
      }).toList(),
    );
  }

  Widget expandedBuilder(BuildContext context, Data e, int i) {
    final watchKrsMhs = context.watch<KrsMhsProvider>();

    return Container(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          print(i);
          if (e.isExpanded == true) {
            watchKrsMhs.setExpanded(i, false);
          } else if (e.isExpanded == false) {
            watchKrsMhs.setExpanded(i, true);
          }
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama Mata Kuliah', style: TextStyle(fontSize: 11)),
                    Text(
                      e.nama!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Dosen : ',
                        style: TextStyle(
                          fontSize: 12,
                        )),
                    Flexible(
                        child: Text(
                      e.dSN!,
                      style: TextStyle(
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ))
                  ],
                ),
              );
            },
            body: DataTable(
              columnSpacing: 16,
              columns: <DataColumn>[
                DataColumn(label: Text("Kode")),
                DataColumn(label: Text("Jam Kuliah")),
                DataColumn(label: Text("Ruang")),
                DataColumn(label: Text("SKS")),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(e.mKKode!)),
                    DataCell(Text('${e.jM!} - ${e.jS!}')),
                    DataCell(Text(e.ruangID!)),
                    DataCell(Text(e.sKS.toString())),
                  ],
                ),
              ],
            ),
            isExpanded: e.isExpanded!,
          )
        ],
      ),
    );
  }
}
