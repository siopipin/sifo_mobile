import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/krs/krs_provider.dart';
import 'package:sisfo_mobile/widgets/loading.dart';
import 'package:toast/toast.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final KrsProvider prov = Provider.of<KrsProvider>(context);
    if (prov.isLoadingPaketKRS) {
      //TODO cek loading dropDownBuild
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
}
