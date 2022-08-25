import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/khs/widgets/khs_header_widget.dart';
import 'package:sisfo_mobile/profile/providers/profile_mhs_provider.dart';
import 'package:sisfo_mobile/profile/widgets/foto_profile_widget.dart';
import 'package:sisfo_mobile/profile/widgets/text_button_simpan.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/widgets/button_custom.dart';
import 'package:sisfo_mobile/widgets/input_custom.dart';
import 'package:sisfo_mobile/widgets/message_widget.dart';
import 'package:sisfo_mobile/widgets/shimmer_widget.dart';

class ProfileMhsScreen extends StatefulWidget {
  final bool needAppbar;
  ProfileMhsScreen({Key? key, this.needAppbar = true}) : super(key: key);

  @override
  State<ProfileMhsScreen> createState() => _ProfileMhsScreenState();
}

class _ProfileMhsScreenState extends State<ProfileMhsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileMhsProvider>().initial();
      context.read<HomeProvider>().getDataAwal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProfileMhsProvider>();

    return Scaffold(
        appBar: widget.needAppbar == true
            ? AppBar(
                backgroundColor: config.colorPrimary,
                title: Text('Profile'),
              )
            : null,
        body: Scrollbar(
            child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<ProfileMhsProvider>().initial();
                },
                child: ListView(
                  children: [
                    //header

                    FotoProfileWidget(),

                    //body
                    if (prov.stateProfileMhs == StateProfileMhs.loading)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: config.padding),
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
                      )
                    else if (prov.stateProfileMhs == StateProfileMhs.nulldata)
                      MessageWidget(
                        info: 'Tahun ajaran aktif tidak ditemukan',
                        status: InfoWidgetStatus.warning,
                        needBorderRadius: false,
                      )
                    else if (prov.stateProfileMhs == StateProfileMhs.loaded)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: config.padding),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: config.padding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Detail Profile",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                prov.isEdit == true
                                    ? TextButtonSimpan()
                                    : gantiKataSandi(context)
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            detailBuider(
                              context: context,
                              iconEdit: true,
                              no: '1',
                              ket: 'Alamat',
                              data: prov.dataProfileMhs.data!.alamat ?? '-',
                              textCtrl: prov.ctrlAlamat,
                            ),
                            Divider(),
                            detailBuider(
                              context: context,
                              iconEdit: true,
                              no: '2',
                              ket: 'Email',
                              data: prov.dataProfileMhs.data!.email ?? '-',
                              textCtrl: prov.ctrlEmail,
                            ),
                            Divider(),
                            detailBuider(
                                context: context,
                                iconEdit: true,
                                no: '3',
                                ket: 'Handphone',
                                data:
                                    prov.dataProfileMhs.data!.handphone ?? '-',
                                textCtrl: prov.ctrlHP),
                            Divider(),
                            detailBuider(
                                context: context,
                                iconEdit: true,
                                no: '4',
                                ket: 'Handphone Orang Tua',
                                data: prov.dataProfileMhs.data!.handphoneOrtu ??
                                    '-',
                                textCtrl: prov.ctrlHPOrtu),
                            Divider(),
                            detailBuider(
                              context: context,
                              iconEdit: false,
                              no: '5',
                              ket: 'KTP',
                              data: prov.dataProfileMhs.data!.kTP ?? '-',
                            ),
                            Divider(),
                            detailBuider(
                              context: context,
                              iconEdit: false,
                              no: '6',
                              ket: 'Agama',
                              data: prov.dataProfileMhs.data!.agama ?? '-',
                            ),
                            Divider(),
                            detailBuider(
                              context: context,
                              iconEdit: false,
                              no: '7',
                              ket: 'Nama Ibu',
                              data: prov.dataProfileMhs.data!.namaIbu ?? '-',
                            ),
                            Divider(),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Kelas",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            detailBuider(
                              context: context,
                              iconEdit: false,
                              no: '1',
                              ket: 'Nama Kelas',
                              data: prov.dataProfileMhs.data!.namaKelas ?? '-',
                            ),
                            Divider(),
                            detailBuider(
                              context: context,
                              iconEdit: false,
                              no: '2',
                              ket: 'Mentor - PA',
                              data: prov.dataProfileMhs.data!.pA ?? '-',
                            ),
                            Divider(),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    else
                      Container(),
                  ],
                ))));
  }

  Widget detailBuider({
    required BuildContext context,
    required String no,
    required String ket,
    required String data,
    TextEditingController? textCtrl,
    required bool iconEdit,
  }) {
    final prov = context.watch<ProfileMhsProvider>();

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      no,
                      style: TextStyle(
                          fontSize: 30, color: Colors.black.withOpacity(0.3)),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ket,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          prov.isEdit && iconEdit
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width - 120,
                                  margin: EdgeInsets.only(top: 10),
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: config.colorGrey,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.only(top: 7.5, left: 10),
                                  child: TextField(
                                    controller: textCtrl,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Tidak boleh kosong !',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  data,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
                iconEdit
                    ? prov.isEdit == false
                        ? GestureDetector(
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.4),
                                  shape: BoxShape.circle),
                              child: Center(child: Icon(LineIcons.edit)),
                            ),
                            onTap: () {
                              if (prov.isEdit == false) {
                                prov.setEdit = true;
                              } else {
                                prov.setEdit = false;
                              }
                            },
                          )
                        : Container()
                    : Container()
              ],
            )),
      ],
    );
  }

  Widget cancelSection() {
    final prov = context.watch<ProfileMhsProvider>();

    return Container(
      height: 40,
      child: ElevatedButton(
          onPressed: () {
            if (prov.isGantiPassword) {
              prov.setGantiPassword = false;
            } else {
              prov.setGantiPassword = true;
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            primary: Colors.grey,
          ),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  gantiKataSandi(BuildContext context) {
    final prov = context.watch<ProfileMhsProvider>();

    return TextButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: ((context) {
                return AlertDialog(
                  title: Text('Ganti Kata sandi'),
                  content: Container(
                      height: 220,
                      padding: EdgeInsets.all(config.padding / 3),
                      child: Column(
                        children: [
                          InputCustom(
                              ctrl: prov.ctrlPass,
                              hind: 'Password Baru',
                              icon: Icons.password),
                          SizedBox(height: config.padding / 2),
                          InputCustom(
                              ctrl: prov.ctrlRePass,
                              hind: 'Ulangi Password',
                              icon: Icons.password),
                          SizedBox(height: config.padding / 2),
                          ButtonCustom(
                              function: () async {
                                if (prov.ctrlPass.text !=
                                    prov.ctrlRePass.text) {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Kata sandi tidak sama, ulangi lagi.');
                                } else {
                                  await prov
                                      .updateKataSandi(pass: prov.ctrlPass.text)
                                      .then((value) {
                                    if (value == true) {
                                      Fluttertoast.showToast(
                                          msg: 'Kata sandi berhasil diganti.');
                                      Navigator.pop(context);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Gagal mengganti kata sandi');
                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              },
                              isPrimary: true,
                              color: config.colorPrimary,
                              text: 'Simpan')
                        ],
                      )),
                );
              }));
        },
        child: Text('Ganti Password'));
  }
}
