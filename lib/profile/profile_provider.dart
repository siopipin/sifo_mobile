import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sisfo_mobile/profile/profile_model.dart';
import 'package:sisfo_mobile/providers/global_config.dart';
import 'package:sisfo_mobile/providers/storage.dart';

class ProfileProvider extends ChangeNotifier {
  http.Response response;

  bool loading = false, error = false, data = false;
  String msg = '';
  ProfileModel _profileModel;

  ProfileModel get dataMahasiswa => _profileModel;
  bool get isData => data;

  set setError(val) {
    error = val;
    notifyListeners();
  }

  set setLoading(val) {
    loading = val;
    notifyListeners();
  }

  set setDataStatus(val) {
    data = val;
    notifyListeners();
  }

  set setMessage(val) {
    msg = val;
    notifyListeners();
  }

  set setDataMhs(val) {
    _profileModel = val;
    notifyListeners();
  }

  doGetProfile() async {
    setLoading = true;
    response = await getProfileMhs();
    if (response != null) {
      if (response.statusCode == 200) {
        var tmp = json.decode(response.body);
        setDataMhs = ProfileModel.fromJson(tmp);
        setDataStatus = true;
      } else if (response.statusCode == 401) {
        setMessage = 'NIM atau kata sandi salah!';
      } else {
        setMessage = 'Silahkan coba lagi!';
      }
    } else {
      print('Response tidak ditemukan');
    }
  }

  getProfileMhs() async {
    var token = await store.token();
    print(token);
    final headerJwt = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Barer $token'
    };
    try {
      response = await http.get('$api/mahasiswa/profile', headers: headerJwt);
      setLoading = false;
      return response;
    } catch (e) {
      print(e.toString());
      setLoading = false;
      setError = true;
      setMessage = 'Coba lagi, tidak dapat menghubungkan';
    }
  }
}
