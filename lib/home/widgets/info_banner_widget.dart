import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/foto_profile.dart';

class InfoBannerWidget extends StatelessWidget {
  const InfoBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<HomeProvider>();

    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: config.colorSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 8,
            left: 10,
            child: FotoProfile(),
          ),
          Positioned.fill(
            left: 110,
            top: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Program Studi',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 12),
                                ),
                                Container(
                                  width: 140,
                                  child: Text(
                                    prov.isProdi,
                                    style: TextStyle(
                                        color: config.fontPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Program',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10),
                                ),
                                Text(
                                  prov.isProgram,
                                  style: TextStyle(
                                      color: config.fontPrimary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10),
                                ),
                                Text(
                                  prov.isStatus,
                                  style: TextStyle(
                                      color: config.fontPrimary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
