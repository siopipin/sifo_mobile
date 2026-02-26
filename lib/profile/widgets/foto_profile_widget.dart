import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/profile/providers/profile_mhs_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/initial_provider.dart';
import 'package:sisfo_mobile/services/storage.dart';
import 'package:sisfo_mobile/widgets/loading.dart';

class FotoProfileWidget extends StatefulWidget {
  FotoProfileWidget({Key? key}) : super(key: key);

  @override
  State<FotoProfileWidget> createState() => _FotoProfileWidgetState();
}

class _FotoProfileWidgetState extends State<FotoProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final watchUser = context.watch<HomeProvider>();
    final watchProfile = context.watch<ProfileMhsProvider>();
    final watchHome = context.watch<HomeProvider>();

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
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    watchHome.dataFoto.isEmpty ||
                            watchProfile.stateProfileMhs !=
                                StateProfileMhs.loaded
                        ? ClipOval(
                            child: Image.asset(
                              "assets/images/logo.png",
                              width: 82,
                              height: 82,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CachedNetworkImage(
                            cacheKey:
                                '${config.imgurl}/${watchProfile.dataProfileMhs.data!.foto!}${DateTime.now().hour.toString()}',
                            imageUrl:
                                '${config.imgurl}/${watchProfile.dataProfileMhs.data!.foto!}',
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                width: 82.0,
                                height: 82.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              );
                            },
                            placeholder: (context, url) => loadingFoto,
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
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
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (tmp != null) {
                                        watcInitial.setFile = tmp;
                                        await store.removeFoto();

                                        // simpan foto dan reload provider
                                        watcInitial
                                            .updateFoto()
                                            .then((value) async {
                                          if (value == true) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Foto profile berhasil diganti');
                                            await context
                                                .read<ProfileMhsProvider>()
                                                .refresh();
                                            await context
                                                .read<HomeProvider>()
                                                .getDataAwal();
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          }
                                        });
                                      }
                                    },
                                    child: Text('Galery'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      var tmp = await watcInitial.picker
                                          .pickImage(
                                              source: ImageSource.camera);
                                      if (tmp != null) {
                                        watcInitial.setFile = tmp;
                                        await store.removeFoto();

                                        await watcInitial
                                            .updateFoto()
                                            .then((value) async {
                                          if (value == true) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Foto profile berhasil diganti');
                                            await context
                                                .read<ProfileMhsProvider>()
                                                .refresh();
                                            await context
                                                .read<HomeProvider>()
                                                .getDataAwal();
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
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

                          print('simpan foto');
                          print(
                              'foto baru: ${watchProfile.dataProfileMhs.data!.foto!}');
                          await store.saveFoto(
                              watchProfile.dataProfileMhs.data!.foto!);
                          await context.read<ProfileMhsProvider>().refresh();
                          await context.read<HomeProvider>().getDataAwal();
                          print('selesai');
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 16,
                            color: config.colorPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
