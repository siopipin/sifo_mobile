import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/home_screen.dart';
import 'package:sisfo_mobile/krs/krs_provider.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/krs/widgets/krs_terpilih_widget.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';
import 'package:sisfo_mobile/widgets/error_widget.dart';
import 'package:sisfo_mobile/widgets/loading.dart';

class KrsPengajuanScreen extends StatefulWidget {
  KrsPengajuanScreen({Key? key}) : super(key: key);

  @override
  _KrsPengajuanScreenState createState() => _KrsPengajuanScreenState();
}

class _KrsPengajuanScreenState extends State<KrsPengajuanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: config.colorPrimary,
          title: Text('Pengajuan KRS'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          LineIcons.user,
                          color: Colors.black.withOpacity(0.4),
                          size: 40,
                        ),
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
                          future: store.showNama(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              );
                            } else {
                              return loadingH2;
                            }
                          },
                        ),
                        FutureBuilder(
                          future: store.showNPM(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
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
              cekJadwalKRS(),
            ],
          ),
        )));
  }

  Widget cekJadwalKRS() {
    final KrsProvider prov = Provider.of<KrsProvider>(context);

    if (prov.isLoadingStatusPengurusanKRS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
            3,
            (index) => Center(
                  child: loadingList,
                )),
      );
    } else if (prov.isAdaDataStatusPengurusanKRS) {
      if (prov.dataStatusPengurusanKRS.status == true) {
        return Column(
          children: [
            cekPaketTerpilih(),
            Container(
                child: Column(
              children: [
                dropDownBuild(),
                prov.isAdaDataKRSPaketTerpilih
                    ? Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: config.colorBlueDark),
                            onPressed: () async {
                              await prov.doGetSimpanKRS();
                              if (prov.isAdaDataSimpanKRS) {
                                Fluttertoast.showToast(msg: prov.isMessage);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => HomeScreen()));
                              } else {
                                Fluttertoast.showToast(msg: prov.isMessage);
                              }
                            },
                            child: !prov.isLoadingSimpanKRS
                                ? Row(
                                    children: [
                                      Text(
                                        'Ambil Paket KRS',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        LineIcons.save,
                                        color: Colors.white,
                                      )
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  )
                                : Text(
                                    'Sedang menyimpan',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                      )
                    : Container()
              ],
            )),
            cekBodyKRS()
          ],
        );
      } else {
        return MessageWidget(
            info: 'Jadwal KRS telah selesai. Hubungi Administrasi');
      }
    } else {
      return Center(
          child: Column(
        children: [
          SomeError(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.blueGrey),
            onPressed: () async {
              await prov.doGetKRS(khsid: prov.dataStatusKRS.data!.kHSID!);
              Fluttertoast.showToast(msg: prov.isMessage);
            },
            child: Text('Reload'),
          )
        ],
      ));
    }
  }

  Widget cekPaketTerpilih() {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (!prov.isPilihPaket) {
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
                  Icon(LineIcons.infoCircle, color: Colors.white),
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
    } else if (prov.isPilihPaket) {
      return Container(
        padding: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        color: Colors.green,
        child: Row(
          children: [
            Icon(LineIcons.infoCircle, color: Colors.white),
            SizedBox(width: 10),
            Flexible(
                child: Text(
              'Klik "Ambil" untuk menyimpan Paket KRS.',
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
          items: prov.dataPaketKRS.data!.map((e) {
            return new DropdownMenuItem(
                value: e.mkpaketid,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(LineIcons.dotCircle),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                      child: Text(
                        e.namapaket!,
                      ),
                    )
                  ],
                ));
          }).toList(),
          onChanged: (val) async {
            prov.setPilihPaket = true;
            await prov.doGetKRSPaketTerpilih(
                tahunid: prov.dataTahunAktif.data!.tahunTA!,
                paketid: val.toString());
            Fluttertoast.showToast(msg: prov.isMessage);
          },
          // value: 'Pilih Paket',
          hint: Row(
            children: [
              Icon(LineIcons.checkCircle),
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

  Widget cekStatusKRS() {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (prov.isLoadingStatusKRS) {
      return Container();
    } else if (prov.isErrorStatusKRS) {
      print('Error at CekStatusKRS');
      return Container();
    } else if (!prov.isAdaDataStatusKRS) {
      return Container();
    } else if (prov.isAdaDataStatusKRS) {
      return Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: config.colorPrimary,
          ),
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                "${prov.dataStatusKRS.data!.statuskrs}",
                style: TextStyle(color: Colors.white, fontSize: 12),
              )));
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
      return Text(prov.dataTahunAktif.data!.namaTA!);
    } else {
      return Container();
    }
  }

  Widget cekBodyKRS() {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (prov.isStatusKepengurusanKRS && !prov.isPilihPaket) {
      return Container(
        padding: EdgeInsets.only(top: 10),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }
    if (prov.isStatusKepengurusanKRS && prov.isPilihPaket) {
      return KRSTerpilihWidget();
    } else {
      return Container();
    }
  }
}
