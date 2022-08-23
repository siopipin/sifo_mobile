import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/keuangan/providers/keuangan_mhs_provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_header_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class KeuanganMhsWidget extends StatelessWidget {
  const KeuanganMhsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchKeuanganMhs = context.watch<KeuanganMhsProvider>();

    return Scrollbar(
        child: RefreshIndicator(
      onRefresh: () async {},
      child: ListView(children: [
        //header
        KhsHeaderWidget(),

        //list keuangan.
        if (watchKeuanganMhs.stateKeuanganMhs == StateKeuanganMhs.error)
          MessageWidget(
            info: 'Gagal memuat keuangan mahasiswa, tarik untuk load halaman',
            status: InfoWidgetStatus.warning,
            needBorderRadius: false,
          )
        else if (watchKeuanganMhs.stateKeuanganMhs == StateKeuanganMhs.loading)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: config.padding),
            child: Column(
              children: [
                loading.shimmerCustom(height: 50),
                loading.shimmerCustom(height: 50),
              ],
            ),
          )
        else if (watchKeuanganMhs.stateKeuanganMhs == StateKeuanganMhs.loaded)
          if (watchKeuanganMhs.dataKeuanganMhs.data!.isEmpty)
            MessageWidget(
              info: 'Informasi keuangan tidak ditemukan',
              status: InfoWidgetStatus.warning,
              needBorderRadius: false,
            )
          else
            ListView.builder(
                shrinkWrap: true,
                itemCount: watchKeuanganMhs.dataKeuanganMhs.data!.length,
                itemBuilder: ((context, index) {
                  var item = watchKeuanganMhs.dataKeuanganMhs.data![index];
                  return ExpansionTile(
                    expandedAlignment: Alignment.centerLeft,
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: config.padding),
                    title: Text(
                      item.namaTagihan ?? '-',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                    subtitle: Text(item.tahunid ?? '-'),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Jumlah'),
                                        Text(item.jumlah.toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Terbayar'),
                                        Text(item.terbayar.toString())
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Tunggakan',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(item.tunggakan.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              //copy VA
                              GestureDetector(
                                  child: Expanded(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text('Virtual Account (copy)'),
                                          Text(
                                            item.kodeVA ?? '-',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2.0,
                                              fontSize: config.fontSizeH2,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: config.padding / 2),
                                      Icon(Icons.copy)
                                    ],
                                  )),
                                  onTap: (() {
                                    Clipboard.setData(
                                      ClipboardData(text: item.kodeVA ?? '-'),
                                    ).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text("VA copied to clipboard"),
                                        ),
                                      );
                                    });
                                  }))
                            ],
                          )
                        ],
                      )
                    ],
                  );
                }))
        else
          Container()
      ]),
    ));
  }
}
