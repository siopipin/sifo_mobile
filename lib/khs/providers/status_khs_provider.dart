import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisfo_mobile/khs/models/status_krs_model.dart';
import 'package:sisfo_mobile/services/api_base_helper.dart';
import 'package:sisfo_mobile/services/app_exceptions.dart';
import 'package:sisfo_mobile/services/storage.dart';

enum StateStatusKhs { initial, loading, loaded, nulldata, error }

class StatusKhsProvider extends ChangeNotifier {
  initial({required String tahunid}) async {
    setStateStatusKhs = StateStatusKhs.initial;
    await fetchStatusKhs(tahunid: tahunid);
  }

  StateStatusKhs _stateStatusKhs = StateStatusKhs.initial;
  StateStatusKhs get stateStatusKhs => _stateStatusKhs;
  set setStateStatusKhs(val) {
    _stateStatusKhs = val;
    notifyListeners();
  }

  StatusKrsModel _statusKrsModel = StatusKrsModel();
  StatusKrsModel get dataStatusKrs => _statusKrsModel;
  set setStatusKrs(val) {
    _statusKrsModel = val;
    notifyListeners();
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> fetchStatusKhs({required String tahunid}) async {
    setStateStatusKhs = StateStatusKhs.loading;
    print('url: /status-krs/$tahunid');
    var _token = await store.showToken();

    final response = await _helper.get(
        url: '/mahasiswa/status-krs/$tahunid', needToken: true, token: _token);

    switch (response[0]) {
      case null:
        setStateStatusKhs = StateStatusKhs.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateStatusKhs = StateStatusKhs.loaded;
        print('data: ${json.decode(response[1])}');
        setStatusKrs = StatusKrsModel.fromJson(json.decode(response[1]));
        break;
      case 404:
        setStateStatusKhs = StateStatusKhs.nulldata;
        Fluttertoast.showToast(msg: 'KRS tidak ditemukan');
        throw UnauthorisedException('KRS tidak ditemukan');
      case 401:
        setStateStatusKhs = StateStatusKhs.error;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        setStateStatusKhs = StateStatusKhs.error;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }
  }
}
