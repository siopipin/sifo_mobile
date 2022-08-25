import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/keuangan/providers/keuangan_mhs_detail_provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_header_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class KeuanganDetailWidget extends StatelessWidget {
  const KeuanganDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchKeuanganDetail = context.watch<KeuanganDetailProvider>();

    return Scrollbar(
        child: RefreshIndicator(
      onRefresh: () async {},
      child: ListView(children: [
        //header
        KhsHeaderWidget(),

        //list keuangan.
        if (watchKeuanganDetail.stateKeuanganDetail ==
            StateKeuanganDetail.error)
          MessageWidget(
            info: 'Gagal memuat detail keuangan, pull down untuk load halaman',
            status: InfoWidgetStatus.warning,
            needBorderRadius: false,
          )
        else if (watchKeuanganDetail.stateKeuanganDetail ==
            StateKeuanganDetail.loading)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: config.padding),
            child: Column(
              children: [
                loading.shimmerCustom(height: 50),
                SizedBox(height: config.padding / 2),
                loading.shimmerCustom(height: 50),
              ],
            ),
          )
        else if (watchKeuanganDetail.stateKeuanganDetail ==
            StateKeuanganDetail.loaded)
          if (watchKeuanganDetail.dataKeuanganDetail.data!.isEmpty)
            MessageWidget(
              info: 'Informasi detail keuangan tidak ditemukan',
              status: InfoWidgetStatus.warning,
              needBorderRadius: false,
            )
          else
            ListView.builder(
                shrinkWrap: true,
                itemCount: watchKeuanganDetail.dataKeuanganDetail.data!.length,
                itemBuilder: ((context, index) {
                  var item =
                      watchKeuanganDetail.dataKeuanganDetail.data![index];
                  return ExpansionTile(
                    expandedAlignment: Alignment.centerLeft,
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: config.padding),
                    title: Text(
                      item.namaPembayaran ?? '-',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                    subtitle: Text(item.tanggal ?? '-'),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 160,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: config.padding),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Jumlah'),
                                        Text('Rp. ${item.jumlah ?? '-'}')
                                      ],
                                    )),
                              ],
                            ),
                          ),
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
