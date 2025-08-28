import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class Loading {
  shimmerCustom({required double height, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: config.shimmerColor,
      highlightColor: config.shimmerColor,
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(config.padding),
        width: width,
        height: height,
      ),
    );
  }
}

final loading = Loading();
