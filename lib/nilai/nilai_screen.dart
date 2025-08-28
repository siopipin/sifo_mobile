import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/nilai/nilai_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';
import 'package:sisfo_mobile/widgets/error_widget.dart';
import 'package:sisfo_mobile/widgets/loading.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class NilaiScreen extends StatefulWidget {
  final bool needAppbar;
  NilaiScreen({Key? key, this.needAppbar = true}) : super(key: key);

  @override
  _NilaiScreenState createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NilaiProvider>().initial());
  }

  @override
  Widget build(BuildContext context) {
    final NilaiProvider prov = Provider.of<NilaiProvider>(context);
    return Scaffold(
      bottomNavigationBar: bottomTahun(),
      appBar: widget.needAppbar == true
          ? AppBar(
              backgroundColor: config.colorPrimary,
              title: Text('Nilai'),
            )
          : null,
      body: SafeArea(
          child: ListView(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: AssetImage('assets/images/bg-stikes.jpg'),
                  fit: BoxFit.cover)),
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
                  Text('Tahun Ajaran : ${prov.isTahun}'),
                  FutureBuilder(
                    future: store.showNama(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
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
      ])),
    );
  }

  Widget checkBuilder() {
    final NilaiProvider prov = Provider.of<NilaiProvider>(context);

    if (prov.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: config.padding),
        child: Column(
          children: [
            SizedBox(height: config.padding),
            loading.shimmerCustom(height: 50),
            Padding(
              padding: EdgeInsets.only(top: config.padding / 2),
              child: loading.shimmerCustom(height: 50),
            )
          ],
        ),
      );
    } else if (prov.isDataNilai) {
      print('PROV.ISDATA: ${prov.isDataNilai}');
      return expansionList();
    } else if (prov.isErrorNilai) {
      print('PROV.ISERRORNILAI: ${prov.isErrorNilai}');
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: TextStyle(color: Colors.blueGrey)),
              onPressed: () async {
                await prov.doGetTahunKHS();

                Fluttertoast.showToast(msg: prov.message);
              },
              child: Text('Reload'),
            )
          ],
        ),
      );
    } else {
      print('checkBuilder / Else');
      return Container();
    }
  }

  Widget expansionList() {
    final NilaiProvider prov = Provider.of<NilaiProvider>(context);

    return Container(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          if (prov.dataNilai.data![index].isExpanded == true) {
            prov.setExpanded(index, false);
          } else if (prov.dataNilai.data![index].isExpanded == false) {
            prov.setExpanded(index, true);
          }
        },
        children: prov.dataNilai.data!.map((item) {
          return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama Mata Kuliah',
                        style: TextStyle(
                          fontSize: 11,
                        )),
                    Text(
                      item.nama!,
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
                    Text('Kode MK : ',
                        style: TextStyle(
                          fontSize: 12,
                        )),
                    Text(item.mKKode!,
                        style: TextStyle(
                          fontSize: 12,
                        )),
                    Text('   -    ${item.sKS.toString()}',
                        style: TextStyle(
                          fontSize: 12,
                        )),
                    Text(' SKS',
                        style: TextStyle(
                          fontSize: 12,
                        )),
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
                    DataCell(Text("Tugas 1")),
                    DataCell(Text(item.tugas1.toString())),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("2")),
                    DataCell(Text("Tugas 2")),
                    DataCell(Text(item.tugas2.toString())),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("3")),
                    DataCell(Text("Tugas 3")),
                    DataCell(Text(item.tugas3.toString())),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("4")),
                    DataCell(Text("Jumlah Absensi")),
                    DataCell(Text(item.vPresensi.toString())),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("5")),
                    DataCell(Text("Nilai Absensi")),
                    DataCell(Text(item.nPresensi.toString())),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("6")),
                    DataCell(Text("UTS")),
                    DataCell(Text(item.uTS.toString())),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("7")),
                    DataCell(Text("UAS")),
                    DataCell(Text(item.uAS.toString())),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text("8")),
                    DataCell(Text("Nilai Akhi")),
                    DataCell(Text(item.nilaiAkhir.toString())),
                  ],
                ),
              ],
            ),
            isExpanded: item.isExpanded!,
          );
        }).toList(),
      ),
    );
  }

  Widget bottomTahun() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
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
        padding: EdgeInsets.only(left: 0, right: 0),
        child: DropdownButtonFormField(
          items: prov.dataTahunKHS.data!.map((e) {
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
            await prov.doGetNilai(tahun: val.toString());
            prov.tahun = val.toString();
            Fluttertoast.showToast(msg: prov.isMsg);
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
