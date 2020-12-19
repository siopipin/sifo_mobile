import 'package:flutter/material.dart';

const bgColor = Color(0xFF3E4095);
const primaryYellow = Color(0xFFFFFB00);
const primaryRed = Color(0xFFCC0000);
const textWhite = Color(0xFFFFFFFF);
const textPrimary = Color(0xFF3E4095);
const grey = Color(0xFFF5F5F7);

const appTitle = TextStyle(
    fontSize: 30, fontWeight: FontWeight.bold, height: 1.5, color: textWhite);

const api = 'http://36.94.36.7:3000';
final header = {
  'Content-Type': 'application/json',
};

// final headerJwt = {
//   'Content-Type': 'application/json',
//   HttpHeaders.authorizationHeader: 'Barer $token'
// };
