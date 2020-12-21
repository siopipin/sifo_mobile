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

//Currency
final rpFormat = new NumberFormat.currency(locale: "id_ID", symbol: "Rp.");

const appTitle = TextStyle(
    fontSize: 30, fontWeight: FontWeight.bold, height: 1.5, color: textWhite);

//TODO Ganti API
// const apilocal = 'http://10.0.2.2:3000/mobile';

// const api = 'http://36.94.36.7:3000/mobile';
const api = 'http://10.0.2.2:3000/mobile';
final header = {
  'Content-Type': 'application/json',
};

// final headerJwt = {
//   'Content-Type': 'application/json',
//   HttpHeaders.authorizationHeader: 'Barer $token'
// };
