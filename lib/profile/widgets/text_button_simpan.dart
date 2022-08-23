import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/profile/providers/profile_mhs_provider.dart';

class TextButtonSimpan extends StatelessWidget {
  const TextButtonSimpan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProfileMhsProvider>();

    return Row(
      children: [
        TextButton(
            onPressed: () {
              prov.setEdit = false;
            },
            child: Text('BATAL')),
        TextButton(
            onPressed: () async {
              if (prov.ctrlEmail.text.isEmpty ||
                  prov.ctrlHP.text.isEmpty ||
                  prov.ctrlHPOrtu.text.isEmpty) {
                Fluttertoast.showToast(msg: 'Data tidak boleh kosong!');
              } else {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        title: Text('Simpan Profile'),
                        content: Text(
                            'Pastikan data adalah informasi yang sebenar-benarnya!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await prov
                                  .updateProfile(
                                alamat: prov.ctrlAlamat.text,
                                email: prov.ctrlEmail.text,
                                hp: prov.ctrlHP.text,
                                hpOrtu: prov.ctrlHPOrtu.text,
                              )
                                  .then((value) {
                                if (value == true) {
                                  context.read<ProfileMhsProvider>().initial();
                                  Navigator.pop(context);
                                  prov.setEdit = false;
                                } else {
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Text('Simpan'),
                          ),
                        ],
                      );
                    }));
              }
            },
            child: Text('SIMPAN'))
      ],
    );
  }
}
