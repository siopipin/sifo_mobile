import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/services/storage.dart';

class InitialProvider extends ChangeNotifier {
  initial() {
    setInitialPage = 'SPLASH';
    cekInitialPage();
  }

  String initialPage = 'SPLASH';
  String get getInitialPage => initialPage;
  set setInitialPage(val) {
    initialPage = val;
    notifyListeners();
  }

  cekInitialPage() async {
    dynamic splash = await store.showSplash();
    dynamic token = await store.showToken();

    if (splash == null) {
      setInitialPage = 'SPLASH';
    } else if (splash != null && token == null) {
      setInitialPage = 'LOGIN';
    } else {
      setInitialPage = 'HOME';
    }
  }

  //Storage
  Storage data = Storage();

  Future<String> getID() async {
    String val = '';
    await data.showNPM().then((value) {
      if (value == null) {
        val = '';
      } else {
        val = value;
      }
    });
    return val;
  }

  Future<String> getToken() async {
    String val = '';
    await data.showToken().then((value) {
      if (value == null) {
        val = '';
      } else {
        val = value;
      }
    });
    return val;
  }

  //Ganti foto
  ImagePicker picker = ImagePicker();

  XFile? _file;
  XFile get file => _file!;
  set setFile(val) {
    _file = val;
    notifyListeners();
  }

  Future<bool> updateFoto() async {
    var _status;

    try {
      var _token = await store.showToken();

      var headers = {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Barer $_token'
      };
      final mimeTypeData =
          lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])?.split('/');
      var uri = Uri.parse(config.api + '/mahasiswa/foto');
      var req = http.MultipartRequest("PUT", uri);
      req.headers.addAll(headers);
      req.files.add(await http.MultipartFile.fromPath('images', file.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1])));

      await req.send().then((response) {
        print('status code: ${response.statusCode}');
        if (response.statusCode == 200) {
          _status = true;
        } else {
          _status = false;
        }
      });
    } catch (e) {
      print(e.toString());
      _status = false;
    }

    return _status;
  }
}
