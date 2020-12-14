import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/keuangan/keuangan_provider.dart';
import 'package:sisfo_mobile/providers/global_config.dart';
import 'package:sisfo_mobile/providers/storage.dart';
import 'package:sisfo_mobile/widgets/error_widget.dart';
import 'package:sisfo_mobile/widgets/loading.dart';
import 'package:toast/toast.dart';

class KeuanganScreen extends StatefulWidget {
  KeuanganScreen({Key key}) : super(key: key);

  @override
  _KeuanganScreenState createState() => _KeuanganScreenState();
}

class _KeuanganScreenState extends State<KeuanganScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Provider.of<KeuanganProvider>(context, listen: false).doGetTahunKHS();
    });
  }

  @override
  Widget build(BuildContext context) {
    final KeuanganProvider prov = Provider.of<KeuanganProvider>(context);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: bottomTahun(),
          appBar: AppBar(
            backgroundColor: bgColor,
            title: Text('Keuangan'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.monetization_on),
                  text: 'Keuangan KHS',
                ),
                Tab(icon: Icon(Icons.library_books), text: 'Keuangan Detail'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                      child: Row(
                        children: [
                          Icon(
                            LineIcons.user,
                            color: Colors.black.withOpacity(0.4),
                            size: 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Keuangan Tahun KHS : ${prov.isTahun}'),
                              FutureBuilder(
                                future: store.nama(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: textPrimary),
                                    );
                                  } else {
                                    return loadingH2;
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    checkKeuanganKHS()
                  ],
                ),
              )),
              SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                      child: Row(
                        children: [
                          Icon(
                            LineIcons.user,
                            color: Colors.black.withOpacity(0.4),
                            size: 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Keuangan Detail Tahun KHS : ${prov.isTahun}'),
                              FutureBuilder(
                                future: store.nama(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: textPrimary),
                                    );
                                  } else {
                                    return loadingH2;
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    checkKeuanganDetail()
                  ],
                ),
              ))
            ],
          ),
        ));
  }

  Widget checkKeuanganKHS() {
    final KeuanganProvider prov = Provider.of<KeuanganProvider>(context);

    if (prov.isLoadingKeuangan) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: List.generate(3, (index) => loadingList),
        ),
      );
    } else if (prov.isDataKeuangan) {
      return keuanganKHSBuilder();
    } else if (prov.isErrorKeuangan) {
      return Container(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            SomeError(),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2 + 30,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () async {
                  await prov.doGetTahunKHS();
                },
                child: Text(
                  'Reaload !',
                  style: TextStyle(color: Colors.white),
                ),
                color: bgColor,
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget keuanganKHSBuilder() {
    final KeuanganProvider prov = Provider.of<KeuanganProvider>(context);

    return Container(
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(label: Text("No.")),
          DataColumn(label: Text("Nama")),
          DataColumn(label: Text("Keterangan")),
        ],
        rows: <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text("1")),
              DataCell(Text("Sesi")),
              DataCell(
                  Text(prov.dataKeuanganKHSModel.data?.sesi.toString() ?? '-')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text("2")),
              DataCell(Text("SKS")),
              DataCell(
                  Text(prov.dataKeuanganKHSModel.data?.sks.toString() ?? '-')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text("3")),
              DataCell(Text("IPS")),
              DataCell(
                  Text(prov.dataKeuanganKHSModel.data?.ips.toString() ?? '-')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text("4")),
              DataCell(Text("Biaya")),
              DataCell(Text(
                  'Rp. ${prov.dataKeuanganKHSModel.data?.biaya.toString() ?? '-'}')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text("5")),
              DataCell(Text("Potongan")),
              DataCell(Text(
                  'Rp. ${prov.dataKeuanganKHSModel.data?.potongan.toString() ?? '-'}')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text("6")),
              DataCell(Text("Bayar")),
              DataCell(Text(
                  'Rp. ${prov.dataKeuanganKHSModel.data?.bayar.toString() ?? '-'}')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text("7")),
              DataCell(Text("Tarik")),
              DataCell(Text(
                  'Rp. ${prov.dataKeuanganKHSModel.data?.tarik.toString() ?? '-'}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget checkKeuanganDetail() {
    final KeuanganProvider prov = Provider.of<KeuanganProvider>(context);

    if (prov.isLoadingKeuanganDetail) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: List.generate(3, (index) => loadingList),
        ),
      );
    } else if (prov.isDataKeuanganDetail) {
      return keuanganDetailBuilder();
    } else if (prov.isDataKeuanganDetail) {
      return Container(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            SomeError(),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2 + 30,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () async {
                  await prov.doGetTahunKHS();
                },
                child: Text(
                  'Reaload !',
                  style: TextStyle(color: Colors.white),
                ),
                color: bgColor,
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget keuanganDetailBuilder() {
    final KeuanganProvider prov = Provider.of<KeuanganProvider>(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: prov.dataKeuanganDetail.data.map((e) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Text('Info Keuangan',
                    style: TextStyle(fontSize: 12, color: textPrimary)),
                Text(
                  e.nama,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary),
                )
              ],
            ),
            subtitle: DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text("Jumlah")),
                DataColumn(label: Text("Besar")),
                DataColumn(label: Text("Dibayar")),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(
                      e.jumlah.toString(),
                      style: TextStyle(fontSize: 11),
                    )),
                    DataCell(Text("Rp.${e.besar.toString()}",
                        style: TextStyle(fontSize: 11))),
                    DataCell(Text("Rp.${e.dibayar.toString()}",
                        style: TextStyle(fontSize: 11))),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget bottomTahun() {
    return Container(
        height: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: bgColor),
        child: dropDownBuild());
  }

  dropDownBuild() {
    final KeuanganProvider prov = Provider.of<KeuanganProvider>(context);
    if (prov.isLoading) {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
        child: loadingH1,
      );
    } else if (prov.isData) {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: DropdownButtonFormField(
          items: prov.dataTahunKHS.data.map((e) {
            return new DropdownMenuItem(
                value: e.tahunid,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(LineIcons.calendar),
                    Text('Tahun KHS'),
                    SizedBox(
                      width: 100,
                    ),
                    Container(
                      child: Text(
                        e.tahunid,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
                ));
          }).toList(),
          onChanged: (val) async {
            await prov.doGetKeuanganKHS(tahun: val);
            await prov.doGetKeuanganDetail(tahun: val);
            prov.tahun = val;
            Toast.show(prov.isMsg, context, gravity: Toast.TOP, duration: 3);
          },
          value: prov.isTahun,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      );
    } else if (prov.isError) {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
        child: loadingH1,
      );
    }
  }
}
