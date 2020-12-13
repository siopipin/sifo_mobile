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
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Provider.of<ProfileProvider>(context, listen: false).doGetProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            GestureDetector(
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
                ///TODO tambah fungsi edit profile
              },
            )
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
                    no: '1',
                    ket: 'KTP',
                    data: prov.dataMahasiswa?.data?.kTP ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    no: '2',
                    ket: 'Alamat',
                    data: prov.dataMahasiswa?.data?.alamat ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    no: '3',
                    ket: 'Agama',
                    data: prov.dataMahasiswa?.data?.agama ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    no: '4',
                    ket: 'Email',
                    data: prov.dataMahasiswa?.data?.email ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    no: '5',
                    ket: 'Handphone',
                    data: prov.dataMahasiswa?.data?.handphone ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
                    no: '6',
                    ket: 'Handphone Orang Tua',
                    data: prov.dataMahasiswa?.data?.handphoneOrtu ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
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
                    no: '1',
                    ket: 'Nama Kelas',
                    data: prov.dataMahasiswa?.data?.namaKelas ?? '-'),
                Divider(),
                detailBuider(
                    context: context,
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

  Widget detailBuider(
      {BuildContext context,
      @required String no,
      @required String ket,
      @required String data}) {
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
                    width: 200,
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
                            ? Text(
                                data,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )
                            : loadingH3
                      ],
                    ),
                  ),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.4),
                        shape: BoxShape.circle),
                    child: Center(child: Icon(LineIcons.edit)),
                  )
                ],
              ))
            ],
          ),
        ),
      ],
    );
  }
}
