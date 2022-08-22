import 'package:flutter/material.dart';
import 'package:sisfo_mobile/home/home_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/widgets/foto_profile.dart';

class KhsHeaderWidget extends StatelessWidget {
  const KhsHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchUser = context.watch<HomeProvider>();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //foto
              FotoProfile()
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
