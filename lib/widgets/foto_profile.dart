import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/profile/providers/profile_mhs_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/loading.dart';
import 'package:provider/provider.dart';

class FotoProfile extends StatelessWidget {
  const FotoProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchHome = context.watch<HomeProvider>();
    final watchProfile = context.watch<ProfileMhsProvider>();

    return Container(
        height: 100,
        child: watchHome.dataFoto.isEmpty ||
                watchProfile.stateProfileMhs != StateProfileMhs.loaded
            ? Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                cacheKey:
                    '${config.imgurl}/${watchProfile.dataProfileMhs.data!.foto!}${DateTime.now().hour.toString()}',
                imageUrl:
                    '${config.imgurl}/${watchProfile.dataProfileMhs.data!.foto!}',
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
