import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';
import 'package:sisfo_mobile/widgets/loading.dart';
import 'package:provider/provider.dart';

class FotoProfile extends StatelessWidget {
  const FotoProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchHome = context.watch<HomeProvider>();

    return Container(
        height: 100,
        child: watchHome.dataFoto.isEmpty
            ? Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                //TODO cek foto ketika ambil dari server.
                imageUrl: '${config.imgurl}/${watchHome.dataFoto}',
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: 82.0,
                    height: 100.0,
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
              ));
  }
}
