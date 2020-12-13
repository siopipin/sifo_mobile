import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/profile/profile_provider.dart';
import 'package:sisfo_mobile/providers/global_config.dart';
import 'package:sisfo_mobile/widgets/bottomNavigation.dart';
import 'package:sisfo_mobile/widgets/loading.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _alamat = TextEditingController();
  TextEditingController _hp = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _hportu = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Provider.of<ProfileProvider>(context, listen: false).doGetProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider prov = Provider.of<ProfileProvider>(context);
    return Scaffold(
        bottomNavigationBar: BottomBar(tabIndex: 3),
        appBar: AppBar(
          backgroundColor: bgColor,
          leading: Container(
            margin: EdgeInsets.all(6),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fill)),
          ),
          actions: [
            prov.isEdit
                ? GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Icon(
                            LineIcons.close,
                            color: textWhite,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: textWhite),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (prov.isEdit == false) {
                        prov.setEdit = true;
                      } else {
                        prov.setEdit = false;
                      }
                    },
                  )
                : Container(),
            prov.isEdit
                ? GestureDetector(
                    child: Row(
                      children: [
                        Text(
                          'Save',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryYellow),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(LineIcons.save, color: primaryYellow)
                      ],
                    ),
                    onTap: () {
                      ///TODO tambah fungsi edit profile
                    },
                  )
                : GestureDetector(
                    child: Row(
                      children: [
                        Text('Edit'),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(LineIcons.edit)
                      ],
                    ),
                    onTap: () {
                      if (prov.isEdit == false) {
                        prov.setEdit = true;
                      } else {
                        prov.setEdit = false;
                      }
                    },
                  ),
          ],
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [infoBuilder(context)],
            ),
          ),
        )));
  }

  Widget infoBuilder(BuildContext context) {
    final ProfileProvider prov = Provider.of<ProfileProvider>(context);
    _alamat.text = prov.dataMahasiswa?.data?.alamat ?? '-';
    _email.text = prov.dataMahasiswa?.data?.email ?? '-';
    _hp.text = prov.dataMahasiswa?.data?.handphone ?? '-';
    _hportu.text = prov.dataMahasiswa?.data?.handphoneOrtu ?? '-';

    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          bottom: 460,
          child: Container(
            height: size.height * 0.45,
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    image: AssetImage('assets/images/bg-nurse.jpg'),
                    fit: BoxFit.cover)),
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    prov.isData
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: primaryRed,
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "${prov.statusMahasiswa}",
                                  style: TextStyle(color: Colors.white),
                                )))
                        : loadingH1,
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          LineIcons.user,
                          color: Colors.black.withOpacity(0.4),
                          size: 40,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            prov.isData
                                ? Text(
                                    "${prov.dataMahasiswa?.data?.nama ?? '-'}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary),
                                  )
                                : loadingH2,
                            SizedBox(
                              height: 3,
                            ),
                            prov.isData
                                ? Text(
                                    "${prov.dataMahasiswa?.data?.mhswID ?? '-'}",
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 14,
                                    ),
                                  )
                                : loadingH2
                          ],
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(LineIcons.archive),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              child: prov.data
                                  ? Text(
                                      "Program : ${prov.dataMahasiswa?.data?.programID ?? '-'} - ${prov.programId}",
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 14,
                                      ),
                                    )
                                  : loadingProgramStudi,
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(LineIcons.graduation_cap),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              child: prov.data
                                  ? Text(
                                      "Program Studi",
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 14,
                                      ),
                                    )
                                  : loadingProgramStudi,
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: prov.isData
                            ? Text(
                                "${prov.dataMahasiswa?.data?.prodiID ?? '-'}",
                                style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900),
                              )
                            : loadingH1)
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: size.height * 0.32),
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 20, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Detail Profile",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                detailBuider(
                    context: context,
                    iconEdit: true,
                    no: '1',
                    ket: 'Alamat',
                    data: prov.dataMahasiswa?.data?.alamat ?? '-',
                    textCtrl: _alamat),
                Divider(),
                detailBuider(
                    context: context,
                    iconEdit: true,
                    no: '2',
                    ket: 'Email',
                    textCtrl: _email,
                    data: prov.dataMahasiswa?.data?.email ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    iconEdit: true,
                    no: '3',
                    ket: 'Handphone',
                    textCtrl: _hp,
                    data: prov.dataMahasiswa?.data?.handphone ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    iconEdit: true,
                    no: '4',
                    ket: 'Handphone Orang Tua',
                    textCtrl: _hportu,
                    data: prov.dataMahasiswa?.data?.handphoneOrtu ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    iconEdit: false,
                    no: '5',
                    ket: 'KTP',
                    data: prov.dataMahasiswa?.data?.kTP ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    iconEdit: false,
                    no: '6',
                    ket: 'Agama',
                    data: prov.dataMahasiswa?.data?.agama ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    iconEdit: false,
                    no: '7',
                    ket: 'Nama Ibu',
                    data: prov.dataMahasiswa?.data?.namaIbu ?? '-'),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Kelas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                detailBuider(
                    context: context,
                    iconEdit: false,
                    no: '1',
                    ket: 'Nama Kelas',
                    data: prov.dataMahasiswa?.data?.namaKelas ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    iconEdit: false,
                    no: '2',
                    ket: 'Mentor - PA',
                    data: prov.dataMahasiswa?.data?.pA ?? '-'),
                Divider(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget detailBuider({
    BuildContext context,
    @required String no,
    @required String ket,
    @required String data,
    TextEditingController textCtrl,
    @required bool iconEdit,
  }) {
    final ProfileProvider prov = Provider.of<ProfileProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: <Widget>[
                  Text(
                    no,
                    style: TextStyle(
                        fontSize: 30, color: Colors.black.withOpacity(0.3)),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 + 23,
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
                        prov.isData
                            ? prov.isEdit && iconEdit
                                ? Container(
                                    margin: EdgeInsets.only(top: 10),
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: grey,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding:
                                        EdgeInsets.only(top: 7.5, left: 10),
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
                                      fontSize: 18,
                                    ),
                                  )
                            : loadingH3
                      ],
                    ),
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
              ))
            ],
          ),
        ),
      ],
    );
  }
}
