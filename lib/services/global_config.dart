import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Config {
  final colorPrimary = Color(0xFFCC0000);
  final colorSecondary = Color(0xFFFFEB3B);
  final colorBackground = Color(0xFF3E4095);
  final colorGrey = Color(0xFFF5F5F7);

  final fontPrimary = Color(0xFF3E4095);
  final fontBlack = Color(0xFF000000);
  final fontWhite = Color(0xFFFFFFFF);

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
  final api = "http://127.0.0.1:3000/mobile";
  final fotoUrl = "http://localhost:3000/images";
  final apiPdf = 'http://103.167.34.22/sisfo/jur/krs.cetak.php?khsid=';
  final imgurl = 'http://103.167.34.22/sisfo';

//Production
  // static final api = 'http://192.168.40.6:3000/mobile';
  // static final fotoUrl = 'http://192.168.40.6:3000/images';
  // static final apiPdf = 'http://103.167.34.22/sisfo/jur/krs.cetak.php?khsid=';
  // static final imgurl = 'http://103.167.34.22/sisfo';

//logo
  final String logoPath = 'assets/images/logo.png';
  final String bgPath = 'assets/images/bg-stikes.jpg';

  final header = {
    'Content-Type': 'application/json',
  };
}

final config = Config();
