import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Config {
  final padding = 16.0;

  final colorPrimary = Color(0xFFCC0000);
  final colorSecondary = Color(0xFFFFEB3B);
  final colorBlueDark = Color(0xFF3E4095);
  final colorBackgroundWhite = Color(0xFFFFFFFF);
  final colorGrey = Color(0xFFF5F5F7);

  //fontconfig
  final fontPrimary = Color(0xFF3E4095);
  final fontBlack = Color(0xFF000000);
  final fontWhite = Color(0xFFFFFFFF);
  final fontSizeH1 = 18.0;
  final fontSizeH2 = 16.0;
  final fontSizeH3 = 14.0;
  final fontSizeTiny = 12.0;

//Currency
  final rpFormat = new NumberFormat.currency(
      locale: "id_ID", symbol: "Rp.", decimalDigits: 0);

  final appTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: Color(0xFFFFFFFF),
  );

//Development
  // final api = "http://10.0.2.2:3000/mobile";
  // final fotoUrl = "http://10.0.2.2:3000/images";
  // final apiPdf = 'http://103.167.34.22/sisfo/jur/krs.cetak.php?khsid=';
  // final imgurl = 'http://10.0.2.2:3000/images';

//Production
  final api = 'http://mystikes.gunungsari.id:3000/mobile';
  final fotoUrl = 'http://mystikes.gunungsari.id:3000/images';
  final apiPdf = 'http://103.167.34.22/sisfo/jur/krs.cetak.php?khsid=';
  final imgurl = 'http://mystikes.gunungsari.id:3000/images';

//logo
  final String logoPath = 'assets/images/logo.png';
  final String bgPath = 'assets/images/bg-stikes.jpg';

  final header = {
    'Content-Type': 'application/json',
  };

  //String
  final textTitle = "STIKES Gunung Sari";
  final textDescription = "Sekolah Tinggi Ilmu Kesehatan Gunung Sari \n V.1.0";

  final shimmerColor = const Color(0xffe0e0e0);

  appBar({required String title, List<Widget> action = const []}) {
    return AppBar(
      backgroundColor: config.colorPrimary,
      title: Text(title),
      actions: action,
    );
  }
}

final config = Config();
