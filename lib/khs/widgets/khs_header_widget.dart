import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/profile/providers/profile_mhs_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/services/initial_provider.dart';
import 'package:sisfo_mobile/services/storage.dart';
import 'package:sisfo_mobile/widgets/foto_profile.dart';

class KhsHeaderWidget extends StatelessWidget {
  final bool isHome;
  const KhsHeaderWidget({Key? key, this.isHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchUser = context.watch<HomeProvider>();
    final watchProfile = context.watch<ProfileMhsProvider>();

    final watcInitial = context.watch<InitialProvider>();
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(config.bgPath),
              fit: BoxFit.cover)),
      padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //foto
              FotoProfile(),
              if (isHome == true)
                TextButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Ganti Foto'),
                            content:
                                Text('Pilih Gambar dari galery atau kamera'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  var tmp = await watcInitial.picker
                                      .pickImage(source: ImageSource.gallery);
                                  if (tmp != null) {
                                    watcInitial.setFile = tmp;

                                    //simpan foto dan reload homeprovider
                                    watcInitial
                                        .updateFoto()
                                        .then((value) async {
                                      if (value == true) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Foto profile berhasil diganti');
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                },
                                child: Text('Galery'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  var tmp = await watcInitial.picker
                                      .pickImage(source: ImageSource.camera);
                                  if (tmp != null) {
                                    watcInitial.setFile = tmp;

                                    //simpan foto dan reload homeprovider
                                    watcInitial
                                        .updateFoto()
                                        .then((value) async {
                                      if (value == true) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Foto profile berhasil diganti');
                                        print('akan simpan foto');
                                        await context
                                            .read<ProfileMhsProvider>()
                                            .initial();
                                        print(watchProfile.stateProfileMhs
                                            .toString());

                                        print('simpan foto');
                                        print(
                                            'foto baru: ${watchProfile.dataProfileMhs.data!.foto!}');
                                        await store.saveFoto(watchProfile
                                            .dataProfileMhs.data!.foto!);
                                        await context
                                            .read<HomeProvider>()
                                            .initial();

                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                },
                                child: Text('Camera'),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.change_circle),
                        Text('Ganti'),
                      ],
                    ))
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                watchUser.isProdi,
                style: TextStyle(fontSize: config.fontSizeTiny),
              ),
              Text(
                watchUser.isName,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: config.fontSizeH2),
              ),
              Text(
                watchUser.isNIM,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: config.fontSizeH3),
              )
            ],
          )
        ],
      ),
    );
  }
}
