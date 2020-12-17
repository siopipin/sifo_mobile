import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/krs/krs_model.dart';
import 'package:sisfo_mobile/krs/krs_provider.dart';
import 'package:sisfo_mobile/krs/widgets/krs_terpilih_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';
import 'package:sisfo_mobile/widgets/loading.dart';
import 'package:toast/toast.dart';

class KrsScreen extends StatefulWidget {
  KrsScreen({Key key}) : super(key: key);

  @override
  _KrsScreenState createState() => _KrsScreenState();
}

class _KrsScreenState extends State<KrsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Provider.of<KrsProvider>(context, listen: false).doGetTahunAjaranAktif();
    });
  }

  @override
  Widget build(BuildContext context) {
    final KrsProvider prov = Provider.of<KrsProvider>(context);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: bgColor,
            title: Text('KRS'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.list_alt),
                  text: 'KRS Mahasiswa',
                ),
                Tab(icon: Icon(Icons.app_registration), text: 'Pengajuan KRS'),
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
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.2),
                                  BlendMode.dstATop),
                              image: AssetImage('assets/images/bg-stikes.jpg'),
                              fit: BoxFit.cover)),
                      padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                LineIcons.user,
                                color: Colors.black.withOpacity(0.4),
                                size: 40,
                              ),
                              cekStatusKRS(),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              cekTahunKRS(),
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
                              FutureBuilder(
                                future: store.npm(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: textPrimary),
                                    );
                                  } else {
                                    return loadingH3;
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    cekKRS()
                  ],
                ),
              )),

              //Pengajuan KRS
              SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.2),
                                  BlendMode.dstATop),
                              image: AssetImage('assets/images/bg-stikes.jpg'),
                              fit: BoxFit.cover)),
                      padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                LineIcons.user,
                                color: Colors.black.withOpacity(0.4),
                                size: 40,
                              ),
                              prov.isStatusKepengurusanKRS
                                  ? Container()
                                  : cekStatusKRS(),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              cekTahunKRS(),
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
                              FutureBuilder(
                                future: store.npm(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: textPrimary),
                                    );
                                  } else {
                                    return loadingH3;
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    checkStatusKepengurusan(),
                    prov.isStatusKepengurusanKRS
                        ? Container(
                            child: Column(
                            children: [
                              dropDownBuild(),
                              prov.isAdaDataKRSPaketTerpilih
                                  ? Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      width: MediaQuery.of(context).size.width,
                                      child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          color: bgColor,
                                          onPressed: () {
                                            //TODO simpan krs
                                          },
                                          child: Text(
                                            'Ambil Paket KRS',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  : Container()
                            ],
                          ))
                        : Container(),
                    cekBodyKRS()
                  ],
                ),
              ))
            ],
          ),
        ));
  }

  Widget cekBodyKRS() {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (prov.isStatusKepengurusanKRS && !prov.isPilihPaket) {
      return Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/info.png',
                width: MediaQuery.of(context).size.width / 2 + 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Masa pengurusan KRS!\nSilahkan pilih paket KRS semeseter ini.',
                style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }
    if (prov.isStatusKepengurusanKRS && prov.isPilihPaket) {
      return KRSTerpilihWidget();
    } else if (!prov.isStatusKepengurusanKRS) {
      return cekKRS();
    } else {
      return Container();
    }
  }

  Widget checkStatusKepengurusan() {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (prov.isStatusKepengurusanKRS && !prov.isPilihPaket) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
              child: Row(
                children: [
                  Icon(LineIcons.info_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Flexible(
                      child: Text(
                    'Tidak ada paket mata kuliah yang dipilih. Pilihlah paket mata kuliah untuk di bawah terlebih dahulu',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ))
                ],
              ),
            ),
          ],
        ),
      );
    } else if (prov.isStatusKepengurusanKRS && prov.isPilihPaket) {
      return Container();
    } else if (prov.isStatusKepengurusanKRS) {
      return Container(
        padding: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        color: Colors.green,
        child: Row(
          children: [
            Icon(LineIcons.info_circle, color: Colors.white),
            SizedBox(width: 10),
            Flexible(
                child: Text(
              'Batas pengambilan / pengubahan KRS sudah selesai. KRS tidak dapat diubah',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ))
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  dropDownBuild() {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (prov.isLoadingPaketKRS) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
          child: loadingDropDown);
    } else if (prov.isAdaDataPaketKRS) {
      return Container(
        child: DropdownButtonFormField(
          items: prov.dataPaketKRS.data.map((e) {
            return new DropdownMenuItem(
                value: e.mkpaketid,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(LineIcons.dot_circle_o),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                      child: Text(
                        e.namapaket,
                      ),
                    )
                  ],
                ));
          }).toList(),
          onChanged: (val) async {
            prov.setPilihPaket = true;
            await prov.doGetKRSPaketTerpilih(
                tahunid: prov.dataTahunAktif.data.tahunTA,
                paketid: val.toString());
            Toast.show(prov.isMessage, context,
                gravity: Toast.TOP, duration: 3);
          },
          // value: 'Pilih Paket',
          hint: Row(
            children: [
              Icon(LineIcons.check_circle_o),
              SizedBox(
                width: 10,
              ),
              Text("Pilih Paket")
            ],
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      );
    } else if (prov.isErrorPaketKRS) {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
        child: loadingH1,
      );
    } else {
      return Container();
    }
  }

  Widget cekTahunKRS() {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (prov.isLoading) {
      return loadingH1;
    } else if (prov.isErrorTahun) {
      print('Error at cekTahunKRS');
      return Container();
    } else if (!prov.isDataTAaktif) {
      return Text('Tahun Ajaran Aktif tidak ada!');
    } else if (prov.isDataTAaktif) {
      return Text(prov.dataTahunAktif?.data?.namaTA ?? '-');
    } else {
      return Container();
    }
  }

  Widget cekStatusKRS() {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (prov.isLoadingStatusKRS) {
      return Container();
    } else if (prov.isErrorStatusKRS) {
      print('Error at CekStatusKRS');
      return Container();
    } else if (!prov.isAdaDataStatusKRS) {
      return Text('Tidak ditemukan!');
    } else if (prov.isAdaDataStatusKRS) {
      return Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: primaryRed,
          ),
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                "${prov.dataStatusKRS?.data?.statuskrs ?? '-'}",
                style: TextStyle(color: Colors.white, fontSize: 12),
              )));
    } else {
      return Container();
    }
  }

  Widget cekKRS() {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (prov.isLoadingKRS) {
      return loadingTable;
    } else if (prov.isErrorKRS) {
      print('Error at CekKRS');
      return Container();
    } else if (!prov.isAdaDataKRS) {
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
    } else if (prov.isAdaDataKRS) {
      return Container(
        padding: EdgeInsets.only(left: 15, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            prov.isSenin
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryYellow,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Senin",
                          style: TextStyle(color: Colors.black87, fontSize: 11),
                        )))
                : Container(),
            prov.isSenin ? cekKRSHari(hari: 1) : Container(),
            Divider(),
            prov.isSelasa
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryYellow,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Selasa",
                          style: TextStyle(color: Colors.black87, fontSize: 11),
                        )))
                : Container(),
            prov.isSelasa ? cekKRSHari(hari: 2) : Container(),
            Divider(),
            prov.isRabu
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryYellow,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Rabu",
                          style: TextStyle(color: Colors.black87, fontSize: 11),
                        )))
                : Container(),
            prov.isRabu ? cekKRSHari(hari: 3) : Container(),
            Divider(),
            prov.isKamis
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryYellow,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Kamis",
                          style: TextStyle(color: Colors.black87, fontSize: 11),
                        )))
                : Container(),
            prov.isKamis ? cekKRSHari(hari: 4) : Container(),
            Divider(),
            prov.isJumat
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryYellow,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Jumat",
                          style: TextStyle(color: Colors.black87, fontSize: 11),
                        )))
                : Container(),
            prov.isJumat ? cekKRSHari(hari: 5) : Container(),
            Divider(),
            prov.isSabtu
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryYellow,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Sabtu",
                          style: TextStyle(color: Colors.black87, fontSize: 11),
                        )))
                : Container(),
            prov.isSabtu ? cekKRSHari(hari: 6) : Container(),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget expandedBuilder(Data e, int i) {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    return Container(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          print(i);
          if (e.isExpanded == true) {
            prov.setExpanded(i, false);
          } else if (e.isExpanded == false) {
            prov.setExpanded(i, true);
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
                    Text('Nama Mata Kuliah',
                        style: TextStyle(fontSize: 11, color: textPrimary)),
                    Text(
                      e.nama ?? '-',
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
                    Text('Dosen : ',
                        style: TextStyle(
                          fontSize: 12,
                        )),
                    Flexible(
                        child: Text(
                      e.dSN ?? '-',
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
                    DataCell(Text(e.mKKode ?? '-')),
                    DataCell(Text('${e.jM ?? '-'} - ${e.jS ?? '-'}')),
                    DataCell(Text(e.ruangID ?? '-')),
                    DataCell(Text(e.sKS.toString() ?? '-')),
                  ],
                ),
              ],
            ),
            isExpanded: e.isExpanded,
          )
        ],
      ),
    );
  }

  Widget cekKRSHari({@required hari}) {
    final KrsProvider prov = Provider.of<KrsProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: prov.dataKRS.data.map((e) {
        var index = prov.dataKRS.data.indexOf(e);
        if (e.hariID == hari) {
          return expandedBuilder(e, index);
        } else {
          return Container();
        }
      }).toList(),
    );
  }
}
