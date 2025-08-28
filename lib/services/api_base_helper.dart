// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:http/http.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class ApiBaseHelper {
  Client http = Client();

  Future<dynamic> get({
    required String url,
    bool needToken = false,
    String token = '',
  }) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(config.api + url),
          headers: needToken
              ? {
                  'Content-Type': 'application/json',
                  HttpHeaders.authorizationHeader: 'Barer $token'
                }
              : null);
      responseJson = [response.statusCode, response.body];
    } on SocketException {
      responseJson = [null, null];
    }

    return responseJson;
  }

  Future<dynamic> post({
    required String url,
    bool needToken = false,
    String token = '',
    required var data,
  }) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(config.api + url),
          body: data,
          headers: needToken
              ? {
                  'Content-Type': 'application/json',
                  HttpHeaders.authorizationHeader: 'Barer $token'
                }
              : null);
      responseJson = [response.statusCode, response.body];
    } on SocketException {
      responseJson = [null, null];
    }
    return responseJson;
  }

  Future<dynamic> put({
    required String url,
    bool needToken = false,
    String token = '',
    required var data,
  }) async {
    var responseJson;
    try {
      final response = await http.put(Uri.parse(config.api + url),
          body: data,
          headers: needToken
              ? {
                  'Content-Type': 'application/json',
                  HttpHeaders.authorizationHeader: 'Barer $token'
                }
              : null);
      responseJson = [response.statusCode, response.body];
    } on SocketException {
      responseJson = [null, null];
    }
    return responseJson;
  }
}
