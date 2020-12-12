import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

final loadingH1 = Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    enabled: true,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      width: 200,
      height: 25,
    ));
