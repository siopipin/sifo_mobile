import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/khs/khs_screen.dart';
import 'package:sisfo_mobile/khs/providers/krs_paket_provider.dart';
import 'package:sisfo_mobile/khs/providers/krs_paket_terpilih_provider.dart';
import 'package:sisfo_mobile/khs/providers/status_khs_provider.dart';
import 'package:sisfo_mobile/khs/providers/tahun_ajaran_aktif_provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_header_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/button_custom.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/widgets/not_found_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class KHSPengajuanScreen extends StatefulWidget {
  final String tahunid;
  KHSPengajuanScreen({Key? key, required this.tahunid}) : super(key: key);

  @override
  State<KHSPengajuanScreen> createState() => _KHSPengajuanScreenState();
}

class _KHSPengajuanScreenState extends State<KHSPengajuanScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<KrsPaketProvider>().initial(widget.tahunid);
      context.read<KrsPaketTerpilihProvider>().initial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: config.appBar(title: 'Pengajuan KRS'),
      body: Scrollbar(
          child: RefreshIndicator(
        onRefresh: () async {
          context.read<KrsPaketProvider>().initial(widget.tahunid);
          context.read<KrsPaketTerpilihProvider>().initial();
        },
        child: ListView(children: [
          //Header
          KhsHeaderWidget(),

          //pilih paket - dropdown
          _pilihPaket(context),

          //isi paket list
          SizedBox(height: config.padding / 2),
          _isipaketkers(context),
          _buttonSimpanKrs(context)
        ]),
      )),
    );
  }

  _pilihPaket(BuildContext context) {
    final watchPaketKhs = context.watch<KrsPaketProvider>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.padding),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //Cek jika selesai loading
        if (watchPaketKhs.stateKrsPaket == StateKrsPaket.loading)
          Column(
            children: [
              loading.shimmerCustom(height: 50),
            ],
          )
        else if (watchPaketKhs.stateKrsPaket == StateKrsPaket.error)
          NotFoundWidget()
        else if (watchPaketKhs.stateKrsPaket == StateKrsPaket.nulldata)
          MessageWidget(
            info: 'Paket KRS tidak ditemukan',
            status: InfoWidgetStatus.warning,
            needBorderRadius: false,
          )
        else if (watchPaketKhs.stateKrsPaket == StateKrsPaket.loaded)
          if (watchPaketKhs.dataKrsPaket.data!.isEmpty)
            MessageWidget(
              info: 'Tahun ajaran aktif tidak ditemukan',
              status: InfoWidgetStatus.warning,
              needBorderRadius: false,
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: DropdownButtonFormField(
                    items: watchPaketKhs.dataKrsPaket.data!.map((e) {
                      return new DropdownMenuItem(
                          value: e.mkpaketid,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(LineIcons.dotCircle),
                              SizedBox(width: 3),
                              Text(e.namapaket!),
                            ],
                          ));
                    }).toList(),
                    onChanged: (val) async {
                      context
                          .read<KrsPaketTerpilihProvider>()
                          .fetchKrsPaketTerpilih(
                              tahunid: widget.tahunid, paketid: val);
                    },
                    hint: Row(
                      children: [
                        Icon(LineIcons.checkCircle),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Pilih Paket")
                      ],
                    ),
                  ),
                ),
              ],
            )
        else
          Container()
      ]),
    );
  }

  _isipaketkers(BuildContext context) {
    Widget _widget;
    final watchPaketList = context.watch<KrsPaketTerpilihProvider>();
    if (watchPaketList.stateKrsPaketTerpilih == StateKrsPaketTerpilih.loading)
      _widget = Padding(
        padding: EdgeInsets.symmetric(horizontal: config.padding),
        child: Column(
          children: [
            loading.shimmerCustom(height: 50),
            Padding(
              padding: EdgeInsets.only(top: config.padding / 2),
              child: loading.shimmerCustom(height: 50),
            )
          ],
        ),
      );
    else if (watchPaketList.stateKrsPaketTerpilih ==
        StateKrsPaketTerpilih
            .loaded) if (watchPaketList.dataKrsPaketTerpilih.data!.isEmpty)
      _widget = MessageWidget(
        info: 'Mata Kuliah Paket KRS tidak ditemukan',
        status: InfoWidgetStatus.warning,
        needBorderRadius: false,
      );
    else
      _widget = Padding(
        padding: EdgeInsets.symmetric(horizontal: config.padding),
        child: Column(
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
                rows: watchPaketList.dataKrsPaketTerpilih.data!.map((e) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(e.mKKode!,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold))),
                      DataCell(Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.namaMK!,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          Text(e.dSN!, style: TextStyle(fontSize: 10))
                        ],
                      )),
                      DataCell(Text(e.jadwalID.toString(),
                          style: TextStyle(fontSize: 10))),
                      DataCell(Text(e.hR!, style: TextStyle(fontSize: 10))),
                      DataCell(Text('${e.jM} - ${e.jS}',
                          style: TextStyle(fontSize: 10))),
                    ],
                  );
                }).toList(),
              ),
            )))
          ],
        ),
      );
    else
      _widget = Container();

    return _widget;
  }

  _buttonSimpanKrs(BuildContext context) {
    Widget _widget;
    final watchPaketList = context.watch<KrsPaketTerpilihProvider>();
    final watchTAAktif = context.watch<TahunAjaranAktifProvider>();
    final watchKHS = context.watch<StatusKhsProvider>();

    if (watchPaketList.stateKrsPaketTerpilih == StateKrsPaketTerpilih.loaded)
      _widget = Padding(
        padding: EdgeInsets.symmetric(horizontal: config.padding),
        child: ButtonCustom(
            function: () {
              //tampilkan dialog untuk konfirmasi simpan krs.
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Simpan KRS'),
                      content: Text(
                          'Cek sekali lagi paket KRS yang dipilih, jika sudah sesuai maka klik "Simpan"'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Batal')),
                        ElevatedButton(
                            onPressed: watchPaketList.stateSimpanKrs ==
                                    StateSimpanKrs.loading
                                ? null
                                : () async {
                                    if (watchKHS.dataStatusKrs.data == null) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'KHS ID tidak ditemukan, silahkan restart aplikasi atau hubungi bagian Administrasi',
                                          toastLength: Toast.LENGTH_LONG);
                                    } else {
                                      await context
                                          .read<KrsPaketTerpilihProvider>()
                                          .postSimpan(
                                              kodeid: watchTAAktif
                                                  .dataTahunAjaranAktif
                                                  .data!
                                                  .kodeID,
                                              khsid: watchKHS
                                                  .dataStatusKrs.data!.kHSID,
                                              tahunid: widget.tahunid,
                                              dataKRS: watchPaketList
                                                  .dataKrsPaketTerpilih.data!);

                                      if (watchPaketList.stateSimpanKrs ==
                                          StateSimpanKrs.loaded) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    KhsScreen())),
                                            (route) => false);
                                      }
                                    }
                                  },
                            child: Text('Simpan')),
                      ],
                    );
                  });
            },
            text: "Simpan KRS"),
      );
    else
      _widget = Container();

    return _widget;
  }
}
