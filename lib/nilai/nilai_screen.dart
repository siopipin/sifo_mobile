import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/nilai/nilai_provider.dart';
import 'package:sisfo_mobile/providers/global_config.dart';
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
    return Scaffold(
      bottomNavigationBar: bottomTahun(),
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Nilai'),
      ),
      body: SafeArea(child: bodyNilai()),
    );
  }

  Widget bodyNilai() {
    final NilaiProvider prov = Provider.of<NilaiProvider>(context);

    return prov.isDataNilai
        ? Text(prov.dataNilai?.data[0]?.mKKode ?? 'Null')
        : loadingH2;
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
            print(e.tahunid);
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
          onChanged: (val) {
            print(val);
            //TODO Ambil data nilai ketika onChanged
          },
          value: prov.dataTahunKHS.data[0].tahunid,
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
