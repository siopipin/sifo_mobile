import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/nilai/nilai_provider.dart';
import 'package:sisfo_mobile/providers/global_config.dart';
import 'package:sisfo_mobile/providers/storage.dart';
import 'package:sisfo_mobile/widgets/error_widget.dart';
import 'package:sisfo_mobile/widgets/loading.dart';
import 'package:toast/toast.dart';

class NilaiScreen extends StatefulWidget {
  NilaiScreen({Key key}) : super(key: key);

  @override
  _NilaiScreenState createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Provider.of<NilaiProvider>(context, listen: false).doGetTahunKHS();
    });
  }

  @override
  Widget build(BuildContext context) {
    final NilaiProvider prov = Provider.of<NilaiProvider>(context);

    return Scaffold(
      bottomNavigationBar: bottomTahun(),
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Nilai'),
      ),
      body: SafeArea(
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
                      Text('Nilai Tahun KHS : ${prov.isTahun}'),
                      FutureBuilder(
                        future: store.nama(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
            checkBuilder()
          ],
        ),
      )),
    );
  }

  Widget checkBuilder() {
    final NilaiProvider prov = Provider.of<NilaiProvider>(context);

    if (prov.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: List.generate(3, (index) => loadingList),
        ),
      );
    } else if (prov.isData) {
      return expansionList();
    } else if (prov.isError) {
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

  Widget expansionList() {
    final NilaiProvider prov = Provider.of<NilaiProvider>(context);

    return Container(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          if (prov.dataNilai.data[index].isExpanded == true) {
            prov.setExpanded(index, false);
          } else if (prov.dataNilai.data[index].isExpanded == false) {
            prov.setExpanded(index, true);
          }
        },
        children: prov.dataNilai.data.map((item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama Mata Kuliah',
                        style: TextStyle(fontSize: 11, color: textPrimary)),
                    Text(
                      item.nama,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textPrimary),
                    )
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Kode MK : ',
                        style: TextStyle(
                          fontSize: 12,
                        )),
                    Text(item.mKKode,
                        style: TextStyle(
                          fontSize: 12,
                        ))
                  ],
                ),
              );
            },
            body: DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text("No.")),
                DataColumn(label: Text("Nama")),
                DataColumn(label: Text("Detail")),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("1")),
                    DataCell(Text("SKS")),
                    DataCell(Text(item.sKS.toString() ?? '-')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("2")),
                    DataCell(Text("Tugas 1")),
                    DataCell(Text(item.tugas1.toString() ?? '-')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("3")),
                    DataCell(Text("Tugas 2")),
                    DataCell(Text(item.tugas2.toString() ?? '-')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("4")),
                    DataCell(Text("Tugas 3")),
                    DataCell(Text(item.tugas3.toString() ?? '-')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("5")),
                    DataCell(Text("Value Presensi")),
                    DataCell(Text(item.vPresensi.toString() ?? '-')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("6")),
                    DataCell(Text("Presensi Kelas")),
                    DataCell(Text(item.nPresensi.toString() ?? '-')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("7")),
                    DataCell(Text("UTS")),
                    DataCell(Text(item.uTS.toString() ?? '-')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("8")),
                    DataCell(Text("UAS")),
                    DataCell(Text(item.uAS.toString() ?? '-')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("9")),
                    DataCell(Text("Nilai Akhi")),
                    DataCell(Text(item.nilaiAkhir.toString() ?? '-')),
                  ],
                ),
              ],
            ),
            isExpanded: item.isExpanded,
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
    final NilaiProvider prov = Provider.of<NilaiProvider>(context);
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
            //TODO Ambil data nilai ketika onChanged
            await prov.doGetNilai(tahun: val);
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
      ///TODO tampilkan pesan error pada body dan tombol untuk refresh
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
        child: loadingH1,
      );
    }
  }
}
