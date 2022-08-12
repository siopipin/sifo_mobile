import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisfo_mobile/khs/models/tahun_khs_model.dart';
import 'package:sisfo_mobile/services/api_base_helper.dart';
import 'package:sisfo_mobile/services/app_exceptions.dart';
import 'package:sisfo_mobile/services/storage.dart';

enum StateTahunKhs { initial, loading, loaded, nulldata, error }

class TahunKhsProvider extends ChangeNotifier {
  initial() async {
    setStateTahunKhs = StateTahunKhs.initial;
    await fetchTahunKhs();
  }

  StateTahunKhs _stateTahunKhs = StateTahunKhs.initial;
  StateTahunKhs get stateTahunKhs => _stateTahunKhs;
  set setStateTahunKhs(val) {
    _stateTahunKhs = val;
    notifyListeners();
  }

  TahunKhsModel _tahunKhsModel = TahunKhsModel();
  TahunKhsModel get dataTahunKhs => _tahunKhsModel;
  set setTahunKrs(val) {
    _tahunKhsModel = val;
    notifyListeners();
  }

  String _tahun = '';
  String get tahun => _tahun;
  set setTahun(val) {
    _tahun = val;
    notifyListeners();
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<void> fetchTahunKhs() async {
    setStateTahunKhs = StateTahunKhs.loading;
    var _token = await store.showToken();
    final response = await _helper.get(
        url: '/mahasiswa/tahun-khs', needToken: true, token: _token);

    switch (response[0]) {
      case null:
        setStateTahunKhs = StateTahunKhs.error;
        Fluttertoast.showToast(
          msg: "Error During Communication",
        );
        throw BadRequestException('Error During Communication');
      case 200:
        setStateTahunKhs = StateTahunKhs.loaded;
        setTahunKrs = TahunKhsModel.fromJson(json.decode(response[1]));
        break;
      case 404:
        setStateTahunKhs = StateTahunKhs.nulldata;
        Fluttertoast.showToast(msg: 'Tahun Khs tidak ditemukan');
        throw UnauthorisedException('Tahun Khs tidak ditemukan');
      case 401:
        setStateTahunKhs = StateTahunKhs.error;
        Fluttertoast.showToast(msg: 'NPM atau kata sandi salah, coba lagi!');
        throw UnauthorisedException('Unauthorised');
      default:
        setStateTahunKhs = StateTahunKhs.error;
        Fluttertoast.showToast(msg: 'Invalid Request');
        throw BadRequestException('Invalid Request');
    }
  }
}
