import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const bgColor = Color(0xFF3E4095);
const primaryYellow = Color(0xFFFFEB3B);
const primaryRed = Color(0xFFCC0000);
const textWhite = Color(0xFFFFFFFF);
const textBlack = Color(0xFF000000);
const textPrimary = Color(0xFF3E4095);
const grey = Color(0xFFF5F5F7);
const navigationColor = Color(0xFFCC0000);
const appbarColor = Color(0xFFCC0000);

//SplashScreen
const colorbgSplashScreen = Color(0xFFCC0000);
const colorButtonSplashScreen = Color(0xFFFFEB3B);

//Currency
final rpFormat =
    new NumberFormat.currency(locale: "id_ID", symbol: "Rp.", decimalDigits: 0);

const appTitle = TextStyle(
    fontSize: 30, fontWeight: FontWeight.bold, height: 1.5, color: textWhite);

//TODO Ganti API
// const api = 'http://10.0.2.2:3000/mobile';

const api = 'http://36.94.36.7:3000/mobile';
const apiPdf = 'http://36.94.36.7/sisfo/jur/krs.cetak.php?khsid=';
const imgurl = 'http://36.94.36.7/sisfo';

// const api = 'http://10.0.2.2:3000/mobile';
final header = {
  'Content-Type': 'application/json',
};

// final headerJwt = {
//   'Content-Type': 'application/json',
//   HttpHeaders.authorizationHeader: 'Barer $token'
// };
