import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class LogoWidget extends StatelessWidget {
  final double width;
  final double height;
  LogoWidget({this.width = 152, this.height = 150, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(config.logoPath),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
